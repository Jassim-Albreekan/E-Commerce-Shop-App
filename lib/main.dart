I can try to comment your flutter code pages, but I may not be able to explain everything in detail. Here is my attempt to comment the main.dart page:

// Import the necessary packages and modules
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shope/helpers/custom_route.dart';
import 'package:shope/providers/auth.dart';
import 'package:shope/screens/auth_screen.dart';
import 'package:shope/screens/splash_screen.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

// Define the main function that runs the app
void main() => runApp(MyApp());

// Define the MyApp class that extends StatelessWidget
class MyApp extends StatelessWidget {
  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Return a MultiProvider widget that provides multiple data models to the app
    return MultiProvider(
      // Define the list of providers that create and update the data models
      providers: [
        // Create a ChangeNotifierProvider that provides an Auth object
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // Create a ChangeNotifierProxyProvider that depends on the Auth object and provides a Products object
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, authObject, previousProducts) => Products(
              authObject.token,
              previousProducts == null ? [] : previousProducts.items,
              authObject.userId),
        ),
        // Create a ChangeNotifierProvider that provides a Cart object
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // Create a ChangeNotifierProxyProvider that depends on the Auth object and provides an Orders object
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, orders) => Orders(
              auth.token, auth.userId, orders == null ? [] : orders.orders),
        ),
      ],
      // Define the child widget that consumes the data models
      child: Consumer<Auth>(
        // Define the builder function that returns a MaterialApp widget
        builder: (context, authData, _) => MaterialApp(
            // Set the title of the app
            title: 'MyShop',
            // Set the theme of the app
            theme: ThemeData(
              // Set the primary color scheme
              primarySwatch: Colors.purple,
              // Set the accent color
              accentColor: Colors.deepOrange,
              // Set the default font family
              fontFamily: 'Lato',
              // Set the page transition theme
              pageTransitionsTheme: PageTransitionsTheme(
                // Set the custom page transition builders for different platforms
                builders: {
                  TargetPlatform.android: CustomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionsBuilder(),
                },
              ),
            ),
            // Set the home widget of the app based on the authentication status
            home: authData.isAuth
                // If the user is authenticated, show the products overview screen
                ? ProductsOverviewScreen()
                // If the user is not authenticated, show a future builder widget
                : FutureBuilder(
                    // Set the future function that tries to auto login the user
                    future: authData.tryAutoLogin(),
                    // Set the builder function that returns a widget based on the future result
                    builder: (context, authResultSnapshot) =>
                        // If the future is still waiting, show the splash screen
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            // If the future is done, show the auth screen
                            : AuthScreen(),
                  ),
            // Set the named routes of the app
            routes: {
              // Set the route for the product detail screen
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              // Set the route for the cart screen
              CartScreen.routeName: (ctx) => CartScreen(),
              // Set the route for the orders screen
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              // Set the route for the user products screen
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              // Set the route for the edit product screen
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              // Set the route for the auth screen
              AuthScreen.routeName: (ctx) => AuthScreen(),
            }),
      ),
    );
  }
}