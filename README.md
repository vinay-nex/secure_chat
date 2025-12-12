# Secure Chat - AES-256 Encryption

A professional Flutter web application for encrypting and decrypting messages using AES-256-CBC encryption.

## Features

- 🔐 **AES-256-CBC Encryption** - Industry-standard encryption algorithm
- 🌐 **Cross-Platform** - Works on web, iOS, Android, and desktop
- 🎨 **Modern UI** - Clean and professional Material Design 3 interface
- 📋 **Copy to Clipboard** - Easy sharing of encrypted/decrypted messages
- ✅ **Error Handling** - Comprehensive error messages and validation

## Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/vinay-nex/secure_chat.git
cd secure_chat
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run -d chrome
```

### Building for Web

```bash
flutter build web --release
```

The built files will be in the `build/web` directory.

## How to Use

1. Enter your message in the text field
2. Click **Encrypt** to encrypt your message
3. Click **Decrypt** to decrypt an encrypted message
4. Use the **Copy** button to copy the result to clipboard
5. Use **Clear All** to reset all fields

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   └── encryption_screen.dart  # Main encryption UI
└── services/
    └── encryption_service.dart # AES-256 encryption logic
```

## Technologies Used

- **Flutter** - UI framework
- **encrypt** - AES-256 encryption package
- **Google Fonts** - Noto Sans font family

## Security Note

⚠️ **Important**: This is a demo application. The encryption key is hardcoded for demonstration purposes. For production use, implement proper key management and storage.

## License

This project is open source and available under the MIT License.

## Contributing

Contributions, issues, and feature requests are welcome!

## Author

Created with ❤️ using Flutter
