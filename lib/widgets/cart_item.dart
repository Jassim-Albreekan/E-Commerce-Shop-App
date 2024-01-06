// Import the necessary packages and modules
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import the cart provider
import '../providers/cart.dart';

// Define the CartItem class that extends StatelessWidget
class CartItem extends StatelessWidget {
  // Define the final fields for the cart item id, product id, price, quantity, and title
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  // Define the constructor that assigns the fields from the arguments
  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Return a Dismissible widget that allows swiping the cart item to remove it
    return Dismissible(
      // Set the key of the dismissible widget to the cart item id
      key: ValueKey(id),
      // Set the background widget to a Container widget that shows a delete icon with a red color
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        // Set the alignment of the container to center right
        alignment: Alignment.centerRight,
        // Set the padding of the container to have some space on the right
        padding: EdgeInsets.only(right: 20),
        // Set the margin of the container to have some space around
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      // Set the direction of the dismissible widget to end to start
      direction: DismissDirection.endToStart,
      // Set the confirmDismiss function that shows a dialog to confirm the removal
      confirmDismiss: (direction) {
        // Return a showDialog widget that returns a future value of true or false
        return showDialog(
          // Set the context of the dialog
          context: context,
          // Set the builder function of the dialog that returns an AlertDialog widget
          builder: (ctx) => AlertDialog(
            // Set the title widget of the alert dialog to a Text widget that shows a question
            title: Text('Are you sure?'),
            // Set the content widget of the alert dialog to a Text widget that shows a message
            content: Text(
              'Do you want to remove the item from the cart?',
            ),
            // Set the actions widget of the alert dialog to a list of FlatButton widgets that allow the user to choose yes or no
            actions: <Widget>[
              // Define the first FlatButton widget that returns false when pressed
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              // Define the second FlatButton widget that returns true when pressed
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      // Set the onDismissed function that removes the cart item using the cart provider
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      // Set the child widget to a Card widget that displays the cart item information
      child: Card(
        // Set the margin of the card to have some space around
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        // Set the child widget to a Padding widget that adds some padding around
        child: Padding(
          padding: EdgeInsets.all(8),
          // Set the child widget to a ListTile widget that shows the cart item details
          child: ListTile(
            // Set the leading widget to a CircleAvatar widget that shows the cart item price
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            // Set the title widget to a Text widget that shows the cart item title
            title: Text(title),
            // Set the subtitle widget to a Text widget that shows the cart item total
            subtitle: Text('Total: \$${(price * quantity)}'),
            // Set the trailing widget to a Text widget that shows the cart item quantity
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
