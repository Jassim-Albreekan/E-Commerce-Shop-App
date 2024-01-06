// Import the flutter material package to use widgets and themes
import 'package:flutter/material.dart';
// Import the provider package to use state management
import 'package:provider/provider.dart';

// Import the product and products classes from the providers folder
import '../providers/product.dart';
import '../providers/products.dart';

// Define a stateful widget class for the edit product screen
class EditProductScreen extends StatefulWidget {
  // Define a constant string for the route name of this screen
  static const routeName = '/edit-product';

  // Override the createState method to return an instance of _EditProductScreenState
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

// Define a private state class for the edit product screen widget
class _EditProductScreenState extends State<EditProductScreen> {
  // Declare some final variables for focus nodes, text editing controller, form key, and product object
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  // Declare a map variable for the initial values of the form fields
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  // Declare a boolean variable to check if the screen is initialized
  var _isInit = true;
  // Declare a boolean variable to check if the screen is loading
  var _isLoading = false;

  // Override the initState method to add a listener to the image url focus node
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  // Override the didChangeDependencies method to get the product id from the route arguments and fetch the product details from the provider
  @override
  void didChangeDependencies() {
    // Check if the screen is initialized
    if (_isInit) {
      // Get the product id from the route arguments as a string
      final productId = ModalRoute.of(context).settings.arguments as String;
      // Check if the product id is not null
      if (productId != null) {
        // Get the product object from the provider by using the product id
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        // Update the initial values map with the product details
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        // Update the image url controller text with the product image url
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    // Set the _isInit variable to false
    _isInit = false;
    super.didChangeDependencies();
  }

  // Override the dispose method to remove the listener from the image url focus node and dispose the focus nodes and the text editing controller
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  // Define a private method to update the image url state when the focus changes
  void _updateImageUrl() {
    // Check if the image url focus node has lost focus
    if (!_imageUrlFocusNode.hasFocus) {
      // Check if the image url controller text is not a valid image url
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        // Return from the method without updating the state
        return;
      }
      // Call the setState method to update the image preview
      setState(() {});
    }
  }

  // Define an async method to save the form data
  Future<void> _saveForm() async {
    // Validate the form fields and store the result in a boolean variable
    final isValid = _form.currentState.validate();
    // Check if the form is not valid
    if (!isValid) {
      // Return from the method without saving the form
      return;
    }
    // Save the form data to the _editedProduct object
    _form.currentState.save();
    // Call the setState method to show a loading indicator
    setState(() {
      _isLoading = true;
    });
    // Check if the edited product has an id
    if (_editedProduct.id != null) {
      // Update the existing product in the provider by using the id and the edited product object
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      // Try to add a new product to the provider by using the edited product object
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        // If an error occurs, show a dialog with an error message
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
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
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    // Call the setState method to hide the loading indicator
    setState(() {
      _isLoading = false;
    });
    // Pop the current screen from the navigation stack
    Navigator.of(context).pop();
    // Navigator of(context).pop();
  }

  // Override the build method to return the widget tree for the edit product screen
  @override
  Widget build(BuildContext context) {
    // Return a scaffold widget with an app bar and a body
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          // Add an icon button to save the form data
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  // Use a list view widget to display the form fields as text editing controllers
                  children: <Widget>[
                    // Add a text editing controller for the title field
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        // Call the requestFocus method on the price focus node when the title field is submitted
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        // Check if the value is empty and return an error message if so
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        // Return null otherwise
                        return null;
                      },
                      onSaved: (value) {
                        // Update the _editedProduct object with the new title value and save it to the provider
                        _editedProduct = Product(
                            title: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    // Add a text editing controller for the price field
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        // Call the requestFocus method on the description focus node when the price field is submitted
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        // Check if the value is empty and return an error message if so
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        // Check if the value is not a valid number and return an error message if so
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        // Check if the value is less than or equal to zero and return an error message if so
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        // Return null otherwise
                        return null;
                      },
                      onSaved: (value) {
                        // Update the _editedProduct object with the new price value and save it to the provider
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(value),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    // Add a text editing controller for the description field
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines:
                          3, // Allow the user to enter up to three lines of text
                      keyboardType: TextInputType
                          .multiline, // Use a multiline keyboard type for better input
                      focusNode:
                          _descriptionFocusNode, // Assign the description focus node to this field
                      validator: (value) {
                        // Check if the value is empty and return an error message if so
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        // Check if the value is less than 10 characters long and return an error message if so
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        // Return null otherwise
                        return null;
                      },
                      onSaved: (value) {
                        // Update the _editedProduct object with the new price value and save it to the provider
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    // Add a row widget to display the image url field and the image preview
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        // Add a container widget to show the image preview
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        // Add an expanded widget to fill the remaining space with the image url field
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              // Check if the value is empty and return an error message if so
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              // Check if the value is not a valid url and return an error message if so
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              // Check if the value is not a valid image url and return an error message if so
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              // Return null otherwise
                              return null;
                            },
                            onSaved: (value) {
                              // Update the _editedProduct object with the new image url value and save it to the provider
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
