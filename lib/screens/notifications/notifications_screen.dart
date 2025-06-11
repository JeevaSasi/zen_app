import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/shimmer_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationItem> _notifications;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _notifications = [
      NotificationItem(
        id: 1,
        title: 'New Event',
        message: 'National Karate Championship registration is now open.',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        type: NotificationType.event,
      ),
      NotificationItem(
        id: 2,
        title: 'Attendance Update',
        message: 'You have attended 90% of classes this month.',
        time: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
        type: NotificationType.attendance,
      ),
      NotificationItem(
        id: 3,
        title: 'Achievement',
        message: 'Congratulations on your new belt promotion!',
        time: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
        type: NotificationType.achievement,
      ),
      NotificationItem(
        id: 4,
        title: 'Payment Due',
        message: 'Your monthly subscription payment is due in 2 days. Tap to view invoice.',
        time: DateTime.now().subtract(const Duration(days: 5)),
        isRead: false,
        type: NotificationType.payment,
        imageUrl: 'https://images.squarespace-cdn.com/content/v1/5769fc401b631bab1addb2ab/1588379682705-OLKTE0RXWRNAPCTQM0CO/ZugAcad+GPay+UP+QR+Code.jpg',
      ),
      NotificationItem(
        id: 5,
        title: 'New Team Member',
        message: 'Welcome our new instructor, Sensei Vikram!',
        time: DateTime.now().subtract(const Duration(days: 7)),
        isRead: true,
        type: NotificationType.team,
      ),
    ];
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  void _markAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });
  }
  
  void _showPaymentNotificationDialog(NotificationItem notification) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: notification.imageUrl != null
                      ? Image.network(
                          notification.imageUrl!,
                          width: double.infinity,
                          // height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 200,
                          color: Colors.red.shade100,
                          child: const Center(
                            child: Icon(
                              Icons.payment,
                              size: 80,
                              color: Colors.red,
                            ),
                          ),
                        ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Due date: ${DateFormat('MMM dd, yyyy').format(DateTime.now().add(const Duration(days: 2)))}',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Amount: \$50.00',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment processed successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text(
                        'Pay Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget.circular(width: 44, height: 44),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerWidget.rectangular(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 16,
                          ),
                          ShimmerWidget.rectangular(
                            width: 40,
                            height: 12,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const ShimmerWidget.rectangular(height: 14),
                      const SizedBox(height: 4),
                      ShimmerWidget.rectangular(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Mark all as read'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key('notification_${notification.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification dismissed'),
                      ),
                    );
                  },
                  child: InkWell(
                    onTap: () {
                      if (!notification.isRead) {
                        _markAsRead(notification);
                      }
                      
                      // For payment notifications, show dialog with image
                      if (notification.type == NotificationType.payment) {
                        _showPaymentNotificationDialog(notification);
                        return;
                      }
                      
                      // Navigate to related screen based on notification type
                      switch (notification.type) {
                        case NotificationType.event:
                          Navigator.pushNamed(context, '/events');
                          break;
                        case NotificationType.achievement:
                          Navigator.pushNamed(context, '/achievements');
                          break;
                        case NotificationType.team:
                          Navigator.pushNamed(context, '/team');
                          break;
                        default:
                          break;
                      }
                    },
                    child: Container(
                      color: notification.isRead
                          ? null
                          : Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildNotificationIcon(notification.type),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.title,
                                        style: TextStyle(
                                          fontWeight: notification.isRead
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _formatTime(notification.time),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notification.message,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                ),
                                if (notification.type == NotificationType.payment && notification.imageUrl != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.image,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Tap to view invoice',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData iconData;
    Color color;

    switch (type) {
      case NotificationType.event:
        iconData = Icons.event;
        color = Colors.blue;
        break;
      case NotificationType.attendance:
        iconData = Icons.calendar_today;
        color = Colors.orange;
        break;
      case NotificationType.achievement:
        iconData = Icons.emoji_events;
        color = Colors.amber;
        break;
      case NotificationType.payment:
        iconData = Icons.payment;
        color = Colors.red;
        break;
      case NotificationType.team:
        iconData = Icons.people;
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: color,
        size: 24,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final DateTime time;
  bool isRead;
  final NotificationType type;
  final String? imageUrl;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
    this.imageUrl,
  });
}

enum NotificationType {
  event,
  attendance,
  achievement,
  payment,
  team,
} 