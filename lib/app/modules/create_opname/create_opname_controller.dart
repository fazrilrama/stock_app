import 'package:get/get.dart';

class CreateOpnameController extends GetxController {
  var warehouseId = ''.obs;
  var location = ''.obs;
  var selectedDate = DateTime.now().obs;
  var isLoading = false.obs;
  
  void updateWarehouseId(String value) {
    warehouseId.value = value;
  }
  
  void updateLocation(String value) {
    location.value = value;
  }
  
  void updateDate(DateTime date) {
    selectedDate.value = date;
  }
  
  Future<void> createOpname() async {
    try {
      isLoading.value = true;
      // API call to create opname
      await Future.delayed(Duration(seconds: 2)); // Mock delay
      Get.back();
      Get.snackbar('Success', 'Stock Opname created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create stock opname');
    } finally {
      isLoading.value = false;
    }
  }
}