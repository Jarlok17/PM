# PM (Password Manager)

[![Qt](https://img.shields.io/badge/Qt-6.9-green?style=for-the-badge&logo=qt&logoColor=white)](https://doc.qt.io/qt-6.9/)
[![QML](https://img.shields.io/badge/QML-6.9-blue?style=for-the-badge&logo=qt&logoColor=white)](https://doc.qt.io/qt-6/qtqml-index.html)
[![CMake](https://img.shields.io/badge/CMake-3.10+-064F8C?style=for-the-badge&logo=cmake&logoColor=white)](https://cmake.org/)

## 📖 Overview
**PM** is a cross-platform password manager built with **C++/Qt6 + QML**, designed for secure password storage and management.  

---

## ✨ Features
- 🔐 Store and manage passwords  
- 👤 User registration and authentication  
- 📋 Clipboard integration  
- 🎨 QML-based UI with custom theme  
- 📂 Resource and asset support (icons, styles)  

---

## 🚀 Getting Started

### ✅ Prerequisites
- [Qt6 framework](https://doc.qt.io/qt-6/get-and-install-qt.html)  
- [CMake 3.10+](https://cmake.org/download/)  
- A C++23 compiler (g++, clang, or MSVC)  

---

## ⚙️ Installation

### Linux / macOS
```bash
git clone https://github.com/Jarlok17/PM.git
cd PM
mkdir build && cd build
cmake ..
make -j$(nproc)
./PM
```

### 📁 Project Structure
```
.
├── CMakeLists.txt              # Root CMake
├── scripts/                    # Helper scripts
│   ├── build-linux.sh
│   └── run.sh
└── src/
    ├── main.cpp                # Entry point
    ├── clipboard/              # Clipboard manager
    ├── dbmanager/              # Database logic
    ├── passwordmanager/        # Password manager core
    ├── usermanager/            # User management
    ├── ui/                     # QML interface
    │   ├── Main.qml
    │   ├── Pages/              # Pages (Login, Register, Main, Passwords)
    │   ├── assets/             # Resources (icons, qrc)
    │   └── Theme/              # QML theme
    └── pm.desktop              # Linux desktop entry
```

### 📝 License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/Jarlok17/PM/blob/main/LICENSE) file for details.
