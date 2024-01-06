// Import the dart convert library to use json encoding and decoding
import 'dart:convert';

// Import the flutter foundation package to use the ChangeNotifier class
import 'package:flutter/foundation.dart';
// Import the http package to make http requests
import 'package:http/http.dart' as http;

// Define a class for the product with the ChangeNotifier mixin
class Product with ChangeNotifier {
  // Declare final string variables for the product id, title, description, and image url
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  // Declare a final double variable for the product price
  final double price;
  // Declare a boolean variable for the product favorite status
  bool isFavorite;

  // Use a constructor to initialize the product properties
  Product({
    // Use the @required annotation to indicate that the parameters are required
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    // Use a default value of false for the isFavorite parameter
    this.isFavorite = false,
  });

  // Define an asynchronous method to toggle the favorite status of the product
  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    // Store the old favorite status in a variable
    final oldSates = isFavorite;
    // Set the favorite status to the opposite of the current value
    isFavorite = !isFavorite;
    // Notify the listeners that the product has changed
    notifyListeners();
    // Declare a url variable for the user favorites endpoint with the authentication token, the user id, and the product id
    final url = Uri.parse(
        'https://shop-7c64f-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$authToken');
    // Use a try-catch block to handle any errors that may occur
    try {
      // Await the http put request to the url with the favorite status as the body and store the response
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      // Check if the response status code is greater than or equal to 400
      if (response.statusCode >= 400) {
        // Restore the old favorite status
        isFavorite = oldSates;
        // Notify the listeners that the product has changed
        notifyListeners();
      }
    } catch (error) {
      // Restore the old favorite status
      isFavorite = oldSates;
      // Notify the listeners that the product has changed
      notifyListeners();
    }
  }
}
