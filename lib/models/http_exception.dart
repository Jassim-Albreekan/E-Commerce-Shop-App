// Define a class for the http exception that implements the Exception interface
class HttpException implements Exception {
  // Declare a final string variable for the exception message
  final String message;
  // Use a constructor to initialize the exception message
  HttpException(this.message);

  // Override the toString method to return the exception message
  @override
  String toString() {
    return message;
  }
}
