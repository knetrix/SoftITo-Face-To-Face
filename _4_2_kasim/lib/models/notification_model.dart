class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? date,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
    );
  }
}
