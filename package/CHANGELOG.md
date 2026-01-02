# Changelog

All notable changes to this project will be documented in this file.

**Maintainer**: [Moez Shakeri](https://github.com/moezshakeri)  
**Repository**: https://github.com/moezshakeri/graceful_http_request

## [1.0.1] - 2026-01-03

### Added
- Added dartdoc comments to all public API elements (100% documentation coverage)
- Added Flutter example app demonstrating package usage
- Fixed pub.dev score issues related to documentation and examples

## [1.0.0] - 2026-01-02

### Added
- Initial release of Graceful HTTP Request package
- Core `execute` function with controlled timing behavior
- `Clock` abstraction with `FakeClock` for testing
- `WaitingStrategy` interface with `DefaultWaitingStrategy` implementation
- `GracefulRequestController` for request orchestration
- `GracefulRequestState` models for state management
- 100% test coverage for public APIs
- Example Flutter app demonstrating fast and slow requests
- Full documentation with usage examples

### Features
- Framework-agnostic design (works with Bloc, Cubit, Provider, Riverpod, etc.)
- HTTP-client-agnostic (works with http, dio, or any other client)
- Deterministic timing with fake clock support
- Proper error handling that preserves timing rules
- No UI dependencies
- Clean architecture following SOLID principles

### Documentation
- Comprehensive README with examples
- Timing diagrams and behavior tables
- Testing guide with fake clock usage
- Example app with Cubit state management
