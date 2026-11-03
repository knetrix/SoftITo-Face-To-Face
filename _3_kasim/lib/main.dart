// flutter pub add firebase_core cloud_firestore  [firebase_auth firebase_storage]
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/student.dart';
import 'services/firestore_student_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FirebaseApp());
}

class FirebaseApp extends StatelessWidget {
  const FirebaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const FirebaseHomePage(),
    );
  }
}

class FirebaseHomePage extends StatelessWidget {
  const FirebaseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: FutureBuilder<List<Student>>(
        future: FirestoreStudentService().getStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final students = snapshot.data ?? [];
          if (students.isEmpty) {
            return const Center(child: Text('No students found.'));
          }
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                title: Text(student.nameSurname),
                subtitle: Text('${student.email} - ${student.projectName}'),
                trailing: Text('${student.point}'),
              );
            },
          );
        },
      ),
    );
  }
}