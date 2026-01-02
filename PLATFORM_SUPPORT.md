# Platform Support

Graceful HTTP Request is designed to work seamlessly across all Flutter-supported platforms.

## Supported Platforms

| Platform | Status | Notes |
|-----------|---------|-------|
| ✅ Android | Full Support | Requires `INTERNET` permission |
| ✅ iOS | Full Support | No special configuration required |
| ✅ Web | Full Support | Works in all modern browsers |
| ✅ macOS | Full Support | No special configuration required |
| ✅ Windows | Full Support | No special configuration required |
| ✅ Linux | Full Support | No special configuration required |

## Running the Example App

### Android
```bash
cd example
flutter pub get
flutter run -d android
```

### iOS
```bash
cd example
flutter pub get
flutter run -d ios
```

Note: iOS requires a Mac with Xcode installed.

### Web
```bash
cd example
flutter pub get
flutter run -d chrome
```

Or build for web:
```bash
flutter build web
```

### macOS
```bash
cd example
flutter pub get
flutter run -d macos
```

Note: macOS requires a Mac with Xcode installed.

### Windows
```bash
cd example
flutter pub get
flutter run -d windows
```

### Linux
```bash
cd example
flutter pub get
flutter run -d linux
```

## Platform-Specific Considerations

### Android
- **Internet Permission**: The Android manifest includes `INTERNET` permission for network requests
- **Minimum SDK**: Uses Flutter's default minimum SDK (API 21+)
- **Target SDK**: Uses Flutter's latest target SDK

### iOS
- No special configurations required
- Works with all supported iOS versions
- Compatible with both iPhone and iPad

### Web
- Works in all modern browsers (Chrome, Firefox, Safari, Edge)
- Responsive design adapts to different screen sizes
- No web-specific limitations

### Desktop (macOS, Windows, Linux)
- Full functionality supported
- Responsive design adapts to desktop layouts
- No platform-specific limitations

## Dependencies

Since the package is pure Dart code with no native plugins, it has no platform-specific dependencies and works identically across all platforms.

The example app uses:
- `flutter_bloc` for state management (works on all platforms)
- Standard Flutter widgets (works on all platforms)

## Testing Across Platforms

To ensure compatibility, the package should be tested on:

1. **Primary Platforms**:
   - Android (emulator or physical device)
   - iOS (simulator or physical device)
   - Web (Chrome browser)

2. **Secondary Platforms** (recommended for desktop apps):
   - macOS (Mac computer)
   - Windows (Windows computer)
   - Linux (Linux computer)

## Continuous Integration

Consider setting up CI/CD to test across multiple platforms:

```yaml
# Example GitHub Actions matrix
strategy:
  matrix:
    platform: [android, ios, web]
```

## Performance Considerations

- **Mobile**: Optimized for mobile network conditions
- **Desktop**: Works well with stable connections
- **Web**: Handles browser networking properly

All platforms benefit from the same timing improvements:
- Fast responses appear instant
- Slow responses show consistent loading states
- Reduced UI flicker
- Better perceived performance
