# 🔐 SecurePassGen

> **Smart Passwords, Zero Repeats**

SecurePassGen is a lightweight and secure desktop application built with Lazarus (Free Pascal) for generating strong, customizable passwords with **no repeated characters**.

---

## 🚀 Features

* 🔐 **Crypto-Secure Password Generation**

  * Uses Windows secure random API
  * Strong, unpredictable passwords

* 🎛 **Customizable Character Sets**

  * Uppercase (A–Z)
  * Lowercase (a–z)
  * Numbers (0–9)
  * Symbols

* 🎚 **Dynamic Length Control**

  * Easy adjustment via slider (TrackBar)

* 📋 **Auto Clipboard Copy**

  * Instantly copies generated password

* 🧾 **History Logging**

  * Saves passwords locally in log files

* 📤 **Export Function**

  * Export password history to file

* 🌙 **Modern UI**

  * Dark mode
  * Smooth animations
  * Centered responsive layout

---

## 📸 Preview

> *(Add screenshot here later)*

```
[ Password Generator UI Screenshot ]
```

---

## ⚙️ Requirements

* Windows OS
* Lazarus IDE
* Free Pascal Compiler

---

## 🛠 Installation

1. Clone the repository:

```bash
git clone https://github.com/ahmedkz917/SecurePassGen

2. Open the project in Lazarus:

```
SecurePassGen.lpi
```

3. Build and run:

```
Run → Build
Run → Run
```

---

## 🧠 How It Works

* Builds a character set based on user selection
* Uses **crypto-secure randomness (RtlGenRandom)**
* Shuffles characters (Fisher–Yates algorithm)
* Generates password with **no duplicate characters**

---

## ⚠️ Notes

* Password length is limited by the number of unique characters selected
* For maximum strength, enable all character options

---

## 👨‍💻 Author

**Ahmed Kz <KoaSoft>**

---

## 📄 License

This project is licensed under the MIT License.

---

## ⭐ Support

If you like this project:

* ⭐ Star this repository
* 🍴 Fork it
* 🛠 Contribute improvements

---

## 🔮 Future Improvements

* 📊 Password strength meter
* 🚫 Exclude similar characters (O, 0, l, I)
* 🌐 Multi-platform support
* 🔐 Encrypted password storage

---
