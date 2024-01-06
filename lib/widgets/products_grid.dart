// Import the necessary packages and modules
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import the products provider and the product item widget
import '../providers/products.dart';
import './product_item.dart';

// Define the ProductsGrid class that extends StatelessWidget
class ProductsGrid extends StatelessWidget {
  // Define the final field for the showFavs flag
  final bool showFavs;

  // Define the constructor that assigns the field from the argument
  ProductsGrid(this.showFavs);

  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Define a variable for the products data model from the provider
    final productsData = Provider.of<Products>(context);
    // Define a variable for the list of products based on the showFavs flag
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    // Return a GridView widget that displays the products in a grid layout
    return GridView.builder(
      // Set the padding of the grid view
      padding: const EdgeInsets.all(10.0),
      // Set the item count of the grid view to the length of the products list
      itemCount: products.length,
      // Set the item builder function of the grid view that returns a widget for each product
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // Create a ChangeNotifierProvider that provides the product object as a value
        // builder: (c) => products[i],
        value: products[i],
        // Set the child widget to a ProductItem widget that displays the product information
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      // Set the grid delegate of the grid view to a SliverGridDelegateWithFixedCrossAxisCount
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // Set the cross axis count of the grid view to 2
        crossAxisCount: 2,
        // Set the child aspect ratio of the grid view to 3 / 2
        childAspectRatio: 3 / 2,
        // Set the cross axis spacing of the grid view to 10
        crossAxisSpacing: 10,
        // Set the main axis spacing of the grid view to 10
        mainAxisSpacing: 10,
      ),
    );
  }
}
