/// Helpers for the API envelope: { status, message, data }.
Map<String, dynamic> asMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  throw const FormatException('Expected a JSON object');
}

/// The `data` object of a response body.
Map<String, dynamic> responseData(Object? body) => asMap(asMap(body)['data']);