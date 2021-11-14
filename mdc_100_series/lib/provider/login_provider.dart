import 'package:flutter/widgets.dart';

class LoginProvider with ChangeNotifier {
  String _name = "Guest";
  get greet => 'Wellcome ' + _name + "!";
  LoginProvider();
  void userLogin(String name) {
    _name = name;
    notifyListeners();
  }
}
