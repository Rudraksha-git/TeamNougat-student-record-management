import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditStudentScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> existingData;

  const EditStudentScreen({
    super.key,
    required this.docId,
    required this.existingData,
  });

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _rollController;
  late TextEditingController _deptController;
  late TextEditingController _semController;
  late TextEditingController _cgpaController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.existingData;
    _nameController = TextEditingController(text: d['name']?.toString() ?? '');
    _rollController =
        TextEditingController(text: d['rollNumber']?.toString() ?? '');
    _deptController =
        TextEditingController(text: d['department']?.toString() ?? '');
    _semController =
        TextEditingController(text: d['semester']?.toString() ?? '');
    _cgpaController =
        TextEditingController(text: d['cgpa']?.toString() ?? '');
    _phoneController =
        TextEditingController(text: d['phone']?.toString() ?? '');
    _emailController =
        TextEditingController(text: d['email']?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    _deptController.dispose();
    _semController.dispose();
    _cgpaController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final newRoll = _rollController.text.trim();
      final oldRoll = widget.existingData['rollNumber']?.toString() ?? '';
      if (newRoll != oldRoll) {
        final dup = await FirebaseFirestore.instance
            .collection('students')
            .where('rollNumber', isEqualTo: newRoll)
            .get();
        if (dup.docs.isNotEmpty) {
          _showSnack('Roll number already exists!', Colors.red);
          setState(() => _isSaving = false);
          return;
        }
      }

      await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.docId)
          .update({
        'name': _nameController.text.trim(),
        'rollNumber': newRoll,
        'department': _deptController.text.trim(),
        'semester': _semController.text.trim(),
        'cgpa': double.tryParse(_cgpaController.text.trim()) ?? 0.0,
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _showSnack('Student details updated successfully!', Colors.green);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showSnack('Error: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Edit Student Record',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                _buildField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter name' : null,
                ),
                _buildField(
                  controller: _rollController,
                  label: 'Roll Number',
                  icon: Icons.tag,
                  keyboard: TextInputType.number,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter roll number' : null,
                ),
                _buildField(
                  controller: _deptController,
                  label: 'Department',
                  icon: Icons.school,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter department' : null,
                ),
                _buildField(
                  controller: _semController,
                  label: 'Semester',
                  icon: Icons.calendar_month,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter semester' : null,
                ),
                _buildField(
                  controller: _cgpaController,
                  label: 'CGPA',
                  icon: Icons.star,
                  keyboard:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter CGPA';
                    final cgpa = double.tryParse(v.trim());
                    if (cgpa == null) return 'Enter valid number';
                    if (cgpa < 0 || cgpa > 10) return 'CGPA must be 0–10';
                    return null;
                  },
                ),
                _buildField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboard: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter phone';
                    if (v.trim().length != 10) return 'Phone must be 10 digits';
                    return null;
                  },
                ),
                _buildField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboard: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter email';
                    if (!v.contains('@') || !v.contains('.')) {
                      return 'Enter valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                Center(
                  child: SizedBox(
                    width: 180,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _updateStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboard,
          validator: validator,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF5D4FBE)),
            hintText: label,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 15,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF5D4FBE),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}