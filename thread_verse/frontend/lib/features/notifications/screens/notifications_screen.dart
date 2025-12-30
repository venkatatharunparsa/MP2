import 'package:flutter/material.dart';
import '../../../core/constants/mock_data.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {},
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mockNotifications.length,
        itemBuilder: (context, index) {
          final notification = mockNotifications[index];
          return NotificationTile(
            username: notification['username'],
            action: notification['action'],
            timeAgo: notification['timeAgo'],
            content: notification['content'],
            isRead: notification['isRead'],
            onTap: () {},
          );
        },
      ),
    );
  }
}
