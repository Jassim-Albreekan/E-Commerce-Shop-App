// Import the necessary packages and modules
import 'package:flutter/material.dart';
import 'package:shope/helpers/custom_route.dart';
import 'package:shope/providers/auth.dart';
import 'package:provider/provider.dart';

// Import the orders screen and the user products screen
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

// Define the AppDrawer class that extends StatelessWidget
class AppDrawer extends StatelessWidget {
  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Return a Drawer widget that creates a side menu
    return Drawer(
      // Set the child widget to a Column widget that arranges the menu items vertically
      child: Column(
        // Set the list of widgets for the column
        children: <Widget>[
          // Set the first widget to an AppBar widget that shows a greeting message
          AppBar(
            // Set the title widget to a Text widget with the message
            title: Text('Hello Friend!'),
            // Set the automaticallyImplyLeading flag to false to hide the leading icon
            automaticallyImplyLeading: false,
          ),
          // Set the second widget to a Divider widget that creates a horizontal line
          Divider(),
          // Set the third widget to a ListTile widget that allows navigating to the shop screen
          ListTile(
            // Set the leading widget to an Icon widget with the shop icon
            leading: Icon(Icons.shop),
            // Set the title widget to a Text widget with the label 'Shop'
            title: Text('Shop'),
            // Set the onTap function that replaces the current screen with the shop screen
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          // Set the fourth widget to a Divider widget that creates a horizontal line
          Divider(),
          // Set the fifth widget to a ListTile widget that allows navigating to the orders screen
          ListTile(
            // Set the leading widget to an Icon widget with the payment icon
            leading: Icon(Icons.payment),
            // Set the title widget to a Text widget with the label 'Orders'
            title: Text('Orders'),
            // Set the onTap function that replaces the current screen with the orders screen using a custom route
            onTap: () {
              // Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
              Navigator.of(context).pushReplacement(CustomRoute(
                // Set the builder function of the custom route that returns the orders screen
                builder: (context) => OrdersScreen(),
              ));
            },
          ),
          // Set the sixth widget to a Divider widget that creates a horizontal line
          Divider(),
          // Set the seventh widget to a ListTile widget that allows navigating to the user products screen
          ListTile(
            // Set the leading widget to an Icon widget with the edit icon
            leading: Icon(Icons.edit),
            // Set the title widget to a Text widget with the label 'Manage Products'
            title: Text('Manage Products'),
            // Set the onTap function that replaces the current screen with the user products screen
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          // Set the eighth widget to a Divider widget that creates a horizontal line
          Divider(),
          // Set the ninth widget to a ListTile widget that allows logging out
          ListTile(
            // Set the leading widget to an Icon widget with the exit to app icon
            leading: Icon(Icons.exit_to_app),
            // Set the title widget to a Text widget with the label 'Logout'
            title: Text('Logout'),
            // Set the onTap function that pops the drawer, replaces the current screen with the shop screen, and logs out using the auth provider
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
