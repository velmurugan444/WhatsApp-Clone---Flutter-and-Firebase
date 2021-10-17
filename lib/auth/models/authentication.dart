import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'http_exception.dart';

//changeNotifier-in case any change in the function it notifies to all its listeners.
class Authentication with ChangeNotifier {
  //future-When you call a function that returns a future, the function queues up work to be done and returns an uncompleted future.
  Future<void> signUp(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDSct7oMY9_wNhYe4jw3HqcSa8t7YgvbeY';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> logIn(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDSct7oMY9_wNhYe4jw3HqcSa8t7YgvbeY';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }
}
