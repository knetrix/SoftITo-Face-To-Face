import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String nameSurname;
  final String email;
  final String projectName;
  final int point;
  final DateTime registrationDate;

  const Student({
    required this.id,
    required this.nameSurname,
    required this.email,
    required this.projectName,
    required this.point,
    required this.registrationDate,
  });

  factory Student.fromFireStore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    return Student(
      id: snapshot.id,
      nameSurname: data['nameSurname'] as String? ?? '',
      email: data['email'] as String? ?? '',
      projectName: data['projectName'] as String? ?? '',
      point: (data['point'] as num?)?.toInt() ?? 0,
      registrationDate: (data['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
