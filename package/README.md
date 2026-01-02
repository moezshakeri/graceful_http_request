# Graceful HTTP Request

A Flutter package that provides standardized HTTP request handling with controlled timing behavior. Improve your app's perceived performance by avoiding unnecessary loading states for fast responses and ensuring consistent waiting behavior for slower responses.

[![GitHub stars](https://img.shields.io/github/stars/moezshakeri/graceful_http_request?style=social)](https://github.com/moezshakeri/graceful_http_request/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/moezshakeri/graceful_http_request?style=social)](https://github.com/moezshakeri/graceful_http_request/network/members)

**Author**: [Moez Shakeri](https://github.com/moezshakeri)  
**Repository**: https://github.com/moezshakeri/graceful_http_request

## Platform Support

✅ **Android**  
✅ **iOS**  
✅ **Web**  
✅ **macOS**  
✅ **Windows**  
✅ **Linux**

This package is platform-agnostic and works on all Flutter-supported platforms.

## Purpose

This package helps manage HTTP request timing by:
- Immediately returning fast responses (before `waitingThreshold`)
- Emitting a waiting signal for slow responses (after `waitingThreshold`)
- Delaying response delivery to ensure consistent UX for slow requests
- Being framework-agnostic and HTTP-client-agnostic

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  graceful_http_request: ^1.0.0
```

## Usage

### Basic Example

```dart
import 'package:graceful_http_request/graceful_http_request.dart';

Future<String> fetchData() async {
  // Your HTTP request here
  final response = await http.get(Uri.parse('https://api.example.com/data'));
  return response.body;
}

void makeRequest() async {
  try {
    final result = await execute<String>(
      request: fetchData,
      waitingThreshold: const Duration(milliseconds: 500),
      maxWaitTime: const Duration(milliseconds: 1000),
      onWaiting: () {
        print('Request is taking longer than expected');
        // Show loading indicator here
      },
    );
    print('Result: $result');
  } catch (e) {
    print('Error: $e');
  }
}
```

### How It Works

1. **Fast Response** (< 500ms):
   - Response returned immediately
   - No waiting signal emitted
   - No artificial delay

2. **Slow Response** (between 500ms and 1500ms):
   - `onWaiting` callback called after 500ms
   - Response held until 1500ms total time
   - Then delivered

3. **Very Slow Response** (> 1500ms):
   - `onWaiting` callback called after 500ms
   - Response delivered immediately when ready

### With State Management (Bloc/Cubit)

```dart
class DataCubit extends Cubit<DataState> {
  Future<void> loadData() async {
    emit(const DataState.loading());
    
    try {
      await execute<String>(
        request: () => _fetchFromApi(),
        waitingThreshold: const Duration(milliseconds: 300),
        maxWaitTime: const Duration(milliseconds: 700),
        onWaiting: () {
          emit(const DataState.waiting());
        },
      );
      
      emit(const DataState.loaded());
    } catch (e) {
      emit(DataState.error(e.toString()));
    }
  }
  
  Future<String> _fetchFromApi() async {
    // Your API call
    return 'data';
  }
}
```

## API Reference

### `execute`

The main entry point for executing requests with controlled timing.

```dart
Future<T> execute<T>({
  required Future<T> Function() request,
  required Duration waitingThreshold,
  required Duration maxWaitTime,
  void Function()? onWaiting,
  Clock? clock,
})
```

**Parameters:**

- `request`: A function that performs the HTTP request and returns a Future
- `waitingThreshold`: Time after which the request is considered slow (default: recommended 300-500ms)
- `maxWaitTime`: Minimum total wait time for slow requests (default: recommended 700-1000ms)
- `onWaiting`: Optional callback called when request exceeds `waitingThreshold`
- `clock`: Optional Clock injection for testing purposes

**Behavior:**

| Scenario | onWaiting called? | Response delay |
|----------|-------------------|----------------|
| Completes before threshold | No | None |
| Completes between threshold and maxWait | Yes | Delayed until threshold + maxWait |
| Completes after maxWait | Yes | None |

## Features

- ✅ Framework-agnostic (works with any state management)
- ✅ HTTP-client-agnostic (works with http, dio, etc.)
- ✅ Fully tested (100% public API coverage)
- ✅ Deterministic timing with fake clock support
- ✅ Error handling that preserves timing rules
- ✅ No UI dependencies

## Running the Example

```bash
cd example
flutter pub get
flutter run
```

The example app demonstrates:
- Fast request execution
- Slow request execution
- Waiting state transitions
- Delayed response delivery
- State management with Cubit

## Testing

The package uses a `Clock` abstraction for deterministic testing:

```dart
import 'package:graceful_http_request/graceful_http_request.dart';
import 'package:graceful_http_request/src/utils/clock.dart';

void main() {
  test('example test', () async {
    final clock = FakeClock();
    final completer = Completer<String>();
    
    final future = execute<String>(
      request: () async {
        clock.elapsed(const Duration(milliseconds: 600));
        return completer.future;
      },
      waitingThreshold: const Duration(milliseconds: 500),
      maxWaitTime: const Duration(milliseconds: 1000),
      onWaiting: () {},
      clock: clock,
    );
    
    completer.complete('data');
    await future;
  });
}
```

## Running Tests

```bash
flutter test
```

## License

MIT License - Copyright (c) 2024 Moez Shakeri

## Contributing

Contributions are welcome! Please ensure:
- All tests pass
- New features include tests
- Code follows existing style

**GitHub Repository**: https://github.com/moezshakeri/graceful_http_request

For detailed contributing guidelines, see [CONTRIBUTING.md](../CONTRIBUTING.md) in the root directory.

- **Improved perceived performance**: Fast responses appear instant
- **Reduced UI flicker**: No unnecessary loading indicators for quick calls
- **Consistent behavior**: Same timing rules across all HTTP interactions
- **Less boilerplate**: No need to implement timing logic repeatedly
