import 'package:get/get.dart';
import 'create_opname_controller.dart';

class CreateOpnameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateOpnameController>(() => CreateOpnameController());
  }
}