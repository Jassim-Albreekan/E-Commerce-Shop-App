// Import the necessary packages and modules
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import the app drawer widget, the products grid widget, the badge widget, the cart provider, the cart screen, and the products provider
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import 'package:shope/providers/products.dart';

// Define the FilterOptions enum that has two values: Favorites and All
enum FilterOptions {
  Favorites,
  All,
}

// Define the ProductsOverviewScreen class that extends StatefulWidget
class ProductsOverviewScreen extends StatefulWidget {
  // Override the createState method that returns a state object
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

// Define the _ProductsOverviewScreenState class that extends State<ProductsOverviewScreen>
class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // Define a variable for the show only favorites flag
  var _showOnlyFavorites = false;
  // Define a variable for the init flag
  var _isInit = true;
  // Define a variable for the loading flag
  var _isLoading = false;

  // Override the initState method that is called when the state object is created
  @override
  void initState() {
    // TODO: implement initState
    // Call the initState method of the super class
    super.initState();
    // Uncomment the following lines to fetch and set the products data after the widget is built
    // Future.delayed(Duration.zero).then((_){
    // Provider.of<Products>(context).fetchAndSetProducts();
    // });
  }

  // Override the didChangeDependencies method that is called when the dependencies of the state object change
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // Call the didChangeDependencies method of the super class
    super.didChangeDependencies();
    // If the init flag is true, update the state with the loading flag set to true and fetch and set the products data
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        // After the products data is fetched and set, update the state with the loading flag set to false
        setState(() {
          _isLoading = false;
        });
      });
    }
    // Set the init flag to false
    _isInit = false;
  }

  // Define the private method that refreshes the products data from the provider
  Future<void> _refreshProducts() async {
    // Await the fetch and set products method of the products provider
    await Provider.of<Products>(
      context,
      listen: false,
    ).fetchAndSetProducts();
  }

  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Return a Scaffold widget that creates the app bar and the body of the screen
    return Scaffold(
      // Set the app bar widget to an AppBar widget that shows the screen title and some action icons
      appBar: AppBar(
        // Set the title widget to a Text widget with the value 'MyShop'
        title: Text('MyShop'),
        // Set the actions widget to a list of PopupMenuButton and Consumer widgets that allow filtering and viewing the cart
        actions: <Widget>[
          // Define the PopupMenuButton widget that shows a popup menu with filter options
          PopupMenuButton(
            // Set the onSelected function that updates the state with the show only favorites flag based on the selected value
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            // Set the icon widget to an Icon widget with the more vert icon
            icon: Icon(
              Icons.more_vert,
            ),
            // Set the itemBuilder function that returns a list of PopupMenuItem widgets with the filter options
            itemBuilder: (_) => [
              // Define the first PopupMenuItem widget with the value and child set to Favorites
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              // Define the second PopupMenuItem widget with the value and child set to Show All
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          // Define the Consumer widget that listens to the cart data model and shows a badge with the cart item count
          Consumer<Cart>(
            // Set the builder function that returns a Badge widget
            builder: (_, cart, ch) => Badge(
              // Set the child widget to the ch argument
              child: ch,
              // Set the value widget to the cart item count as a string
              value: cart.itemCount.toString(),
            ),
            // Set the child widget to an IconButton widget that allows navigating to the cart screen
            child: IconButton(
              // Set the icon widget to an Icon widget with the shopping cart icon
              icon: Icon(
                Icons.shopping_cart,
              ),
              // Set the onPressed function that pushes the cart screen to the navigation stack
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      // Set the drawer widget to the AppDrawer widget that creates a side menu
      drawer: AppDrawer(),
      // Set the body widget to a conditional expression that shows a circular progress indicator if the loading flag is true, otherwise shows a refresh indicator with the products grid
      body: _isLoading
          ?
          // If the loading flag is true, return a Center widget that shows a CircularProgressIndicator widget
          Center(
              child: CircularProgressIndicator(),
            )
          // If the loading flag is false, return a RefreshIndicator widget that allows refreshing the products data
          : RefreshIndicator(
              // Set the onRefresh function to the private method that refreshes the products data
              onRefresh: () => _refreshProducts(),
              // Set the child widget to the ProductsGrid widget that displays the products in a grid layout based on the show only favorites flag
              child: ProductsGrid(_showOnlyFavorites)),
    );
  }
}
