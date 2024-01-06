// Import the necessary packages and modules
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shope/providers/auth.dart';

// Import the product detail screen, the product provider, and the cart provider
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

// Define the ProductItem class that extends StatelessWidget
class ProductItem extends StatelessWidget {
  // Define the final fields for the product id, title, and image url
  // final String id;
  // final String title;
  // final String imageUrl;

  // Define the constructor that assigns the fields from the arguments
  // ProductItem(this.id, this.title, this.imageUrl);

  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Define a variable for the product data model from the provider
    final product = Provider.of<Product>(context, listen: false);
    // Define a variable for the cart data model from the provider
    final cart = Provider.of<Cart>(context, listen: false);
    // Define a variable for the auth data model from the provider
    final authData = Provider.of<Auth>(context, listen: false);
    // Return a ClipRRect widget that clips the child widget with a rounded border
    return ClipRRect(
      // Set the border radius of the clip
      borderRadius: BorderRadius.circular(10),
      // Set the child widget to a GridTile widget that displays the product information and actions
      child: GridTile(
        // Set the child widget to a GestureDetector widget that handles the tap gesture
        child: GestureDetector(
          // Set the onTap function that navigates to the product detail screen with the product id as an argument
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          // Set the child widget to a Hero widget that creates a hero animation with the product image
          child: Hero(
            // Set the tag of the hero widget to the product id
            tag: product.id,
            // Set the child widget to a FadeInImage widget that displays the product image with a fade-in effect
            child: FadeInImage(
              // Set the placeholder image to a local asset image
              placeholder: AssetImage('assests/images/product-placeholder.png'),
              // Set the image to a network image with the product image url
              image: NetworkImage(product.imageUrl),
              // Set the fit mode of the image to cover
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Set the footer widget to a GridTileBar widget that displays the product title and icons
        footer: GridTileBar(
          // Set the background color of the grid tile bar to black with some opacity
          backgroundColor: Colors.black87,
          // Set the leading widget to a Consumer widget that listens to the product data model
          leading: Consumer<Product>(
            // Set the builder function that returns an IconButton widget
            builder: (ctx, product, _) => IconButton(
              // Set the icon widget to an Icon widget that shows the favorite status of the product
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              // Set the color of the icon to the accent color of the theme
              color: Theme.of(context).accentColor,
              // Set the onPressed function that toggles the favorite status of the product using the auth data model
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
              },
            ),
          ),
          // Set the title widget to a Text widget that shows the product title
          title: Text(
            product.title,
            // Set the text alignment to center
            textAlign: TextAlign.center,
          ),
          // Set the trailing widget to an IconButton widget that allows adding the product to the cart
          trailing: IconButton(
            // Set the icon widget to an Icon widget with the shopping cart icon
            icon: Icon(
              Icons.shopping_cart,
            ),
            // Set the onPressed function that adds the product to the cart and shows a snackbar with a message
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              // Hide the current snackbar if any
              Scaffold.of(context).hideCurrentSnackBar();
              // Show a new snackbar with the message
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  // Set the content widget to a Text widget with the message
                  content: Text(
                    'Added item to cart!',
                  ),
                  // Set the duration of the snackbar to 2 seconds
                  duration: Duration(seconds: 2),
                  // Set the action widget to a SnackBarAction widget that allows undoing the action
                  action: SnackBarAction(
                    // Set the label of the action to 'UNDO'
                    label: 'UNDO',
                    // Set the onPressed function that removes the single item from the cart
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            // Set the color of the icon to the accent color of the theme
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
