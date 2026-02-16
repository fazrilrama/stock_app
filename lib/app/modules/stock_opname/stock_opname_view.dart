import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';
import 'stock_opname_controller.dart';

class StockOpnameView extends StatelessWidget {
  final StockOpnameController controller = Get.put(StockOpnameController());
  final box = GetStorage();

  bool get isAdmin => (box.read('role_id') ?? 0) == 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Stock Phisik Harian'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _filterSection(),
          Expanded(
            child: Obx(() => controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: controller.fetchStockOpname,
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: controller.stockOpnameList.length + (controller.hasMoreData.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.stockOpnameList.length) {
                          // Load more indicator
                          if (!controller.isLoadingMore.value) {
                            controller.loadMore();
                          }
                          return Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        
                        final item = controller.stockOpnameList[index];
                        return _stockOpnameCard(
                          id: item['id']?.toString() ?? '',
                          revisi: item['revisi']?.toString() ?? '',
                          warehouseId: item['warehouse_id']?.toString() ?? '',
                          location: item['location']?.toString() ?? '',
                          status: item['status']?.toString() ?? '',
                          date: item['created_at']?.toString() ?? '',
                          itemCount: item['item_count'] ?? 0,
                          isDisabled: item['disable'] ?? false,
                        );
                      },
                    ),
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.CREATE_OPNAME);
        },
        backgroundColor: Colors.green.shade700,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _stockOpnameCard({
    required String id,
    required String revisi,
    required String warehouseId,
    required String location,
    required String status,
    required String date,
    required int itemCount,
    required bool isDisabled,
  }) {
    Color statusColor = status == '0' ? Colors.green : Colors.red;
    
    bool canEdit = isAdmin && !isDisabled;
    
    return Dismissible(
      key: Key('stock_$id'),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _lihatDetail(id, warehouseId);
        } else if (direction == DismissDirection.endToStart && canEdit) {
          _lihatEdit(id, warehouseId);
        }
        return false; // Don't actually dismiss
      },
      background: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.visibility, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text('Detail', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
      secondaryBackground: canEdit ? Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text('Edit', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ) : Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text('Disabled', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.inventory_sharp,
              color: statusColor,
              size: 24,
            ),
          ),
          title: Text(
            warehouseId,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                "Checker: ${location}",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Revisi: ${revisi} | ${date}",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              // ignore: unrelated_type_equality_checks
              (status == 1) ? 'Buka Gudang' : 'Tutup Gudang',
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _dateField('Start Date', 'Select start date'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _dateField('End Date', 'Select end date'),
              ),
            ],
          ),
          SizedBox(height: 12),
          _statusDropdown(),
        ],
      ),
    );
  }

  Widget _dateField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              if (label == 'Start Date') {
                controller.updateFilters(start: dateStr);
              } else {
                controller.updateFilters(end: dateStr);
              }
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hint,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text('Select status'),
              items: ['All', 'Completed', 'In Progress', 'Pending']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.updateFilters(status: value == 'All' ? '' : value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _lihatDetail(String id, String warehouseId) {
    // Navigate to detail page - equivalent to lihatDetail(item)
    Get.toNamed('${Routes.OPNAME_DETAIL}/$id');
  }

  void _lihatEdit(String id, String warehouseId) {
    // Navigate to edit page - equivalent to lihatEdit(item) with role check
    print('Navigate to edit page for ID: $id, Warehouse: $warehouseId');
    // Add your edit navigation logic here
  }
}