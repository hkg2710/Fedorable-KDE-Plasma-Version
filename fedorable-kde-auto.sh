#!/bin/bash

# Dừng lại ngay lập tức nếu có lỗi, và báo cáo lỗi
set -euo pipefail
trap 'echo -e "\nERROR at line $LINENO: $BASH_COMMAND (exit code: $?)" >&2' ERR

# --- CẤU HÌNH VÀ BIẾN SỐ ---
LOG_FILE="setup_log.txt"

# Xác định người dùng thực sự (người đã chạy sudo) và thư mục nhà của họ
ACTUAL_USER=${SUDO_USER:-$(logname)}
ACTUAL_HOME=$(getent passwd "$ACTUAL_USER" | cut -d: -f6)

# --- KIỂM TRA BAN ĐẦU ---
if [[ $EUID -ne 0 ]]; then
   echo "Lỗi: Tập lệnh này cần quyền root. Vui lòng chạy với 'sudo'." 1>&2
   exit 1
fi

# Dọn dẹp tệp log cũ khi bắt đầu
> "$LOG_FILE"

# --- CÁC HÀM HỖ TRỢ ---
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') ==> $1" | tee -a "$LOG_FILE"
}

# --- CÁC TÁC VỤ TỰ ĐỘNG ---
configure_dnf() {
    log_action "Cấu hình DNF để tải xuống nhanh hơn..."
    if ! grep -q '^max_parallel_downloads=' /etc/dnf/dnf.conf; then
        echo 'max_parallel_downloads=10' >> /etc/dnf/dnf.conf
    fi
}

install_packages_and_repos() {
    log_action "Bắt đầu cài đặt kho lưu trữ và các gói hệ thống..."
    local REPO_URLS=(
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    )
    local REPO_PACKAGES=("terra-release" "rpmfusion-free-release-tainted" "rpmfusion-nonfree-release-tainted")
    local CODEC_PACKAGES=("ffmpeg" "gstreamer1-plugins-bad-freeworld" "gstreamer1-plugins-ugly" "lame-libs")
    local TOOL_PACKAGES=("dnf-plugins-core" "git" "zsh" "curl" "wget" "unzip" "fontconfig")

    dnf install -y \
        "${REPO_URLS[@]}" "${REPO_PACKAGES[@]}" "${CODEC_PACKAGES[@]}" "${TOOL_PACKAGES[@]}" \
        --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
        --nogpgcheck --allowerasing

    dnf config-manager --set-enabled fedora-cisco-openh264
    log_action "Đã thêm kho lưu trữ. Đang cập nhật hệ thống..."
    dnf upgrade -y --refresh
}

install_firacode_font() {
    log_action "Cài đặt Fira Code Nerd Font..."
    local FONT_DIR="$ACTUAL_HOME/.local/share/fonts"
    local ZIP_PATH="$ACTUAL_HOME/FiraCode.zip"
    sudo -u "$ACTUAL_USER" mkdir -p "$FONT_DIR"
    sudo -u "$ACTUAL_USER" wget -q -O "$ZIP_PATH" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    sudo -u "$ACTUAL_USER" unzip -o "$ZIP_PATH" -d "$FONT_DIR/"
    sudo -u "$ACTUAL_USER" rm "$ZIP_PATH"
    log_action "Xây dựng lại bộ đệm phông chữ..."
    sudo -u "$ACTUAL_USER" fc-cache -fv
}

configure_zsh_and_starship() {
    log_action "Cấu hình Zsh, các plugin và Starship..."
    local ZSH_PATH=$(command -v zsh)
    chsh -s "$ZSH_PATH" "$ACTUAL_USER"
    local ZSH_CUSTOM_PLUGINS="$ACTUAL_HOME/.zsh/plugins"
    sudo -u "$ACTUAL_USER" mkdir -p "$ZSH_CUSTOM_PLUGINS"
    for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
        local PLUGIN_DIR="$ZSH_CUSTOM_PLUGINS/$plugin"
        if [ ! -d "$PLUGIN_DIR" ]; then
            sudo -u "$ACTUAL_USER" git clone --depth 1 "https://github.com/zsh-users/$plugin.git" "$PLUGIN_DIR"
        fi
    done

    sudo -u "$ACTUAL_USER" tee "$ACTUAL_HOME/.zshrc" >/dev/null << 'EOF'
# Tải các plugin Zsh
fpath+=~/.zsh/plugins/zsh-completions
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
autoload -Uz compinit && compinit

# Khởi tạo Starship Prompt
eval "$(starship init zsh)"
EOF

    sudo -u "$ACTUAL_USER" sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
    sudo -u "$ACTUAL_USER" mkdir -p "$ACTUAL_HOME/.config"
    sudo -u "$ACTUAL_USER" starship preset catppuccin-powerline -o "$ACTUAL_HOME/.config/starship.toml"
}

configure_flatpak() {
    log_action "Kích hoạt kho lưu trữ Flathub..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak update -y
}

update_firmware() {
    log_action "Kiểm tra và áp dụng các bản cập nhật firmware..."
    fwupdmgr refresh --force
    fwupdmgr update -y
}

cleanup() {
    log_action "Tất cả hoàn tất! Đang tự động dọn dẹp các tệp tạm..."
    if [ -f "$LOG_FILE" ]; then
        rm -f "$LOG_FILE"
    fi
    rm -f "$0"
}

# --- THỰC THI CHÍNH ---
main() {
    configure_dnf
    install_packages_and_repos
    install_firacode_font
    configure_zsh_and_starship
    configure_flatpak
    update_firmware

    log_action "-----------------------------------------------------"
    log_action "Thiết lập tự động hoàn tất!"
    log_action "Khuyến nghị khởi động lại máy để áp dụng tất cả các thay đổi."
    log_action "-----------------------------------------------------"
    
    cleanup
}

main