# Contributing to Graceful HTTP Request

Thank you for your interest in contributing to Graceful HTTP Request!

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/moezshakeri/graceful_http_request.git
   ```
3. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

1. Install dependencies:
   ```bash
   cd package
   flutter pub get
   ```

2. Run tests to ensure everything works:
   ```bash
   flutter test
   ```

3. Run analyzer to check for issues:
   ```bash
   flutter analyze
   ```

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter analyze` to ensure code passes all checks
- All public APIs must be documented with DartDoc
- Keep code simple and readable

## Testing

This project follows **Test-Driven Development (TDD)**:

1. Write a failing test first
2. Implement the minimal code to make the test pass
3. Refactor if needed
4. Run all tests to ensure nothing broke

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/controller/graceful_request_controller_test.dart

# Run with coverage
flutter test --coverage
```

### Test Requirements

- All new features must include tests
- Aim for 100% public API coverage
- Tests should be deterministic (no real time delays)
- Use `FakeClock` for timing tests

## Submitting Changes

1. Ensure all tests pass: `flutter test`
2. Ensure no analyzer issues: `flutter analyze`
3. Commit your changes with a clear message
4. Push to your fork
5. Create a pull request on GitHub

### Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Example:
```
feat: add custom waiting strategy support

Users can now provide their own waiting strategy
implementation for custom timing behavior.

Fixes #42
```

## Pull Request Guidelines

- Title should follow commit message format
- Description should explain the what and why
- Link to related issues (e.g., "Fixes #42")
- Ensure CI checks pass
- Request review from maintainers

## Project Structure

```
graceful_requests/
├── package/              # Main package code
│   ├── lib/src/         # Source code (implementation details hidden)
│   ├── lib/              # Public API
│   └── test/            # Tests (100% coverage)
├── example/              # Example Flutter app
├── requirements/          # Original requirements
└── *.md                 # Documentation
```

## Design Principles

1. **Clean Architecture**: Separate concerns, use dependency injection
2. **SOLID Principles**: Single responsibility, open/closed, etc.
3. **Test-Driven**: Write tests first, production code second
4. **Framework Agnostic**: Work with any state management
5. **Platform Agnostic**: Work with any HTTP client

## Questions or Issues?

- Open an issue on [GitHub](https://github.com/moezshakeri/graceful_http_request/issues)
- Check existing issues first
- Provide detailed information about bugs or feature requests

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Welcome new contributors
- Focus on what is best for the community

Thank you for contributing! 🚀
