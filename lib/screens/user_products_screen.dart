// Import the necessary packages and modules
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import the products provider, the user product item widget, the app drawer widget, and the edit product screen
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

// Define the UserProductsScreen class that extends StatelessWidget
class UserProductsScreen extends StatelessWidget {
  // Define the constant field for the route name of the screen
  static const routeName = '/user-products';

  // Define the private method that refreshes the products data from the provider
  Future<void> _refreshProducts(BuildContext context) async {
    // Await the fetch and set products method of the products provider with the filter by user flag set to true
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Define a variable for the products data model from the provider
    // final productsData = Provider.of<Products>(context);
    // Print a message to the console for debugging purposes
    print('rebuilding...');
    // Return a Scaffold widget that creates the app bar and the body of the screen
    return Scaffold(
      // Set the app bar widget to an AppBar widget that shows the screen title and an action icon
      appBar: AppBar(
        // Set the title widget to a Text widget with the constant value 'Your Products'
        title: const Text('Your Products'),
        // Set the actions widget to a list of IconButton widgets that allow adding a new product
        actions: <Widget>[
          // Define the IconButton widget that navigates to the edit product screen when pressed
          IconButton(
            // Set the icon widget to an Icon widget with the constant value add icon
            icon: const Icon(Icons.add),
            // Set the onPressed function that pushes the edit product screen to the navigation stack
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      // Set the drawer widget to the AppDrawer widget that creates a side menu
      drawer: AppDrawer(),
      // Set the body widget to a FutureBuilder widget that builds the widget tree based on the future result
      body: FutureBuilder(
        // Set the future function to the private method that refreshes the products data
        future: _refreshProducts(context),
        // Set the builder function that returns a widget based on the snapshot of the future
        builder: (ctx, snapshot) =>
            // If the snapshot connection state is waiting, return a Center widget that shows a circular progress indicator
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                // If the snapshot connection state is not waiting, return a RefreshIndicator widget that allows refreshing the products data
                : RefreshIndicator(
                    // Set the onRefresh function to the private method that refreshes the products data
                    onRefresh: () => _refreshProducts(context),
                    // Set the child widget to a Consumer widget that listens to the products data model
                    child: Consumer<Products>(
                      // Set the builder function that returns a Padding widget that adds some padding around
                      builder: (ctx, productsData, _) => Padding(
                        // Set the padding value to 8 pixels on all sides
                        padding: EdgeInsets.all(8),
                        // Set the child widget to a ListView widget that displays the user products in a list
                        child: ListView.builder(
                          // Set the item count of the list view to the length of the products list
                          itemCount: productsData.items.length,
                          // Set the item builder function of the list view that returns a widget for each product
                          itemBuilder: (_, i) => Column(
                            // Set the list of widgets for the column
                            children: [
                              // Set the first widget to a UserProductItem widget that displays the product information and actions
                              UserProductItem(
                                productsData.items[i].id,
                                productsData.items[i].title,
                                productsData.items[i].imageUrl,
                              ),
                              // Set the second widget to a Divider widget that creates a horizontal line
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
