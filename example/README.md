# Graceful HTTP Request Example

This example demonstrates how to use `graceful_http_request` package in a Flutter application with Cubit state management.

**Author**: [Moez Shakeri](https://github.com/moezshakeri)  
**Package Repository**: https://github.com/moezshakeri/graceful_http_request

## Features

- Demonstrates fast request execution (< 500ms)
- Demonstrates slow request execution (> 500ms)
- Shows waiting state transitions
- Shows delayed response delivery
- Implements Cubit-based state management

## How to Run

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## Scenarios

### Fast Request
- Click "Execute Fast Request"
- Request completes in 200ms (before 500ms threshold)
- No waiting indicator shown
- Response displayed immediately

### Slow Request
- Click "Execute Slow Request"
- Request takes 1200ms (exceeds 500ms threshold)
- After 500ms, waiting indicator appears
- Response held until 1500ms total time
- Then response is displayed

## Key Concepts Demonstrated

1. **Integration with Cubit**: Shows how to integrate the package with Cubit state management
2. **Waiting State**: Demonstrates how to show loading indicators only when needed
3. **Controlled Timing**: Shows how the package manages response timing
4. **Error Handling**: Demonstrates error propagation through the package

## Code Structure

- `main.dart`: App entry point and BlocProvider setup
- `pages/home_page.dart`: Main UI with request buttons
- `state/request_cubit.dart`: Cubit managing request state
- `widgets/request_status_widget.dart`: Widget displaying request status

## Customization

You can modify the timing thresholds in `request_cubit.dart`:

```dart
await execute<String>(
  request: () => _simulateRequest(type),
  waitingThreshold: const Duration(milliseconds: 500),  // Adjust this
  maxWaitTime: const Duration(milliseconds: 1000),       // Adjust this
  onWaiting: () {
    emit(state.copyWith(isWaiting: true));
  },
);
```

## Learning Resources

- For the main package documentation, see [package/README.md](../package/README.md)
- For Flutter state management, see [flutter_bloc documentation](https://bloclibrary.dev/)
