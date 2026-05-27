class ApiException implements Exception {
  final String message;

  /// HTTP status code that triggered the error, when the failure originated
  /// from a server response. Null for transport-level errors (no connection,
  /// timeout, malformed body).
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
