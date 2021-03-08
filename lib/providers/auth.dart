import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime expiryDate;
  String _userid;

  bool get isAuth {
    return token != null;
  }

  String get token {
    print('passed not');

    if (_token != null &&
        expiryDate.isAfter(DateTime.now()) &&
        expiryDate != null) {
      print('passed');
      return _token;
    }
    return null;
  }

  String get userId {
    return _userid;
  }

  Future<void> singUp(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBO1eaW3_iXqb87-p-jA-Jho8XAEiYO3bM';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final jsonData = json.decode(response.body);
      if (jsonData['error'] != null) {
        throw HttpException(jsonData['error']['message']);
      }
      _token = jsonData['idToken'];
      _userid = jsonData['localId'];
      expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            jsonData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logIn(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBO1eaW3_iXqb87-p-jA-Jho8XAEiYO3bM';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final jsonData = json.decode(response.body);
      if (jsonData['error'] != null) {
        throw HttpException(jsonData['error']['message']);
      }
      _token = jsonData['idToken'];
      _userid = jsonData['localId'];
      expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            jsonData['expiresIn'],
          ),
        ),
      );
      notifyListeners();

      print(_token);
    } catch (error) {
      throw error;
    }
  }
}
