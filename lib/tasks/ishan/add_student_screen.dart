import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _deptController = TextEditingController();
  final _semController = TextEditingController();
  final _cgpaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isSaving = false;

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

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // Check if roll number already exists
      final existing = await FirebaseFirestore.instance
          .collection('students')
          .where('rollNumber', isEqualTo: _rollController.text.trim())
          .get();

      if (existing.docs.isNotEmpty) {
        _showSnack('Roll number already exists!', Colors.red);
        setState(() => _isSaving = false);
        return;
      }

      await FirebaseFirestore.instance.collection('students').add({
        'name': _nameController.text.trim(),
        'rollNumber': _rollController.text.trim(),
        'department': _deptController.text.trim(),
        'semester': _semController.text.trim(),
        'cgpa': double.tryParse(_cgpaController.text.trim()) ?? 0.0,
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showSnack('Student added successfully!', Colors.green);
      if (mounted) Navigator.pop(context);
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
          'New Student Record',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
                  hint: 'Enter Name',
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter name' : null,
                ),
                _buildField(
                  controller: _rollController,
                  hint: 'Enter Roll Number',
                  keyboard: TextInputType.number,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter roll number' : null,
                ),
                _buildField(
                  controller: _deptController,
                  hint: 'Enter Department',
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter department' : null,
                ),
                _buildField(
                  controller: _semController,
                  hint: 'Enter Semester',
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter semester' : null,
                ),
                _buildField(
                  controller: _cgpaController,
                  hint: 'Enter CGPA',
                  keyboard: const TextInputType.numberWithOptions(decimal: true),
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
                  hint: 'Enter Phone Number',
                  keyboard: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter phone';
                    if (v.trim().length != 10) return 'Phone must be 10 digits';
                    return null;
                  },
                ),
                _buildField(
                  controller: _emailController,
                  hint: 'Enter Email',
                  keyboard: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter email';
                    if (!v.contains('@') || !v.contains('.')) {
                      return 'Enter valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
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
                              'Save',
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
    required String hint,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF5D4FBE), width: 1.5),
          ),
        ),
      ),
    );
  }
}