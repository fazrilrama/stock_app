import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/services/api_service.dart';

class ProfileController extends GetxController {
  final box = GetStorage();
  final api = ApiService();
  
  var userName = "Guest User".obs;
  var isLoading = false.obs;
  var userEmail = "".obs;
  var userRole = "".obs;
  var profile = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

    } catch(e) {
      print('Error fetching profile: $e');
      profile.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void loadUserData() {
    final fullname = box.read('fullname');
    final username = box.read('username');
    
    if (fullname != null) {
      userName.value = fullname;
    }
  }

  Future<void> refreshProfile() async {
    loadUserData();
    await Future.delayed(Duration(seconds: 1));
  }
}