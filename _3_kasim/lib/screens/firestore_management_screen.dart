import 'package:flutter/material.dart';

import '../models/student.dart';
import '../services/firestore_student_service.dart';

String? _validatePoint(String? value) {
  final point = int.tryParse(value?.trim() ?? '');
  if (point == null || point < 0 || point > 100) {
    return 'Point must be between 0 and 100.';
  }
  return null;
}

class FirestoreManagementScreen extends StatefulWidget {
  const FirestoreManagementScreen({super.key});

  @override
  State<FirestoreManagementScreen> createState() =>
      _FirestoreManagementScreenState();
}

class _FirestoreManagementScreenState extends State<FirestoreManagementScreen> {
  final FirestoreStudentService _firestoreStudentService =
      FirestoreStudentService();
  late final Stream<List<Student>> _studentsStream =
      _firestoreStudentService.watchStudents();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameSurnameController.dispose();
    _emailController.dispose();
    _projectNameController.dispose();
    _pointController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _newStudentSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await _firestoreStudentService.addStudent(
        student: Student(
          id: '',
          nameSurname: _nameSurnameController.text.trim(),
          email: _emailController.text.trim(),
          projectName: _projectNameController.text.trim(),
          point: int.parse(_pointController.text.trim()),
          registrationDate: DateTime.now(),
        ),
      );
      if (!mounted) return;
      _formKey.currentState!.reset();
      _nameSurnameController.clear();
      _emailController.clear();
      _projectNameController.clear();
      _pointController.clear();
      FocusScope.of(context).unfocus();
      _showMessage('Student saved.');
    } catch (e) {
      if (mounted) _showMessage('Error: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<bool> _deleteStudent(Student student) async {
    try {
      await _firestoreStudentService.deleteStudent(id: student.id);
      if (mounted) _showMessage('${student.nameSurname} deleted from cloud.');
      return true;
    } catch (e) {
      if (mounted) _showMessage('Delete failed: $e');
      return false;
    }
  }

  Future<void> _pointUpdateDialog(Student student) async {
    final newPoint = await showDialog<int>(
      context: context,
      builder: (_) => _PointUpdateDialog(student: student),
    );
    if (newPoint == null || newPoint == student.point) return;

    try {
      await _firestoreStudentService.pointUpdate(
        id: student.id,
        newPoint: newPoint,
      );
      if (mounted) _showMessage('${student.nameSurname} point updated.');
    } catch (e) {
      if (mounted) _showMessage('Update failed: $e');
    }
  }

  Color _pointColor(int point) {
    if (point >= 80) return Colors.green;
    if (point > 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Firestore Management Screen'),
        backgroundColor: Colors.amber.shade600,
      ),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(child: _buildForm()),
          const SliverToBoxAdapter(child: Divider(thickness: 2)),
          StreamBuilder<List<Student>>(
            stream: _studentsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Cloud Error: ${snapshot.error}')),
                );
              }
              if (!snapshot.hasData) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final students = snapshot.data!;
              if (students.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No Students Found In Cloud.')),
                );
              }
              return SliverList.builder(
                itemCount: students.length,
                itemBuilder: (context, index) =>
                    _buildStudentTile(students[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameSurnameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Name Surname',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Name Surname is required.'
                  : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                final isValid = RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(email);
                return isValid ? null : 'Enter a valid email.';
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _projectNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Project Name',
                prefixIcon: Icon(Icons.work),
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Project Name is required.'
                  : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _pointController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Point (0-100)',
                prefixIcon: Icon(Icons.grade),
                border: OutlineInputBorder(),
              ),
              validator: _validatePoint,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
              ),
              onPressed: _isSaving ? null : _newStudentSave,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(_isSaving ? 'Saving...' : 'Save Cloud.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentTile(Student student) {
    return Dismissible(
      key: ValueKey(student.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_forever, color: Colors.white),
      ),
      confirmDismiss: (_) => _deleteStudent(student),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _pointColor(student.point),
          child: Text(
            '${student.point}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          student.nameSurname,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${student.email} - Project: ${student.projectName}'),
        trailing: IconButton(
          onPressed: () => _pointUpdateDialog(student),
          icon: const Icon(Icons.edit, color: Colors.amberAccent),
        ),
      ),
    );
  }
}

class _PointUpdateDialog extends StatefulWidget {
  const _PointUpdateDialog({required this.student});

  final Student student;

  @override
  State<_PointUpdateDialog> createState() => _PointUpdateDialogState();
}

class _PointUpdateDialogState extends State<_PointUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller = TextEditingController(
    text: '${widget.student.point}',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, int.parse(_controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.student.nameSurname} - Update Point'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'New Point (0-100)'),
          validator: _validatePoint,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Update')),
      ],
    );
  }
}
