import 'package:get/get.dart';
import '../../data/services/api_service.dart';

class StockOpnameController extends GetxController {
  final api = ApiService();
  
  var stockOpnameList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var startDate = ''.obs;
  var endDate = ''.obs;
  var selectedStatus = ''.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchStockOpname();
  }
  
  Future<void> fetchStockOpname({bool isRefresh = true}) async {
    try {
      if (isRefresh) {
        isLoading.value = true;
        currentPage = 1;
        hasMoreData.value = true;
      } else {
        isLoadingMore.value = true;
      }
      
      final response = await api.getStockOpname(
        startDate: startDate.value,
        endDate: endDate.value,
        status: selectedStatus.value,
        page: currentPage,
      );
      
      if (response.data != null) {
        final List<dynamic> data = response.data['data'] ?? response.data;

        print(data);
        final newItems = data.map((item) => {
          'id': item['id'],
          'revisi': item['revisi'] ?? 0,
          'warehouse_id': "${item['nama_gudang']} - ${item['warehouse_id']}",
          'location': item['nm_checker'] ?? 'Unknown Location',
          'status': item['is_closed'] ?? 'N/A',
          'created_at': item['created_at'] ?? '',
          'item_count': item['item_count'] ?? 0,
        }).toList().cast<Map<String, dynamic>>();
        
        if (isRefresh) {
          stockOpnameList.value = newItems;
        } else {
          stockOpnameList.addAll(newItems);
        }
        
        hasMoreData.value = data.length == 10;
        if (hasMoreData.value) currentPage++;
      }
    } catch (e) {
      print('Error fetching stock opname: $e');
      if (isRefresh) stockOpnameList.value = [];
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
  
  void updateFilters({String? start, String? end, String? status}) {
    if (start != null) startDate.value = start;
    if (end != null) endDate.value = end;
    if (status != null) selectedStatus.value = status;
    fetchStockOpname(isRefresh: true);
  }
  
  void loadMore() {
    if (!isLoadingMore.value && hasMoreData.value) {
      fetchStockOpname(isRefresh: false);
    }
  }
}