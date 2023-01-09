import 'package:get/get.dart';
import '../controller/login_details_controller.dart';


class LoginDetailsBindings extends Bindings {

  @override
  void dependencies() async {
    Get.lazyPut<LoginDetailsController>(() => LoginDetailsController());
  }
}