// Import the dart convert library to use json encoding and decoding
import 'dart:convert';

// Import the flutter foundation package to use widgets and themes
import 'package:flutter/foundation.dart';
// Import the http package to make http requests
import 'package:http/http.dart' as http;
// Import the cart class from the current folder
import './cart.dart';

// Define a class for the order item
class OrderItem {
  // Declare final string variables for the order id
  final String id;
  // Declare a final double variable for the order amount
  final double amount;
  // Declare a final list of cart item objects for the order products
  final List<CartItem> products;
  // Declare a final date time variable for the order date and time
  final DateTime dateTime;

  // Use a constructor to initialize the order item properties
  OrderItem({
    // Use the @required annotation to indicate that the parameters are required
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

// Define a class for the orders with the ChangeNotifier mixin
class Orders with ChangeNotifier {
  // Declare a list of order item objects
  List<OrderItem> _orders = [];
  // Declare final string variables for the authentication token and the user id
  final String authToken;
  final String userId;

  // Use a constructor to initialize the token, the user id, and the orders
  Orders(this.authToken, this.userId, this._orders);

  // Define a getter method to return a copy of the orders list
  List<OrderItem> get orders {
    return [..._orders];
  }

  // Define an asynchronous method to fetch and set the orders from the database
  Future<void> fetchAndSetOrders() async {
    // Declare a url variable for the orders endpoint with the authentication token and the user id
    final url = Uri.parse(
        'https://shop-7c64f-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    // Await the http get request to the url and store the response
    final response = await http.get(url);
    // Declare a list of order item objects for the loaded orders
    final List<OrderItem> loadedOrders = [];
    // Decode the response body as a map of string and dynamic values
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // Check if the extracted data is null and return if so
    if (extractedData == null) {
      return;
    }
    // Use the forEach method to iterate over the extracted data
    extractedData.forEach((orderId, orderData) {
      // Add a new order item object to the loaded orders list with the order data and the order id
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          // Parse the order date and time from the order data
          dateTime: DateTime.parse(orderData['dateTime']),
          // Map the order products from the order data to a list of cart item objects
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    // Assign the loaded orders list to the orders list in reverse order
    _orders = loadedOrders.reversed.toList();
    // Notify the listeners that the orders have changed
    notifyListeners();
  }

  // Define an asynchronous method to add a new order to the database
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    // Declare a url variable for the orders endpoint with the authentication token and the user id
    final url = Uri.parse(
        'https://shop-7c64f-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    // Declare a timestamp variable for the current date and time
    final timestamp = DateTime.now();
    // Await the http post request to the url with the order data as the body and store the response
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        // Convert the timestamp to an ISO 8601 string
        'dateTime': timestamp.toIso8601String(),
        // Map the cart products to a list of maps with the product data
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    // Insert a new order item object to the orders list at the beginning with the order data and the generated id from the response
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    // Notify the listeners that the orders have changed
    notifyListeners();
  }
}
