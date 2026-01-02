/// A Flutter package that provides standardized HTTP request handling
/// with controlled timing behavior.
///
/// This package helps manage request timing by enforcing minimum and maximum
/// wait times, ensuring consistent user experience and preventing race conditions.
library graceful_http_request;

export 'src/graceful_http_request.dart' show execute;
