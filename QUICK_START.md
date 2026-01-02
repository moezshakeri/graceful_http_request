# Quick Start Guide

Run the Graceful HTTP Request example on your preferred platform.

## Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher

## Platform-Specific Instructions

### 🤖 Android

```bash
# Navigate to example directory
cd example

# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run -d android

# Or build APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Requirements**:
- Android device or emulator
- USB debugging enabled
- Minimum Android API 21 (Android 5.0)

---

### 🍎 iOS

```bash
# Navigate to example directory
cd example

# Get dependencies
flutter pub get

# Run on iOS Simulator
flutter run -d ios

# Run on connected device
flutter run -d ios

# Build for release
flutter build ios --release
```

**Requirements**:
- Mac computer
- Xcode installed
- iOS device or Simulator
- Apple Developer account (for device deployment)

---

### 🌐 Web

```bash
# Navigate to example directory
cd example

# Get dependencies
flutter pub get

# Run in Chrome
flutter run -d chrome

# Or build for production
flutter build web --release

# Serve locally
flutter run -d web-server-mheadless
```

**Requirements**:
- Modern web browser (Chrome, Firefox, Safari, Edge)
- Works on all platforms that can run a browser

**After building web**:
```bash
# Serve with any static file server
cd build/web
python3 -m http.server 8000
# Visit http://localhost:8000
```

---

### 💻 macOS

```bash
# Navigate to example directory
cd example

# Get dependencies
flutter pub get

# Run on macOS
flutter run -d macos

# Build for release
flutter build macos --release
```

**Requirements**:
- Mac computer (macOS 10.14+)
- Xcode installed

---

### 🪟 Windows

```bash
# Navigate to example directory
cd example

# Get dependencies
flutter pub get

# Run on Windows
flutter run -d windows

# Build for release
flutter build windows --release
```

**Requirements**:
- Windows 10 or higher
- Visual Studio with Desktop development workload

---

### 🐧 Linux

```bash
# Navigate to example directory
cd example

# Get dependencies
flutter pub get

# Run on Linux
flutter run -d linux

# Build for release
flutter build linux --release
```

**Requirements**:
- Linux distribution
- GTK development libraries:
  ```bash
  sudo apt-get install clang cmake ninja-build pkg-config \
    libgtk-3-dev liblzma-dev libstdc++-10-dev
  ```

---

## Testing the Package

To test the package in your own project:

```bash
# Add to pubspec.yaml
dependencies:
  graceful_http_request:
    path: package/

# Or from pub (when published)
dependencies:
  graceful_http_request: ^1.0.0
```

```dart
import 'package:graceful_http_request/graceful_http_request.dart';

// Use in your app
final result = await execute<String>(
  request: fetchData,
  waitingThreshold: const Duration(milliseconds: 500),
  maxWaitTime: const Duration(milliseconds: 1000),
  onWaiting: () => print('Waiting...'),
);
```

## Troubleshooting

### "No devices found"
```bash
# List available devices
flutter devices

# Check device connection (Android)
adb devices

# Check Simulator (iOS)
open -a Simulator
```

### "CocoaPods not installed" (macOS/iOS)
```bash
# Install CocoaPods
sudo gem install cocoapods

# Update pods
cd ios
pod install
```

### "Flutter command not found"
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Or install Flutter
# Visit: https://flutter.dev/docs/get-started/install
```

### "Linux build fails"
```bash
# Install required dependencies
sudo apt-get update
sudo apt-get install clang cmake ninja-build pkg-config \
  libgtk-3-dev liblzma-dev libstdc++-10-dev
```

---

## What to Try

### Fast Request
Click "Execute Fast Request"
- Request completes in 200ms
- No waiting indicator
- Instant response

### Slow Request
Click "Execute Slow Request"
- Request takes 1200ms
- Waiting indicator appears after 500ms
- Response shown after 1500ms total

---

## Need Help?

- 📖 [Package Documentation](package/README.md)
- 📱 [Platform Support](PLATFORM_SUPPORT.md)
- ✅ [Verification Report](PLATFORM_VERIFICATION.md)
- 💡 [Example App README](example/README.md)
