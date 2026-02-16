import 'package:get/get.dart';
import '../../data/services/api_service.dart';

class NotificationController extends GetxController {
  final api = ApiService();
  
  var notifications = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      
      final response = await api.getNotifications();
      print('API Response: ${response.data}');
      
      if (response.data != null) {
        // Parse the API response and convert to our format
        final List<dynamic> notifList = response.data['data'] ?? response.data;
        print('Notification list: $notifList');
        
        notifications.value = notifList.map((item) => {
          'id': item['id'],
          'icon': 'notifications',
          'iconColor': 'blue',
          'title': item['judul'] ?? item['title'] ?? 'Notification',
          'subtitle': item['deskripsi'] ?? item['description'] ?? '',
          'time': item['created_at'] ?? item['time'] ?? 'Now',
          'hasActions': false,
        }).toList().cast<Map<String, dynamic>>();
        
        print('Parsed notifications: ${notifications.length}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      notifications.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void markAsRead(List<int> indices) {
    // API call to mark notifications as read
    Get.snackbar('Success', '${indices.length} notifications marked as read');
  }

  void deleteNotifications(List<int> indices) {
    // API call to delete notifications
    notifications.removeWhere((item) => indices.contains(notifications.indexOf(item)));
    Get.snackbar('Success', 'Notifications deleted');
  }
}