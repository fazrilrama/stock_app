import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/services/api_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/time_ago.dart';

class HomeController extends GetxController {
  final box = GetStorage();
  final api = ApiService();

  var userName = "Guest User".obs;
  var nik = "?".obs;
  var recentActivities = <Map<String, dynamic>>[].obs;
  var isLoadingRecent = false.obs;

  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Get stored values
    final token = box.read('token');
    final fullname = box.read('fullname');
    final username = box.read('username');
    
    // Update observable variables if values exist
    if (fullname != null) {
      userName.value = fullname;
    }

    if(username  != null) {
      nik.value = username;
    }
    
    // Load recent activities
    fetchRecentActivities();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void logout() {
    box.erase();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> refreshData() async {
    await fetchRecentActivities();
  }

  Future<void> fetchRecentActivities() async {
    try {
      isLoadingRecent.value = true;
      
      final response = await api.getRecently();
      
      if (response.data != null) {
        final List<dynamic> activities = response.data['data'] ?? response.data;

        print(activities);
        
        recentActivities.value = activities.map((item) => {
          'title': '${item['subarea_ket'] ?? ''} - ${item['warehouse_id'] ?? item['nama'] ?? 'Activity'}',
          'subtitle': item['nm_checker'] ?? item['kode'] ?? 'dsad',
          'date': TimeAgo.format(item['updated_at'] ?? item['updated_at']),
          'icon': 'assignment_rounded',
          'color': (item['is_closed'] == 1) ? 'red' : 'green',
        }).toList().cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error fetching recent activities: $e');
      recentActivities.value = [];
    } finally {
      isLoadingRecent.value = false;
    }
  }
}
