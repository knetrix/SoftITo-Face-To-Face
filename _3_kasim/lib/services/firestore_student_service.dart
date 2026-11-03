import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/student.dart';

class FirestoreStudentService {
  final CollectionReference _studenCollection = FirebaseFirestore.instance.collection('students');

  Future<String> addStudent({required Student student}) async {
    try {
      final docRef = await _studenCollection.add({
        'nameSurname': student.nameSurname,
        'email': student.email,
        'projectName': student.projectName,
        'point': student.point,
        'registrationDate': FieldValue.serverTimestamp(),
      });
      debugPrint('Student Added');
      return docRef.id;
    } catch (e) {
      debugPrint('Error Adding Student: $e');
      rethrow;
    }
  }

  Future<void> saveStudentWithId({required Student student}) async {
    await _studenCollection.doc(student.id).set({
      'nameSurname': student.nameSurname,
      'email': student.email,
      'projectName': student.projectName,
      'point': student.point,
      'registrationDate': FieldValue.serverTimestamp(),
      'updateDate': FieldValue.serverTimestamp(),
    },SetOptions(merge: true));
  }

  Future<List<Student>> getStudents() async {
    try {
      final QuerySnapshot snapshot = await _studenCollection.orderBy('point', descending: true).get();
      return snapshot.docs.map((doc) => Student.fromFireStore(doc)).toList();
    } catch (e) {
      debugPrint('Error Getting Students: $e');
      return [];
    }
  }

  Stream<List<Student>> watchStudents() {
    return _studenCollection
        .orderBy('point', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Student.fromFireStore).toList());
  }

  Future<void> pointUpdate({required String id, required int newPoint}) async {
    await _studenCollection.doc(id).update({
      'point': newPoint,
      'updateDate': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteStudent({required String id}) async {
    await _studenCollection.doc(id).delete();
    debugPrint('Data With $id was Deleted.');
  }
}
