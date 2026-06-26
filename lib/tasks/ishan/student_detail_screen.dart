import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_student_screen.dart';

class StudentDetailScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const StudentDetailScreen({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late Map<String, dynamic> _student;

  @override
  void initState() {
    super.initState();
    _student = Map<String, dynamic>.from(widget.data);
  }

  Future<void> _refreshData() async {
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.docId)
        .get();
    if (doc.exists && mounted) {
      setState(() => _student = doc.data() as Map<String, dynamic>);
    }
  }

  Future<void> _deleteStudent() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text(
          'Are you sure you want to delete ${_student['name']}\'s record?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.docId)
          .delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student details deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _updateStudent() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditStudentScreen(
          docId: widget.docId,
          existingData: _student,
        ),
      ),
    );

    if (updated == true) {
      await _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _student['name']?.toString() ?? '-';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // Avatar
              const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 70, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Details
              Expanded(
                child: ListView(
                  children: [
                    _buildDetailField('Name', _student['name']),
                    _buildDetailField('Roll Number', _student['rollNumber']),
                    _buildDetailField('Department', _student['department']),
                    _buildDetailField('Semester', _student['semester']),
                    _buildDetailField('CGPA', _student['cgpa']?.toString()),
                    _buildDetailField('Phone No.', _student['phone']),
                    _buildDetailField('Email', _student['email']),
                  ],
                ),
              ),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton(
                      label: 'Update',
                      color: const Color(0xFF4CAF50),
                      onTap: _updateStudent,
                    ),
                    _actionButton(
                      label: 'Delete',
                      color: Colors.red,
                      onTap: _deleteStudent,
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

  Widget _buildDetailField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$label: ${value ?? "-"}',
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 130,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 3,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}