// Import the necessary package
import 'package:flutter/material.dart';
// Import the products provider
import '../providers/products.dart';

// Define the ProductDetailScreen class that extends StatelessWidget
class ProductDetailScreen extends StatelessWidget {
  // Define the constant field for the route name of the screen
  static const routeName = '/product-detail';

  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Define a variable for the product id from the route arguments
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    // Define a variable for the loaded product from the products provider
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    // Return a Scaffold widget that creates the body of the screen
    return Scaffold(
      // Set the body widget to a CustomScrollView widget that displays the product details in a scrollable view
      body: CustomScrollView(
        // Set the list of slivers for the custom scroll view
        slivers: [
          // Set the first sliver to a SliverAppBar widget that shows the product title and image in a collapsible app bar
          SliverAppBar(
            // Set the expanded height of the app bar to 300 pixels
            expandedHeight: 300,
            // Set the pinned flag to true to keep the app bar visible when scrolled
            pinned: true,
            // Set the flexible space widget to a FlexibleSpaceBar widget that shows the product title and image
            flexibleSpace: FlexibleSpaceBar(
              // Set the title widget to a Text widget with the loaded product title
              title: Text(loadedProduct.title),
              // Set the background widget to a Hero widget that creates a hero animation with the product image
              background: Hero(
                // Set the tag of the hero widget to the loaded product id
                tag: loadedProduct.id,
                // Set the child widget to an Image widget that shows the product image from the network
                child: Image.network(
                  // Set the image source to the loaded product image url
                  loadedProduct.imageUrl,
                  // Set the fit mode of the image to cover
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Set the second sliver to a SliverList widget that shows the product price and description in a list
          SliverList(
            // Set the delegate of the sliver list to a SliverChildListDelegate widget that creates the list items
            delegate: SliverChildListDelegate(
                // Set the list of widgets for the sliver child list delegate
                [
                  // Set the first widget to a SizedBox widget that creates some vertical space
                  SizedBox(height: 10),
                  // Set the second widget to a Text widget that shows the product price with a grey color and a large font size
                  Text(
                    // Set the text value to the product price with a dollar sign
                    '\$${loadedProduct.price}',
                    // Set the text alignment to center
                    textAlign: TextAlign.center,
                    // Set the text style to a TextStyle widget that sets the color and font size
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  // Set the third widget to a SizedBox widget that creates some vertical space
                  SizedBox(
                    height: 10,
                  ),
                  // Set the fourth widget to a Container widget that shows the product description with some padding and width
                  Container(
                    // Set the padding of the container to have some horizontal space
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    // Set the width of the container to fill the available space
                    width: double.infinity,
                    // Set the child widget to a Text widget that shows the product description with a soft wrap and a center alignment
                    child: Text(
                      // Set the text value to the product description
                      loadedProduct.description,
                      // Set the text alignment to center
                      textAlign: TextAlign.center,
                      // Set the soft wrap flag to true to wrap the text to a new line if it overflows
                      softWrap: true,
                    ),
                  ),
                  // Set the fifth widget to a SizedBox widget that creates a large vertical space
                  SizedBox(
                    height: 800,
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
