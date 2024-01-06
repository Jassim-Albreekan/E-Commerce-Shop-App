// Import the necessary packages and modules
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import the orders provider with an alias, the order item widget, and the app drawer widget
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

// Define the OrdersScreen class that extends StatefulWidget
class OrdersScreen extends StatefulWidget {
  // Define the constant field for the route name of the screen
  static const routeName = '/orders';

  // Override the createState method that returns a state object
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

// Define the _OrdersScreenState class that extends State<OrdersScreen>
class _OrdersScreenState extends State<OrdersScreen> {
  // Define a variable for the orders future
  Future _ordersFuture;

  // Define a private method that obtains the orders future from the orders provider
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

// Override the initState method that is called when the state object is created
  @override
  void initState() {
    // Assign the orders future to the private method that obtains it
    _ordersFuture = _obtainOrdersFuture();
    // Call the initState method of the super class
    super.initState();
  }

  // Define the private method that refreshes the orders data from the provider
  Future<void> _refreshOrders() async {
    // Await the fetch and set orders method of the orders provider
    await Provider.of<Orders>(
      context,
      listen: false,
    ).fetchAndSetOrders();
  }

  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Define a variable for the orders data model from the provider
    //final orderData = Provider.of<Orders>(context);
    // Return a Scaffold widget that creates the app bar and the body of the screen
    return Scaffold(
      // Set the app bar widget to an AppBar widget that shows the screen title
      appBar: AppBar(
        // Set the title widget to a Text widget with the value 'Your Orders'
        title: Text('Your Orders'),
      ),
      // Set the drawer widget to the AppDrawer widget that creates a side menu
      drawer: AppDrawer(),
      // Set the body widget to a FutureBuilder widget that builds the widget tree based on the future result
      body: FutureBuilder(
        // Set the future function to the orders future
        future: _ordersFuture,
        // Set the builder function that returns a widget based on the snapshot of the future
        builder: (context, dataSnapshot) {
          // If the snapshot connection state is waiting, return a Center widget that shows a circular progress indicator
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
            // If the snapshot error is not null, return a Center widget that shows a text widget with an error message
          } else if (dataSnapshot.error != null) {
            //do erro handeling
            return Center(
              child: Text('an error happened'),
            );
            // If the snapshot connection state is not waiting and the error is null, return a RefreshIndicator widget that allows refreshing the orders data
          } else {
            return RefreshIndicator(
              // Set the onRefresh function to the private method that refreshes the orders data
              onRefresh: () => _refreshOrders(),
              // Set the child widget to a Consumer widget that listens to the orders data model
              child: Consumer<Orders>(
                  builder: (context, orderData, child) => ListView.builder(
                        // Set the item count of the list view to the length of the orders list
                        itemCount: orderData.orders.length,
                        // Set the item builder function of the list view that returns a widget for each order
                        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                      )),
            );
          }
        },
      ),
    );
  }
}
