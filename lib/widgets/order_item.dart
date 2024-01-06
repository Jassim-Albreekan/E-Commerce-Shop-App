// Import the necessary packages and modules
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import the orders provider with an alias
import '../providers/orders.dart' as ord;

// Define the OrderItem class that extends StatefulWidget
class OrderItem extends StatefulWidget {
  // Define the final field for the order data model
  final ord.OrderItem order;

  // Define the constructor that assigns the field from the argument
  OrderItem(this.order);

  // Override the createState method that returns a state object
  @override
  _OrderItemState createState() => _OrderItemState();
}

// Define the _OrderItemState class that extends State<OrderItem>
class _OrderItemState extends State<OrderItem> {
  // Define a variable for the expanded flag
  var _expanded = false;

  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Return an AnimatedContainer widget that animates the height change
    return AnimatedContainer(
      // Set the duration of the animation to 300 milliseconds
      duration: Duration(milliseconds: 300),
      // Set the height of the container based on the expanded flag and the number of products
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      // Set the child widget to a Card widget that displays the order information and details
      child: Card(
        // Set the margin of the card
        margin: EdgeInsets.all(10),
        // Set the child widget to a Column widget that arranges the widgets vertically
        child: Column(
          // Set the list of widgets for the column
          children: <Widget>[
            // Set the first widget to a ListTile widget that displays the order amount, date, and expand icon
            ListTile(
              // Set the title widget to a Text widget that shows the order amount
              title: Text('\$${widget.order.amount}'),
              // Set the subtitle widget to a Text widget that shows the order date formatted
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              // Set the trailing widget to an IconButton widget that toggles the expanded flag
              trailing: IconButton(
                // Set the icon widget to an Icon widget that shows the expand less or more icon based on the expanded flag
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                // Set the onPressed function that updates the state with the inverted expanded flag
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            // Set the second widget to an AnimatedContainer widget that animates the height change
            AnimatedContainer(
              // Set the duration of the animation to 300 milliseconds
              duration: Duration(milliseconds: 300),
              // Set the padding of the container
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              // Set the height of the container based on the expanded flag and the number of products
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 10, 100)
                  : 0,
              // Set the child widget to a ListView widget that displays the order products
              child: ListView(
                // Set the list of widgets for the list view by mapping the order products to row widgets
                children: widget.order.products
                    .map(
                      // Define the map function that returns a row widget for each product
                      (prod) => Row(
                        // Set the main axis alignment of the row to space between
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // Set the list of widgets for the row
                        children: <Widget>[
                          // Set the first widget to a Text widget that shows the product title with a bold style
                          Text(
                            prod.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Set the second widget to a Text widget that shows the product quantity and price with a grey color
                          Text(
                            '${prod.quantity}x \$${prod.price}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                    // Convert the map to a list
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
