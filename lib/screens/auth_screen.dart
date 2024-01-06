// Import the dart math library to use math functions
import 'dart:math';
// Import the flutter material package to use widgets and themes
import 'package:flutter/material.dart';
// Import the provider package to use state management
import 'package:provider/provider.dart';
// Import the auth and http_exception classes from the providers and models folders
import '../providers/auth.dart';
import '../models/http_exception.dart';

// Define an enum type for the authentication mode (signup or login)
enum AuthMode { Signup, Login }

// Define a stateless widget class for the authentication screen
class AuthScreen extends StatelessWidget {
  // Define a constant string for the route name of this screen
  static const routeName = '/auth';

  // Override the build method to return the widget tree for the authentication screen
  @override
  Widget build(BuildContext context) {
    // Get the device size from the media query
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    // Return a scaffold widget with a body
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        // Use a stack widget to layer the widgets on top of each other
        children: <Widget>[
          // Add a container widget to fill the background with a gradient color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Use two colors with different opacities for the gradient
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                // Use the top left and bottom right corners as the start and end points of the gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                // Use two stops to define the fractions of the gradient
                stops: [0, 1],
              ),
            ),
          ),
          // Add a single child scroll view widget to enable scrolling the content
          SingleChildScrollView(
            child: Container(
              // Use the device height and width for the container dimensions
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                // Use a column widget to arrange the widgets vertically
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Add a flexible widget to adjust the size of the child widget according to the available space
                  Flexible(
                    child: Container(
                      // Add some margin and padding to the container
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      // Apply a transformation to the container to rotate and translate it
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      // Add some decoration to the container such as border radius, color, and box shadow
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      // Add a text widget to show the app name
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          // Use the accent text theme color of the context for the text color
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  // Add another flexible widget to adjust the size of the child widget according to the available space
                  Flexible(
                    // Use a different flex factor depending on the device width
                    flex: deviceSize.width > 600 ? 2 : 1,
                    // Add an auth card widget to display the authentication form
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Define a stateful widget class for the authentication card
class AuthCard extends StatefulWidget {
  // Use a constructor to initialize the key parameter as an optional named parameter
  const AuthCard({
    Key key,
  }) : super(key: key);

  // Override the createState method to return an instance of _AuthCardState
  @override
  _AuthCardState createState() => _AuthCardState();
}

// Define a private state class for the authentication card widget
class _AuthCardState extends State<AuthCard>
    // Use a mixin to add the SingleTickerProviderStateMixin to the state class
    with
        SingleTickerProviderStateMixin {
  // Declare a global key for the form state
  final GlobalKey<FormState> _formKey = GlobalKey();
  // Declare an enum variable for the authentication mode (signup or login)
  AuthMode _authMode = AuthMode.Login;
  // Declare a map variable for the authentication data (email and password)
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  // Declare a boolean variable to check if the card is loading
  var _isLoading = false;
  // Declare a text editing controller for the password field
  final _passwordController = TextEditingController();
  // Declare an animation controller for the card animation
  AnimationController _controller;
  // Declare an animation for the slide transition of the card
  Animation<Offset> _slideAnimation;
  // Declare an animation for the opacity of the card
  Animation<double> _opacityAnimation;

  // Override the initState method to initialize the animation controller and the animations
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Initialize the animation controller with the vsync parameter and the duration
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    // Initialize the slide animation with a tween and a curved animation
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    // Initialize the opacity animation with a tween and a curved animation
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    // _heightAnimation.addListener(() {
    //   setState(() {
    //
    //   });
    // });
  }

  // Override the dispose method to dispose the animation controller
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  // Define a method to show an error dialog with a message
  void _showErrorDialog(String message) {
    // Use the showDialog function to display a dialog widget
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        // Use an alert dialog widget with a title, a content, and an action
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          // Add a flat button widget to close the dialog
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  // Define an asynchronous method to submit the authentication form
  Future<void> _submit() async {
    // Check if the form is valid by calling the validate method on the form state
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    // Save the form data by calling the save method on the form state
    _formKey.currentState.save();
    // Set the _isLoading variable to true and update the state
    setState(() {
      _isLoading = true;
    });
    // Use a try-catch block to handle any errors that may occur
    try {
      // Check the authentication mode and call the appropriate method from the auth provider
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
      // Navigator.of(context).pushReplacementNamed('/products-overview');
    } on HttpException catch (error) {
      // Declare a variable to store the error message
      var errorMessage = 'Authentication failed';
      // Check the error message and assign a more specific message if possible
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      // Call the _showErrorDialog method with the error message as an argument
      _showErrorDialog(errorMessage);
    } catch (error) {
      // Declare a constant for the default error message
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      // Call the _showErrorDialog method with the default error message as an argument
      _showErrorDialog(errorMessage);
      // Print the error to the console for debugging purposes
      // print(error);
    }

    // Set the _isLoading variable to false and update the state
    setState(() {
      _isLoading = false;
    });
  }

  // Define a method to switch the authentication mode between signup and login
  void _switchAuthMode() {
    // Check the current authentication mode and update the state accordingly
    if (_authMode == AuthMode.Login) {
      // Set the authentication mode to signup
      setState(() {
        _authMode = AuthMode.Signup;
      });
      // Play the animation controller forward
      _controller.forward();
    } else {
      // Set the authentication mode to login
      setState(() {
        _authMode = AuthMode.Login;
      });
      // Play the animation controller backward
      _controller.reverse();
    }
  }

// Override the build method to return the widget tree for the authentication card
  @override
  Widget build(BuildContext context) {
    // Get the device size from the media query
    final deviceSize = MediaQuery.of(context).size;
    // Return a card widget with a rounded shape and an elevation
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      // Use an animated container widget to animate the height of the card
      child: AnimatedContainer(
        // height: _authMode == AuthMode.Signup ? 320 : 260,
        // _heightAnimation.value.height
        // Set the duration and the curve of the animation
        duration: Duration(milliseconds: 400),
        curve: Curves.easeIn,
        // Set the height of the container depending on the authentication mode
        height: _authMode == AuthMode.Signup ? 320 : 260,
        // Set the minimum and maximum height constraints of the container
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        // Set the width of the container as a fraction of the device width
        width: deviceSize.width * 0.75,
        // Add some padding to the container
        padding: EdgeInsets.all(16.0),
        // Add a form widget to display the input fields
        child: Form(
          // Assign the global key to the form
          key: _formKey,
          // Use a single child scroll view widget to enable scrolling the form
          child: SingleChildScrollView(
            // Use a column widget to arrange the input fields vertically
            child: Column(
              children: <Widget>[
                // Add a text form field widget for the email input
                TextFormField(
                  // Add a decoration to the field with a label text
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  // Set the keyboard type to email address
                  keyboardType: TextInputType.emailAddress,
                  // Set the validator function to check the email input
                  validator: (value) {
                    // Return an error message if the value is empty or does not contain '@'
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  // Set the onSaved function to save the email input to the auth data map
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                // Add a text form field widget for the password input
                TextFormField(
                  // Add a decoration to the field with a label text
                  decoration: InputDecoration(labelText: 'Password'),
                  // Set the obscure text property to true to hide the password input
                  obscureText: true,
                  // Assign the password controller to the field
                  controller: _passwordController,
                  // Set the validator function to check the password input
                  validator: (value) {
                    // Return an error message if the value is empty or less than 5 characters long
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  // Set the onSaved function to save the password input to the auth data map
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                // Add an animated container widget to animate the confirm password field
                AnimatedContainer(
                  // Set the duration and the curve of the animation
                  duration: Duration(milliseconds: 300),
                  // Set the minimum and maximum height constraints of the container depending on the authentication mode
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  // Set the curve to fast out slow in
                  curve: Curves.fastOutSlowIn,
                  // Add a fade transition widget to fade in or out the confirm password field
                  child: FadeTransition(
                    // Use the opacity animation for the transition
                    opacity: _opacityAnimation,
                    // Add a slide transition widget to slide up or down the confirm password field
                    child: SlideTransition(
                      // Use the slide animation for the transition
                      position: _slideAnimation,
                      // Add a text form field widget for the confirm password input
                      child: TextFormField(
                        // Enable the field only if the authentication mode is signup
                        enabled: _authMode == AuthMode.Signup,
                        // Add a decoration to the field with a label text
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        // Set the obscure text property to true to hide the confirm password input
                        obscureText: true,
                        // Set the validator function to check the confirm password input
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                // Return an error message if the value does not match the password input
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
// Add a sized box widget to create some vertical space
                SizedBox(
                  height: 20,
                ),
// Use a conditional expression to display either a circular progress indicator or a raised button depending on the _isLoading variable
                if (_isLoading)
                  // Display a circular progress indicator to indicate loading
                  CircularProgressIndicator()
                else
                  // Display a raised button to submit the form
                  RaisedButton(
                    // Set the child of the button to a text widget with the appropriate text depending on the authentication mode
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    // Set the onPressed function of the button to the _submit method
                    onPressed: _submit,
                    // Set the shape of the button to a rounded rectangle with a border radius
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    // Set the padding of the button to some symmetric values
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    // Set the color of the button to the primary color of the theme
                    color: Theme.of(context).primaryColor,
                    // Set the text color of the button to the button color of the primary text theme
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
// Add a flat button widget to switch the authentication mode
                FlatButton(
                  // Set the child of the button to a text widget with the appropriate text depending on the authentication mode
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  // Set the onPressed function of the button to the _switchAuthMode method
                  onPressed: _switchAuthMode,
                  // Set the padding of the button to some symmetric values
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  // Set the material tap target size of the button to shrink wrap
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // Set the text color of the button to the primary color of the theme
                  textColor: Theme.of(context).primaryColor,
                ),
// Close the column widget
              ],
// Close the single child scroll view widget
            ),
// Close the form widget
          ),
// Close the animated container widget
        ),
      ),
// Close the card widget
    );
// Close the build method
  }
// Close the state class
}
