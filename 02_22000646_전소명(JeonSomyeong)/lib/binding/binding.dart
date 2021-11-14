import 'package:get/get.dart';
import 'package:moappfinal/controller/auth_controller.dart';
import 'package:moappfinal/controller/product_controller.dart';
import 'package:moappfinal/controller/user_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<ProductsController>(ProductsController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
  }
}
