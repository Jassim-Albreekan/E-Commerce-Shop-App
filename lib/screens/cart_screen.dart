// Import the flutter material package to use widgets and themes
import 'package:flutter/material.dart';
// Import the provider package to use state management
import 'package:provider/provider.dart';

// Import the cart and orders classes from the providers folder
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

// Define a stateless widget class for the cart screen
class CartScreen extends StatelessWidget {
  // Define a constant string for the route name of this screen
  static const routeName = '/cart';

  // Override the build method to return the widget tree for the cart screen
  @override
  Widget build(BuildContext context) {
    // Get the cart object from the provider
    final cart = Provider.of<Cart>(context);
    // Return a scaffold widget with an app bar and a body
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          // Add a card widget to display the total amount of the cart
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Add a text widget to show the label 'Total'
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  // Add a spacer widget to create some space between the text and the chip
                  Spacer(),
                  // Add a chip widget to show the total amount of the cart with a background color
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // Add an order button widget to place the order
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          // Add a sized box widget to create some vertical space
          SizedBox(height: 10),
          // Add an expanded widget to fill the remaining space with a list view of the cart items
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Define a stateful widget class for the order button
class OrderButton extends StatefulWidget {
  // Use a constructor to initialize the cart object as a required parameter
  const OrderButton({Key key, @required this.cart}) : super(key: key);
  // Declare a final variable for the cart object
  final Cart cart;

  // Override the createState method to return an instance of _OrderButtonState
  @override
  State<OrderButton> createState() => _OrderButtonState();
}

// Define a private state class for the order button widget
class _OrderButtonState extends State<OrderButton> {
  // Declare a boolean variable to check if the button is loading
  var _isLoading = false;
  // Override the build method to return the widget tree for the order button
  @override
  Widget build(BuildContext context) {
    // Return a flat button widget with a child and an onPressed function
    return FlatButton(
      child:
          _isLoading == true ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              // Set the _isLoading variable to true and update the state
              setState(() {
                _isLoading = true;
              });
              // Await the addOrder method from the orders provider with the cart items and the total amount as arguments
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              // Set the _isLoading variable to false and update the state
              setState(() {
                _isLoading = false;
              });
              // Call the clear method on the cart object to empty the cart
              widget.cart.clear();
            },
      // Use the primary color of the theme for the text color of the button
      textColor: Theme.of(context).primaryColor,
    );
  }
}
