import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _signOutTimer;

  String get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    if (token != null) {
      return true;
    }
    return false;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseBody['expiresIn'])));
      _autoSignOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expireDate': _expireDate.toIso8601String(),
        'userId': _userId
      });
      prefs.setString('shopAppUserData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDlfXMbd4VeUMU96BblCxlZxTj8aV6WXeY';
    return _authenticate(email, password, url);
  }

  Future<void> signIn(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDlfXMbd4VeUMU96BblCxlZxTj8aV6WXeY';
    return _authenticate(email, password, url);
  }

  Future<bool> tryAutoLogin() async {
    print('tried to autoLogin');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('shopAppUserData')) {
      return false;
    }
    final extractedData = json.decode(prefs.getString('shopAppUserData'));
    final receivedExpireDate = DateTime.parse(extractedData['expireDate']);
    if (receivedExpireDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _expireDate = receivedExpireDate;
    _userId = extractedData['userId'];
    _autoSignOut();
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    _userId = null;
    _token = null;
    _expireDate = null;
    if (_signOutTimer != null) {
      _signOutTimer.cancel();
      _signOutTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('shopAppUserData');
  }

  void _autoSignOut() {
    if (_signOutTimer != null) {
      _signOutTimer.cancel();
    }
    _signOutTimer = Timer(
        Duration(seconds: _expireDate.difference(DateTime.now()).inSeconds),
        signOut);
  }
}
