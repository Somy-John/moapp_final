import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:moappfinal/controller/auth_controller.dart';
import 'package:moappfinal/model/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel> _userModel = UserModel().obs;

  // @override
  // onInit() {
  //   print("Get Data according to the user");
  //   AuthController ac = Get.put(AuthController());
  //   ac.listen
  // }

  UserModel get user => _userModel.value;

  set user(UserModel value) => _userModel.value = value;

  void clear() {
    print("User Controller - Model Clearaed");
    _userModel.value = UserModel();
    _userModel.value.initalized = false;
  }
}
