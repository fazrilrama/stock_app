import 'package:get/get.dart';
import '../../data/services/api_service.dart';

class ApprovalController extends GetxController {
  final api = ApiService();
  var approvalList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApprovals();
  }

  Future<void> fetchApprovals() async {
    try {
      isLoading.value = true;
      
      final response = await api.getApprovalRequests();
      
      if (response.data != null) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        
        approvalList.value = data.map((item) => {
          'id': item['id'],
          'title': item['warehouse_id'] ?? 'Approval Request',
          'description': item['location'] ?? 'No description',
          'status': item['status'] ?? 'Pending',
          'date': item['created_at'] ?? '',
          'requester': item['created_by'] ?? 'Unknown'
        }).toList().cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error fetching approvals: $e');
      approvalList.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void approveItem(dynamic id) {
    final index = approvalList.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      approvalList[index]['status'] = 'Approved';
      approvalList.refresh();
      Get.snackbar('Success', 'Item approved successfully');
    }
  }

  void rejectItem(dynamic id) {
    final index = approvalList.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      approvalList[index]['status'] = 'Rejected';
      approvalList.refresh();
      Get.snackbar('Success', 'Item rejected');
    }
  }
}