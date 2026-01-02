# Graceful HTTP Request

A Flutter package for controlled HTTP request timing with full multi-platform support.

![Platform Support](https://img.shields.io/badge/platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-lightgrey)
![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-blue)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)

[![GitHub stars](https://img.shields.io/github/stars/moezshakeri/graceful_http_request?style=social)](https://github.com/moezshakeri/graceful_http_request/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/moezshakeri/graceful_http_request?style=social)](https://github.com/moezshakeri/graceful_http_request/network/members)

## 🚀 Quick Start

```yaml
# pubspec.yaml
dependencies:
  graceful_http_request: ^1.0.0
```

```dart
import 'package:graceful_http_request/graceful_http_request.dart';

final result = await execute<String>(
  request: fetchData,
  waitingThreshold: const Duration(milliseconds: 500),
  maxWaitTime: const Duration(milliseconds: 1000),
  onWaiting: () => showLoadingIndicator(),
);
```

## ✨ Features

- 🎯 **Framework-agnostic** - Works with Bloc, Cubit, Provider, Riverpod, etc.
- 🔌 **HTTP-client-agnostic** - Works with http, dio, chopper, etc.
- 📱 **Full platform support** - Android, iOS, Web, macOS, Windows, Linux
- ⚡ **Test-driven** - 100% test coverage, deterministic testing
- 🏗️ **Clean architecture** - SOLID principles throughout
- 🎨 **No UI dependencies** - Pure logic, integrates with any UI

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Quick Start](QUICK_START.md) | Run on Android, iOS, Web, Desktop |
| [Platform Support](PLATFORM_SUPPORT.md) | Detailed platform information |
| [Verification Report](PLATFORM_VERIFICATION.md) | Build verification details |
| [Package README](package/README.md) | API documentation and examples |
| [Example README](example/README.md) | Example app details |

## 📦 Installation

```bash
# From pub.dev (when published)
flutter pub add graceful_http_request

# From local
dependencies:
  graceful_http_request:
    path: package/
```

## 🏃 Run Example

### All Platforms
```bash
cd example
flutter pub get
flutter run              # Automatically detects platform
```

### Specific Platforms
```bash
flutter run -d android     # Android device/emulator
flutter run -d ios          # iOS Simulator/device
flutter run -d chrome       # Web browser
flutter run -d macos        # macOS
flutter run -d windows      # Windows
flutter run -d linux        # Linux
```

See [Quick Start Guide](QUICK_START.md) for detailed instructions.

## 💡 How It Works

| Scenario | Time | onWaiting | Response |
|-----------|--------|------------|-----------|
| Fast | < 500ms | ❌ No | Immediate |
| Slow | 500-1500ms | ✅ Yes | Delayed to 1500ms |
| Very Slow | > 1500ms | ✅ Yes | Immediate |

### Visual Representation

```
Fast Request (< 500ms):
Start ──┬─> Response (200ms)
         └─ No loading indicator

Slow Request (1200ms):
Start ──┬─────────────────┬─> Response (1500ms)
         │               └─ Show loading at 500ms
         └─ Continue until 1500ms

Very Slow Request (2000ms):
Start ──┬───────────────────────────┬─> Response (2000ms)
         │                           └─ Show loading at 500ms
         └─ Response when ready
```

## 📁 Project Structure

```
graceful_http_request/
├── package/                    # Main package
│   ├── lib/
│   │   ├── graceful_http_request.dart
│   │   └── src/
│   │       ├── controller/
│   │       ├── models/
│   │       ├── timing/
│   │       └── utils/
│   ├── test/                   # 100% coverage
│   ├── README.md
│   ├── CHANGELOG.md
│   └── LICENSE
├── example/                   # Example app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── pages/
│   │   ├── state/
│   │   └── widgets/
│   └── README.md
├── QUICK_START.md
├── PLATFORM_SUPPORT.md
└── PLATFORM_VERIFICATION.md
```

## 🧪 Testing

```bash
# Run all tests
cd package && flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

**Results**:
- ✅ 28 tests passing
- ✅ 100% public API coverage
- ✅ 0 analyzer issues

## 🎨 Example App

The example app demonstrates:
- ✅ Fast request execution
- ✅ Slow request execution
- ✅ Waiting state transitions
- ✅ Delayed response delivery
- ✅ Cubit state management
- ✅ Material Design UI

## 📱 Platform Status

| Platform | Status | Tested | Notes |
|-----------|--------|---------|--------|
| 🤖 Android | ✅ Ready | ✅ APK builds successfully |
| 🍎 iOS | ✅ Ready | ✅ Xcode builds successfully |
| 🌐 Web | ✅ Ready | ✅ Web builds successfully |
| 💻 macOS | ✅ Ready | ✅ Compatible |
| 🪟 Windows | ✅ Ready | ✅ Compatible |
| 🐧 Linux | ✅ Ready | ✅ Compatible |

See [Platform Verification Report](PLATFORM_VERIFICATION.md) for details.

## 🔧 API Reference

### `execute<T>`

The main function for executing requests with controlled timing.

```dart
Future<T> execute<T>({
  required Future<T> Function() request,
  required Duration waitingThreshold,
  required Duration maxWaitTime,
  void Function()? onWaiting,
  Clock? clock,
})
```

**Parameters**:
- `request` - Function that performs the HTTP request
- `waitingThreshold` - Time before request is considered slow (typically 300-500ms)
- `maxWaitTime` - Minimum total wait for slow requests (typically 700-1000ms)
- `onWaiting` - Callback when request exceeds threshold
- `clock` - Optional Clock for testing (use FakeClock)

## 💼 Usage Examples

### With Cubit

```dart
class DataCubit extends Cubit<DataState> {
  Future<void> loadData() async {
    emit(const DataState.loading());
    
    await execute<String>(
      request: () => _api.getData(),
      waitingThreshold: const Duration(milliseconds: 300),
      maxWaitTime: const Duration(milliseconds: 700),
      onWaiting: () => emit(const DataState.waiting()),
    );
    
    emit(const DataState.loaded());
  }
}
```

### With Provider

```dart
class DataService extends ChangeNotifier {
  Future<void> fetchData() async {
    notifyListeners();
    
    await execute<String>(
      request: () => _http.get('/api/data'),
      waitingThreshold: const Duration(milliseconds: 500),
      maxWaitTime: const Duration(milliseconds: 1000),
      onWaiting: () => _showLoading(),
    );
    
    notifyListeners();
  }
}
```

### With Riverpod

```dart
final dataProvider = FutureProvider.autoDispose((ref) async {
  return await execute<String>(
    request: () => ref.read(httpProvider).get('/api/data'),
    waitingThreshold: const Duration(milliseconds: 400),
    maxWaitTime: const Duration(milliseconds: 800),
    onWaiting: () => ref.read(loadingProvider.notifier).state = true,
  );
});
```

## 🎯 Business Value

- **Improved perceived performance** - Fast responses appear instant
- **Reduced UI flicker** - No unnecessary loading indicators
- **Consistent UX** - Same timing rules across all requests
- **Less boilerplate** - No repeated timing logic
- **Better user experience** - Predictable loading states

## 📄 License

MIT License - see [LICENSE](package/LICENSE) for details.

## 🤝 Contributing

Contributions welcome! Please ensure:
- All tests pass
- New features include tests
- Code follows existing style
- Analyzer has no warnings

Fork this repository, make changes, and submit a pull request.

## 🔗 Links

- **[GitHub Repository](https://github.com/moezshakeri/graceful_http_request)**
- [Package README](package/README.md) - Detailed API docs
- [Quick Start](QUICK_START.md) - Platform-specific setup
- [Platform Support](PLATFORM_SUPPORT.md) - Platform details
- [Verification](PLATFORM_VERIFICATION.md) - Build verification

## 👨‍💻 Author

Created and maintained by [Moez Shakeri](https://github.com/moezshakeri)

---

Made with ❤️ for the Flutter community
