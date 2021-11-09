import 'package:get/get.dart';
import 'package:moappfinal/controller/auth_controller.dart';
import 'package:moappfinal/controller/product_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<ProductsController>(ProductsController(), permanent: true);
    // Get.put<LocationController>(LocationController(), permanent: true);
    // Get.put<StatusController>(StatusController(), permanent: true);
    // Get.put<SystemMessageController>(SystemMessageController(),
    // permanent: true);
  }
}
