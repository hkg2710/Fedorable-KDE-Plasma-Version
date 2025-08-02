# Fedorable KDE - Kịch bản Tự động hóa sau Cài đặt

[![Giấy phép: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Phiên bản](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/hkg2710/Fedorable-KDE-Plasma-Version)
![Hỗ trợ Fedora](https://img.shields.io/badge/Fedora-51A2DA?logo=fedora&logoColor=white)

Đây là một kịch bản shell tự động hóa hoàn toàn, được thiết kế để thiết lập một môi trường làm việc hiệu quả và đẹp mắt trên bản cài đặt mới của **Fedora KDE Spin**.

Kịch bản sẽ thực hiện tất cả các tác vụ tẻ nhạt sau khi cài đặt hệ điều hành, giúp bạn tiết kiệm thời gian và có ngay một hệ thống sẵn sàng để làm việc và giải trí.

## ✨ Các tính năng chính

Kịch bản sẽ tự động thực hiện các tác vụ sau:

*   **🚀 Tăng tốc DNF**: Cấu hình DNF để cho phép tải xuống 10 gói song song, giúp tăng tốc độ cài đặt và cập nhật.
*   **📦 Kích hoạt kho lưu trữ**: Tự động thêm và kích hoạt các kho lưu trữ thiết yếu:
    *   RPM Fusion (free và non-free)
    *   RPM Fusion (tainted)
    *   Kho lưu trữ Terra
*   **🎶 Cài đặt Codec & Công cụ**: Cài đặt codec đa phương tiện (ffmpeg, gstreamer) và các công cụ dòng lệnh cần thiết (git, curl, wget...).
*   **⬆️ Cập nhật Hệ thống**: Thực hiện cập nhật toàn bộ hệ thống sau khi đã thêm các kho lưu trữ mới.
*   **💎 Cài đặt Zsh & Starship**:
    *   Cài đặt Zsh và đặt làm shell mặc định.
    *   Cài đặt các plugin hữu ích: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`.
    *   Cài đặt Starship, một prompt đa nền tảng, và áp dụng giao diện `catppuccin-powerline` đẹp mắt.
*   **🔤 Cài đặt Font Lập trình**: Tự động tải và cài đặt **Fira Code Nerd Font**, một font chữ tuyệt vời cho việc lập trình và terminal.
*   **🧩 Thiết lập Flathub**: Thêm kho lưu trữ Flathub để dễ dàng cài đặt các ứng dụng Flatpak.
*   **⚙️ Cập nhật Firmware**: Kiểm tra và cài đặt các bản cập nhật firmware cho phần cứng của bạn.
*   **🧹 Tự động dọn dẹp**: Sau khi chạy xong, kịch bản sẽ tự động xóa chính nó và tệp log để giữ hệ thống sạch sẽ.

## 📋 Yêu cầu

*   Một bản cài đặt mới của **Fedora KDE Spin** (khuyến nghị phiên bản 40 trở lên).
*   Kết nối Internet.
*   Quyền `sudo` (kịch bản sẽ tự kiểm tra).

## 🚀 Cách sử dụng

> **CẢNH BÁO BẢO MẬT**
> Trước khi chạy bất kỳ kịch bản nào từ Internet với quyền `sudo`, bạn nên luôn kiểm tra nội dung của nó để hiểu rõ nó sẽ làm gì với hệ thống của bạn. Kịch bản này được thiết kế để an toàn, nhưng việc kiểm tra là một thói quen tốt.

Bạn có thể chạy kịch bản này bằng một trong hai cách sau:

### Cách 1: Nhanh gọn (One-Liner)

Mở terminal (Konsole) và dán lệnh sau:

```bash
curl -fsSL https://raw.githubusercontent.com/hkg2710/Fedorable-KDE-Plasma-Version/main/fedorable-kde-auto.sh | sudo bash
```

### Cách 2: An toàn hơn (Khuyến khích)

Cách này cho phép bạn xem lại kịch bản trước khi chạy.

1.  **Tải kịch bản về:**
    ```bash
    wget https://raw.githubusercontent.com/hkg2710/Fedorable-KDE-Plasma-Version/main/fedorable-kde-auto.sh
    ```

2.  **(Tùy chọn nhưng khuyến khích) Đọc nội dung kịch bản:**
    ```bash
    cat fedorable-kde-auto.sh
    ```

3.  **Cấp quyền thực thi:**
    ```bash
    chmod +x fedorable-kde-auto.sh
    ```

4.  **Chạy kịch bản với quyền sudo:**
    ```bash
    sudo ./fedorable-kde-auto.sh
    ```

Kịch bản sẽ bắt đầu chạy và bạn có thể theo dõi tiến trình trực tiếp trên terminal.

## 🛠️ Các bước sau khi cài đặt

Sau khi kịch bản chạy xong, hãy làm theo các bước sau để hoàn tất thiết lập:

### 1. Khởi động lại hệ thống

Đây là bước quan trọng để tất cả các thay đổi, đặc biệt là cập nhật hệ thống và firmware, được áp dụng đúng cách.
```bash
reboot
```

### 2. Cấu hình Konsole để sử dụng Fira Code Nerd Font

Để tận hưởng giao diện terminal đẹp mắt với Starship, bạn cần đổi font chữ của Konsole:

1.  Mở **Konsole**.
2.  Đi đến `Settings` > `Edit Current Profile...`.
3.  Chọn tab `Appearance`.
4.  Nhấn vào nút `Select Font...`.
5.  Tìm và chọn **FiraCode Nerd Font** (hoặc một biến thể như `FiraCode Nerd Font Mono`).
6.  Nhấn `OK` và `Apply` để lưu thay đổi.

Bây giờ terminal của bạn sẽ hiển thị đúng tất cả các icon và ký tự đặc biệt của prompt Starship.

## ⏪ Gỡ cài đặt

Kịch bản này thực hiện nhiều thay đổi sâu vào hệ thống (cài đặt gói, thay đổi cấu hình) nên không có cách nào "gỡ cài đặt" tự động. Nếu bạn muốn quay trở lại trạng thái ban đầu, cách tốt nhất là cài đặt lại hệ điều hành.

Tuy nhiên, bạn có thể hoàn tác một vài thay đổi một cách thủ công:
*   **Đổi lại shell mặc định thành Bash:** `chsh -s /bin/bash`
*   **Xóa các tệp cấu hình Zsh:** `rm -rf ~/.zshrc ~/.zsh ~/.config/starship.toml`

## 🤝 Đóng góp

Nếu bạn có ý tưởng để cải thiện kịch bản này, đừng ngần ngại mở một [Issue](https://github.com/hkg2710/Fedorable-KDE-Plasma-Version/issues) để thảo luận hoặc tạo một [Pull Request](https://github.com/hkg2710/Fedorable-KDE-Plasma-Version/pulls).

## 📄 Giấy phép

Dự án này được cấp phép theo Giấy phép MIT. Xem file `LICENSE` để biết thêm chi tiết.
