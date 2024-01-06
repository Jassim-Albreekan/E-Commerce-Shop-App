// Import the dart convert library to use json encoding and decoding
import 'dart:convert';

// Import the flutter material package to use widgets and themes
import 'package:flutter/material.dart';
// Import the http package to make http requests
import 'package:http/http.dart' as http;
// Import the http exception class from the models folder
import 'package:shope/models/http_exception.dart';

// Import the product class from the current folder
import './product.dart';

// Define a class for the products with the ChangeNotifier mixin
class Products with ChangeNotifier {
  // Declare a list of product objects
  List<Product> _items = [];

  // Declare final string variables for the authentication token and the user id
  final String authToken, userId;

  // Use a constructor to initialize the token, the items, and the user id
  Products(this.authToken, this._items, this.userId);

  // Define a getter method to return a copy of the items list
  List<Product> get items {
    return [..._items];
  }

  // Define a getter method to return a list of the favorite items
  List<Product> get favoriteItems {
    // Use the where method to filter the items by the isFavorite property
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  // Define a method to find a product by its id
  Product findById(String id) {
    // Use the firstWhere method to return the first product that matches the id
    return _items.firstWhere((prod) => prod.id == id);
  }

  // Define an asynchronous method to fetch and set the products from the database
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    // Declare a string variable for the filter query parameter
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    // Declare a url variable for the products endpoint with the authentication token and the filter string
    final url = Uri.parse(
        'https://shop-7c64f-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString');
    // Use a try-catch block to handle any errors that may occur
    try {
      // Await the http get request to the url and store the response
      final response = await http.get(url);
      // Decode the response body as a map of string and dynamic values
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      // Declare a list of product objects for the loaded products
      final List<Product> loadedProducts = [];
      // Check if the extracted data is null and return if so
      if (extractedData == null) {
        return;
      }
      // Declare a url variable for the user favorites endpoint with the authentication token and the user id
      final urlF = Uri.parse(
          'https://shop-7c64f-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      // Await the http get request to the url and store the response
      final favoriteResponse = await http.get(urlF);
      // Decode the response body as a map of string and dynamic values
      final favoriteData = json.decode(favoriteResponse.body);

      // Use the forEach method to iterate over the extracted data
      extractedData.forEach((productId, productData) {
        // Add a new product object to the loaded products list with the product data and the product id
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          // Check if the favorite data is null or does not contain the product id and assign the isFavorite property accordingly
          isFavorite:
              favoriteData == null ? false : favoriteData[productId] ?? false,
          imageUrl: productData['imageUrl'],
        ));
      });
      // Assign the loaded products list to the items list
      _items = loadedProducts;
      // Notify the listeners that the products have changed
      notifyListeners();
      // Print the decoded response body to the console for debugging purposes
      print(json.decode(response.body));
    } catch (error) {
      // Print the error to the console for debugging purposes
      print(error);
      // Throw the error to be handled by the caller
      throw (error);
    }
  }

  // Define an asynchronous method to add a new product to the database
  Future<void> addProduct(Product product) async {
    // Declare a url variable for the products endpoint with the authentication token
    final url = Uri.parse(
        'https://shop-7c64f-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    // Use a try-catch block to handle any errors that may occur
    try {
      // Await the http post request to the url with the product data as the body and store the response
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      // Create a new product object with the product data and the generated id from the response
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      // Add the new product to the items list
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      // Notify the listeners that the products have changed
      notifyListeners();
    } catch (error) {
      // Print the error to the console for debugging purposes
      print(error);
      // Throw the error to be handled by the caller
      throw error;
    }
  }

  // Define an asynchronous method to update an existing product in the database
  Future<void> updateProduct(String id, Product newProduct) async {
    // Find the index of the product in the items list by its id
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    // Check if the index is valid
    if (prodIndex >= 0) {
      // Declare a url variable for the specific product endpoint with the authentication token
      final url = Uri.parse(
          'https://shop-7c64f-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');
      // Await the http patch request to the url with the new product data as the body
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      // Assign the new product to the items list at the found index
      _items[prodIndex] = newProduct;
      // Notify the listeners that the products have changed
      notifyListeners();
    } else {
      // Print a message to the console if the index is not valid
      print('...');
    }
  }

// Define an asynchronous method to delete a product from the database
  Future<void> deleteProduct(String id) async {
    // Declare a url variable for the specific product endpoint with the authentication token
    final url = Uri.parse(
        'https://shop-7c64f-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');
    // Find the index of the product in the items list by its id
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    // Store the existing product in a variable
    var existingProduct = _items[existingProductIndex];
    // Remove the product from the items list at the found index
    _items.removeAt(existingProductIndex);
    // Remove the product from the items list at the found index again (this seems redundant)
    _items.removeAt(existingProductIndex);
    // Notify the listeners that the products have changed
    notifyListeners();
    // Await the http delete request to the url and store the response
    final response = await http.delete(url);
    // Check if the response status code is greater than or equal to 400
    if (response.statusCode >= 400) {
      // Insert the existing product back to the items list at the original index
      _items.insert(existingProductIndex, existingProduct);
      // Notify the listeners that the products have changed
      notifyListeners();
      // Throw an http exception with a message
      throw HttpException('Could not delete product.');
    }
    // Set the existing product to null
    existingProduct = null;
  }
}
