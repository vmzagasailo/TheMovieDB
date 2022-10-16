enum ApiClientExceptionType {
  networkError,
  authError,
  otherError,
  sessionExpired,
}

class ApiClientException implements Exception {
  final ApiClientExceptionType typeError;

  ApiClientException(this.typeError);
}
