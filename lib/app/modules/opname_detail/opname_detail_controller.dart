import 'package:get/get.dart';
import '../../data/services/api_service.dart';

class OpnameDetailController extends GetxController {
  final api = ApiService();
  
  var opnameDetail = <String, dynamic>{}.obs;
  var isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    final id = Get.parameters['id'];
    if (id != null) {
      fetchOpnameDetail(id);
    }
  }
  
  Future<void> fetchOpnameDetail(String id) async {
    try {
      isLoading.value = true;

      print(id);
      
      final response = await api.getOpnameDetail(id);
      
      if (response.data != null) {
        var data = response.data['data'] ?? response.data;

        print(data);
        
        // Handle if API returns a list instead of single object
        if (data is List && data.isNotEmpty) {
          opnameDetail.value = data.first;
        } else if (data is Map<String, dynamic>) {
          opnameDetail.value = data;
        }
      }
    } catch (e) {
      print('Error fetching opname detail: $e');
      Get.snackbar('Error', 'Failed to load detail');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refresh() async {
    final id = Get.parameters['id'];
    if (id != null) {
      await fetchOpnameDetail(id);
    }
  }
}