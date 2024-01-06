// Import the dart convert library to use json encoding and decoding
import 'dart:convert';
// Import the dart async library to use futures and timers
import 'dart:async';

// Import the flutter cupertino package to use widgets and themes
import 'package:flutter/cupertino.dart';
// Import the http package to make http requests
import 'package:http/http.dart' as http;
// Import the http exception class from the models folder
import 'package:shope/models/http_exception.dart';
// Import the shared preferences package to store and retrieve data
import 'package:shared_preferences/shared_preferences.dart';

// Define a class for the authentication with the ChangeNotifier mixin
class Auth with ChangeNotifier {
  // Declare string variables for the token, user id, and expiry date
  String _token;
  DateTime _expiryDate;
  String _userId;
  // Declare a timer variable for the authentication timer
  Timer _authTimer;

  // Define a getter method to check if the user is authenticated
  bool get isAuth {
    // Return true if the token is not null
    return token != null;
  }

  // Define a getter method to return the token
  String get token {
    // Check if the expiry date is not null and is after the current date and the token is not null
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      // Return the token
      return _token;
    }
    // Return null otherwise
    return null;
  }

  // Define a getter method to return the user id
  String get userId {
    return _userId;
  }

  // Define a private asynchronous method to authenticate the user with the email, password, and url segment
  Future<void> _authenticate(
      String email, String passWord, String urlSegment) async {
    // Declare a url variable for the identity toolkit endpoint with the url segment and the api key
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDSvuJ81OQKBRp5BVF1DcaO4yqVA9pe5uE');
    // Use a try-catch block to handle any errors that may occur
    try {
      // Await the http post request to the url with the email, password, and return secure token as the body and store the response
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': passWord,
            'returnSecureToken': true,
          }));
      // Decode the response body as a map of string and dynamic values
      final responseData = json.decode(response.body);
      // Check if the response data contains an error
      if (responseData['error'] != null) {
        // Throw an http exception with the error message
        throw HttpException(responseData['error']['message']);
      }
      // Assign the id token, local id, and expiry date from the response data to the token, user id, and expiry date variables
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      // Call the private method to log out the user after the expiry date
      _authLogout();
      // Notify the listeners that the authentication has changed
      notifyListeners();
      // Await the shared preferences instance and store it in a variable
      final prefs = await SharedPreferences.getInstance();
      // Encode the token, user id, and expiry date as a map of string and object values and store it in a variable
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      // Set the user data as a string value with the key 'userData' in the shared preferences
      prefs.setString('userData', userData);
    } catch (error) {
      // Throw the error to be handled by the caller
      throw error;
    }
    // Print the decoded response body to the console for debugging purposes
    // print(json.decode(response.body));
  }

  // Define a public asynchronous method to sign up the user with the email and password
  Future<void> signup(String email, String passWord) async {
    // Return the result of calling the private authenticate method with the email, password, and 'signUp' as the url segment
    return _authenticate(email, passWord, 'signUp');
  }

  // Define a public asynchronous method to log in the user with the email and password
  Future<void> login(String email, String passWord) async {
    // Return the result of calling the private authenticate method with the email, password, and 'signInWithPassword' as the url segment
    return _authenticate(email, passWord, 'signInWithPassword');
  }

  // Define a public asynchronous method to try auto login the user
  Future<bool> tryAutoLogin() async {
    // Await the shared preferences instance and store it in a variable
    final prefs = await SharedPreferences.getInstance();
    // Check if the shared preferences does not contain the key 'userData'
    if (!prefs.containsKey('userData')) {
      // Return false if not
      return false;
    }
    // Decode the string value with the key 'userData' as a map of string and object values and store it in a variable
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    // Parse the expiry date from the extracted user data and store it in a variable
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    // Check if the expiry date is before the current date
    if (expiryDate.isBefore(DateTime.now())) {
      // Return false if yes
      return false;
    }
    // Assign the token, user id, and expiry date from the extracted user data to the token, user id, and expiry date variables
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    // Notify the listeners that the authentication has changed
    notifyListeners();
    // Call the private method to log out the user after the expiry date
    _authLogout();
    // Return true if successful
    return true;
  }

  // Define a public asynchronous method to log out the user
  Future<void> logout() async {
    // Set the token, user id, and expiry date variables to null
    _token = null;
    _userId = null;
    _expiryDate = null;
    // Check if the authentication timer is not null
    if (_authTimer != null) {
      // Cancel the timer
      _authTimer.cancel();
      // Set the timer to null
      _authTimer = null;
    }
    // Notify the listeners that the authentication has changed
    notifyListeners();
    // Await the shared preferences instance and store it in a variable
    final prefs = await SharedPreferences.getInstance();
    // Remove the string value with the key 'userData' from the shared preferences
    // prefs.remove('userData');
    // Alternatively, clear all the data from the shared preferences
    prefs.clear();
  }

  // Define a private method to log out the user after the expiry date
  void _authLogout() {
    // Check if the authentication timer is not null
    if (_authTimer != null) {
      // Cancel the timer
      _authTimer.cancel();
    }
    // Calculate the time to expiry as the difference between the expiry date and the current date in seconds and store it in a variable
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    // Set the timer to a new timer with the duration of the time to expiry and the callback of the logout method
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
