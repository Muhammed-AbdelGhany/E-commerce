import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userid,
        'expiryDate': expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
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
        print(jsonData['error']['message']);
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

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userid,
        'expiryDate': expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
      print(prefs.getString('userData'));
      notifyListeners();
      print(_token);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('no key');
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    final expirytime = DateTime.parse(extractedData['expiryDate']);

    if (expirytime.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedData['token'];

    _userid = extractedData['userId'];
    expiryDate = expirytime;

    notifyListeners();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userid = null;
    expiryDate = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }
}
