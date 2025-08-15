import 'package:flutter/material.dart';
import '../models/user.dart';
import '../methods/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get user => _user;

  Future<void> refreshUser() async {
    try {
      User user = await _authMethods.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error refreshing user: $e');
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
