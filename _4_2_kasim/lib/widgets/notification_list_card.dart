import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationListCard extends StatelessWidget {
  final List<NotificationModel> notifications;
  final String token;
  final bool 