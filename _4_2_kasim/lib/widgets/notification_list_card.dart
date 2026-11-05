import 'package:flutter/material.dart';

import '../models/notification_model.dart';

class NotificationListCard extends StatelessWidget {
  final List<NotificationModel> notifications;
  final String token;
  final bool isSubscribedToTopic;
  final ValueChanged<bool> onSubscribeChange;

  const NotificationListCard({
    super.key,
    required this.notifications,
    required this.token,
    required this.isSubscribedToTopic,
    required this.onSubscribeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications, color: Color(0xFF006C4A)),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'FCM Notification Center',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: isSubscribedToTopic,
                  onChanged: onSubscribeChange,
                  activeThumbColor: const Color.fromARGB(15, 160, 40, 50),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isSubscribedToTopic ? 'Subscribed' : 'Not Subscribed',
              style: TextStyle(
                color: isSubscribedToTopic
                    ? const Color.fromARGB(15, 24, 59, 17)
                    : Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Device FCM Token",
                    style: TextStyle(
                      color: Color.fromARGB(255, 26, 40, 52),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SelectableText(
                    token.isEmpty ? 'Fetching Token...' : token,
                    style: const TextStyle(
                      color: Color(0xFF006C4A),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Coming Notifications (${notifications.length}):',
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            notifications.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      'No Notifications Available.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notifications.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final b = notifications[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(0, 123, 238, 230),
                          child: Icon(
                            Icons.mark_email_unread_outlined,
                            color: Color.fromARGB(0, 113, 25, 25),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          b.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(b.body),
                        trailing: Text(
                          '${b.date.hour.toString().padLeft(2, '0')}:${b.date.minute.toString().padLeft(2, '0')}',
                          // Neden Const Kullanılmadı? ...
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
