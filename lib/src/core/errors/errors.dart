/// Barrel file exporting the errors module public API.
///
/// Provides `ValueFailure` for domain validation errors and `GlobalFailure`
/// for infrastructure-level failures, both used as the Left side of
/// `Either` results throughout the application.
library;

export 'failures.dart';
