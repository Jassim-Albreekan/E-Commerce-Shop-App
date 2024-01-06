// Import the necessary package
import 'package:flutter/material.dart';

// Define the Badge class that extends StatelessWidget
class Badge extends StatelessWidget {
  // Define the constructor that takes the child, value, and color as required or optional arguments
  const Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  // Define the final fields for the child widget, the value string, and the color
  final Widget child;
  final String value;
  final Color color;

  // Override the build method that returns a widget tree
  @override
  Widget build(BuildContext context) {
    // Return a Stack widget that stacks the child widget and the badge widget
    return Stack(
      // Set the alignment of the stack to center
      alignment: Alignment.center,
      // Set the list of widgets for the stack
      children: [
        // Set the first widget to the child widget that is passed as an argument
        child,
        // Set the second widget to a Positioned widget that places the badge widget on the top right corner
        Positioned(
          // Set the right and top position of the badge widget
          right: 8,
          top: 8,
          // Set the child widget to a Container widget that displays the badge widget
          child: Container(
            // Set the padding of the container
            padding: EdgeInsets.all(2.0),
            // Set the decoration of the container to a BoxDecoration widget that creates a rounded border and a fill color
            decoration: BoxDecoration(
              // Set the border radius of the decoration to a circular shape
              borderRadius: BorderRadius.circular(10.0),
              // Set the color of the decoration to the color argument if it is not null, otherwise use the accent color of the theme
              color: color != null ? color : Theme.of(context).accentColor,
            ),
            // Set the constraints of the container to a BoxConstraints widget that sets the minimum width and height
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            // Set the child widget to a Text widget that displays the value string
            child: Text(
              value,
              // Set the text alignment to center
              textAlign: TextAlign.center,
              // Set the text style to a TextStyle widget that sets the font size
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
