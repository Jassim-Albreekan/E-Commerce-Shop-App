// Import the flutter material package to use widgets and themes
import 'package:flutter/material.dart';

// Define a class for the custom route that extends the MaterialPageRoute class
class CustomRoute<T> extends MaterialPageRoute<T> {
  // Use a constructor to initialize the builder and settings parameters
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  // Override the buildTransitions method to customize the page transitions
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Check if the route settings name is the root path
    if (settings.name == '/') {
      // Return the child widget without any transition
      return child;
    }
    // Return a fade transition with the animation and the child widget
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// Define a class for the custom page transitions builder that extends the PageTransitionsBuilder class
class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  // Override the buildTransitions method to customize the page transitions
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // Check if the route settings name is the root path
    if (route.settings.name == '/') {
      // Return the child widget without any transition
      return child;
    }
    // Return a fade transition with the animation and the child widget
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
