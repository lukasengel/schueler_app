class WebDataException implements Exception {
  final String error;
  final String details;

  @override
  String toString() {
    return "$error: $details";
  }

  WebDataException(this.error, this.details);

  WebDataException.noData()
      : error = "ERROR FETCHING DATA",
        details = "No Response";
  WebDataException.unauthorized()
      : error = "HTTP-Status 401",
        details = "Unauthorized";
  WebDataException.forbidden()
      : error = "HTTP-Status 403",
        details = "Forbidden";
  WebDataException.notFound()
      : error = "HTTP-Status 404",
        details = "Not Found";
  WebDataException.unknownHttpError(int statusCode)
      : error = "HTTP-Status $statusCode",
        details = "Unknown Error";
}
