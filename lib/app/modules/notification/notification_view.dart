import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notification_controller.dart';

class NotificationView extends StatefulWidget {
  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  NotificationController get controller => Get.find<NotificationController>();
  bool isSelectionMode = false;
  Set<int> selectedItems = {};

  void toggleSelection(int index) {
    setState(() {
      if (selectedItems.contains(index)) {
        selectedItems.remove(index);
      } else {
        selectedItems.add(index);
      }
      
      if (selectedItems.isEmpty) {
        isSelectionMode = false;
      }
    });
  }

  void enterSelectionMode(int index) {
    setState(() {
      isSelectionMode = true;
      selectedItems.add(index);
    });
  }

  void exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
      selectedItems.clear();
    });
  }

  void selectAll() {
    setState(() {
      selectedItems = Set.from(List.generate(controller.notifications.length, (i) => i));
    });
  }

  void markAsRead() {
    controller.markAsRead(selectedItems.toList());
    exitSelectionMode();
  }

  void deleteSelected() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Delete Notifications?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Are you sure you want to delete ${selectedItems.length} notification(s)?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Get.back();
                        controller.deleteNotifications(selectedItems.toList());
                        exitSelectionMode();
                      },
                      child: Text('Delete', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Row(
          children: [
            Text(
              isSelectionMode ? '${selectedItems.length} selected' : 'Notifications',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!isSelectionMode) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.notifications.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        )),
        actions: [
          if (!isSelectionMode) ...[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black87),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.black87),
              onPressed: () {
                print('test');
              },
            ),
          ] else ...[
            TextButton(
              onPressed: selectAll,
              child: Text(
                'Select all',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: controller.fetchNotifications,
              child: Column(
                children: [
                  if (!isSelectionMode && controller.notifications.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.notifications.length,
                        itemBuilder: (context, index) {
                          final notif = controller.notifications[index];
                          final isSelected = selectedItems.contains(index);
                          
                          return _notificationItem(
                            icon: _getIconData(notif['icon']),
                            iconColor: _getColor(notif['iconColor']),
                            title: notif['title'],
                            subtitle: notif['subtitle'],
                            time: notif['time'],
                            hasActions: notif['hasActions'],
                            isSelected: isSelected,
                            index: index,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
      ),
      bottomNavigationBar: isSelectionMode
          ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.green.shade700),
                      ),
                      onPressed: markAsRead,
                      child: Text(
                        'Mark as read',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: deleteSelected,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'inventory_2': return Icons.inventory_2;
      case 'notifications_active_outlined': return Icons.notifications_active_outlined;
      case 'meeting_room': return Icons.meeting_room;
      case 'restaurant': return Icons.restaurant;
      case 'business': return Icons.business;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'hotel': return Icons.hotel;
      default: return Icons.notifications;
    }
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'pink': return Colors.pink;
      case 'purple': return Colors.purple;
      case 'blue': return Colors.blue;
      case 'orange': return Colors.orange;
      case 'black': return Colors.black;
      case 'red': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _notificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool hasActions,
    required bool isSelected,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        if (isSelectionMode) {
          toggleSelection(index);
        }
      },
      onLongPress: () {
        if (!isSelectionMode) {
          enterSelectionMode(index);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.green.shade700, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSelectionMode)
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.green.shade700 : Colors.grey.shade400,
                  size: 24,
                ),
              ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(text: title + ' '),
                        TextSpan(
                          text: subtitle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}