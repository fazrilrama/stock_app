import 'package:get/get.dart';
import 'opname_detail_controller.dart';

class OpnameDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpnameDetailController>(() => OpnameDetailController());
  }
}