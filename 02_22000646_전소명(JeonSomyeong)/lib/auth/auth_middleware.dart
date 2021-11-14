import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return Get.find<AuthController>().user != null || route == '/login'
        ? null
        : const RouteSettings(name: '/login');
  }
}
