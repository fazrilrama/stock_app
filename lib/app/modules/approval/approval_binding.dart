import 'package:get/get.dart';
import 'approval_controller.dart';

class ApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApprovalController>(() => ApprovalController());
  }
}