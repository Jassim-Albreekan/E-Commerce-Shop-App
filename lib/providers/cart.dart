// Import the flutter foundation package to use widgets and themes
import 'package:flutter/foundation.dart';

// Define a class for the cart item
class CartItem {
  // Declare final string variables for the cart item id and title
  final String id;
  final String title;
  // Declare final int variable for the cart item quantity
  final int quantity;
  // Declare final double variable for the cart item price
  final double price;

  // Use a constructor to initialize the cart item properties
  CartItem({
    // Use the @required annotation to indicate that the parameters are required
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

// Define a class for the cart with the ChangeNotifier mixin
class Cart with ChangeNotifier {
  // Declare a map of string and cart item objects for the cart items
  Map<String, CartItem> _items = {};

  // Define a getter method to return a copy of the cart items map
  Map<String, CartItem> get items {
    return {..._items};
  }

  // Define a getter method to return the number of cart items
  int get itemCount {
    return _items.length;
  }

  // Define a getter method to return the total amount of the cart
  double get totalAmount {
    // Declare a double variable for the total and initialize it to zero
    var total = 0.0;
    // Use the forEach method to iterate over the cart items map
    _items.forEach((key, cartItem) {
      // Add the product of the cart item price and quantity to the total
      total += cartItem.price * cartItem.quantity;
    });
    // Return the total
    return total;
  }

  // Define a method to add an item to the cart
  void addItem(
    // Take the product id, price, and title as parameters
    String productId,
    double price,
    String title,
  ) {
    // Check if the cart items map already contains the product id
    if (_items.containsKey(productId)) {
      // If yes, update the cart item with the same id
      _items.update(
        productId,
        // Use a lambda function to return a new cart item object
        (existingCartItem) => CartItem(
          // Keep the same id, title, and price as the existing cart item
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          // Increment the quantity by one
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // If no, add a new entry to the cart items map with the product id as the key
      _items.putIfAbsent(
        productId,
        // Use a lambda function to return a new cart item object
        () => CartItem(
          // Use the current date and time as the id
          id: DateTime.now().toString(),
          // Use the title and price parameters as the title and price
          title: title,
          price: price,
          // Set the quantity to one
          quantity: 1,
        ),
      );
    }
    // Notify the listeners that the cart has changed
    notifyListeners();
  }

  // Define a method to remove an item from the cart
  void removeItem(String productId) {
    // Remove the entry from the cart items map with the product id as the key
    _items.remove(productId);
    // Notify the listeners that the cart has changed
    notifyListeners();
  }

  // Define a method to remove a single item from the cart
  void removeSingleItem(String productId) {
    // Check if the cart items map does not contain the product id
    if (!_items.containsKey(productId)) {
      // If yes, return from the method
      return;
    }
    // Check if the cart item with the product id has a quantity greater than one
    if (_items[productId].quantity > 1) {
      // If yes, update the cart item with the same id
      _items.update(
          productId,
          // Use a lambda function to return a new cart item object
          (existingCartItem) => CartItem(
                // Keep the same id, title, and price as the existing cart item
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                // Decrement the quantity by one
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      // If no, remove the entry from the cart items map with the product id as the key
      _items.remove(productId);
    }
    // Notify the listeners that the cart has changed
    notifyListeners();
  }

  // Define a method to clear the cart
  void clear() {
    // Assign an empty map to the cart items map
    _items = {};
    // Notify the listeners that the cart has changed
    notifyListeners();
  }
}
