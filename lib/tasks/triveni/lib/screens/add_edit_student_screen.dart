import 'package:flutter/material.dart'; 

import '../models/student.dart'; 

import '../services/firestore_service.dart'; 

  

class AddEditStudentScreen extends StatefulWidget { 

  // null = Add mode | Student object = Edit mode 

  final Student? student; 

  const AddEditStudentScreen({super.key, this.student}); 

  

  @override 

  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState(); 

} 

  

class _AddEditStudentScreenState extends State<AddEditStudentScreen> { 

  final _formKey = GlobalKey<FormState>(); // Unique key to control the Form 

  final FirestoreService _service = FirestoreService(); 

  bool _isLoading = false; // Shows CircularProgressIndicator while saving 

  

  // One controller per text field 

  late TextEditingController _nameCtrl; 

  late TextEditingController _rollCtrl; 

  late TextEditingController _deptCtrl; 

  late TextEditingController _semCtrl; 

  late TextEditingController _cgpaCtrl; 

  late TextEditingController _phoneCtrl; 

  late TextEditingController _emailCtrl; 

  

  bool get isEditing => widget.student != null; 

  

  @override 

  void initState() { 

    super.initState(); 

    // In Edit mode: pre-fill with existing data 

    // In Add mode: initialize empty (widget.student is null, so ?? '' gives '') 

    _nameCtrl  = TextEditingController(text: widget.student?.name ?? ''); 

    _rollCtrl  = TextEditingController(text: widget.student?.rollNumber ?? ''); 

    _deptCtrl  = TextEditingController(text: widget.student?.department ?? ''); 

    _semCtrl   = TextEditingController(text: widget.student?.semester ?? ''); 

    _cgpaCtrl  = TextEditingController(text: widget.student?.cgpa ?? ''); 

    _phoneCtrl = TextEditingController(text: widget.student?.phone ?? ''); 

    _emailCtrl = TextEditingController(text: widget.student?.email ?? ''); 

  } 

  

  @override 

  void dispose() { 

    // Dispose all controllers to prevent memory leaks 

    _nameCtrl.dispose(); _rollCtrl.dispose(); _deptCtrl.dispose(); 

    _semCtrl.dispose();  _cgpaCtrl.dispose(); _phoneCtrl.dispose(); 

    _emailCtrl.dispose(); 

    super.dispose(); 

  } 

  

  Future<void> _submit() async { 

    // validate() runs all validator functions; returns false if any fail 

    if (!_formKey.currentState!.validate()) return; 

  

    setState(() => _isLoading = true); 

  

    final student = Student( 

      id: widget.student?.id,  // Keep existing ID in edit mode 

      name:       _nameCtrl.text.trim(), 

      rollNumber: _rollCtrl.text.trim(), 

      department: _deptCtrl.text.trim(), 

      semester:   _semCtrl.text.trim(), 

      cgpa:       _cgpaCtrl.text.trim(), 

      phone:      _phoneCtrl.text.trim(), 

      email:      _emailCtrl.text.trim(), 

    ); 

  

    try { 

      if (isEditing) { 

        await _service.updateStudent(student); 

      } else { 

        await _service.addStudent(student); 

      } 

  

      if (mounted) { 

        ScaffoldMessenger.of(context).showSnackBar(SnackBar( 

          content: Text(isEditing ? 'Student updated!' : 'Student added!'), 

          backgroundColor: Colors.green, 

        )); 

        Navigator.pop(context); // Return to HomeScreen 

      } 

    } catch (e) { 

      if (mounted) { 

        ScaffoldMessenger.of(context).showSnackBar(SnackBar( 

          content: Text('Error: $e'), 

          backgroundColor: Colors.red, 

        )); 

      } 

    } finally { 

      if (mounted) setState(() => _isLoading = false); 

    } 

  } 

  

  // Reusable builder for a labeled input field with an icon 

  Widget _field({ 

    required TextEditingController ctrl, 

    required String label, 

    required IconData icon, 

    TextInputType type = TextInputType.text, 

    String? Function(String?)? validator, 

  }) { 

    return Padding( 

      padding: const EdgeInsets.symmetric(vertical: 8), 

      child: TextFormField( 

        controller: ctrl, 

        keyboardType: type, 

        // Default validator: field must not be empty 

        validator: validator ?? 

            (v) => (v == null || v.trim().isEmpty) ? 'Required' : null, 

        decoration: InputDecoration( 

          labelText: label, 

          prefixIcon: Icon(icon, color: const Color(0xFFF5C518)), 

          border: OutlineInputBorder( 

            borderRadius: BorderRadius.circular(12)), 

          focusedBorder: OutlineInputBorder( 

            borderRadius: BorderRadius.circular(12), 

            borderSide: const BorderSide( 

              color: Color(0xFFF5C518), width: 2)), 

        ), 

      ), 

    ); 

  } 

  

  @override 

  Widget build(BuildContext context) { 

    return Scaffold( 

      appBar: AppBar( 

        title: Text(isEditing ? 'Edit Student' : 'Add Student'), 

      ), 

      body: SingleChildScrollView( 

        padding: const EdgeInsets.all(16), 

        child: Form( 

          key: _formKey, 

          child: Column( 

            children: [ 

              const SizedBox(height: 8), 

  

              _field(ctrl: _nameCtrl, label: 'Full Name', icon: Icons.person), 

              _field(ctrl: _rollCtrl, label: 'Roll Number', icon: Icons.tag), 

              _field(ctrl: _deptCtrl, label: 'Department', icon: Icons.school), 

  

              // Semester: must be a number 1-8 

              _field( 

                ctrl: _semCtrl, 

                label: 'Semester (1-8)', 

                icon: Icons.calendar_today, 

                type: TextInputType.number, 

                validator: (v) { 

                  if (v == null || v.trim().isEmpty) return 'Required'; 

                  final n = int.tryParse(v.trim()); 

                  if (n == null || n < 1 || n > 8) return 'Enter 1 to 8'; 

                  return null; 

                }, 

              ), 

  

              // CGPA: must be 0.0 to 10.0 

              _field( 

                ctrl: _cgpaCtrl, 

                label: 'CGPA (0.0 - 10.0)', 

                icon: Icons.star, 

                type: const TextInputType.numberWithOptions(decimal: true), 

                validator: (v) { 

                  if (v == null || v.trim().isEmpty) return 'Required'; 

                  final n = double.tryParse(v.trim()); 

                  if (n == null || n < 0 || n > 10) return 'Enter 0.0 to 10.0'; 

                  return null; 

                }, 

              ), 

  

              // Phone: exactly 10 digits 

              _field( 

                ctrl: _phoneCtrl, 

                label: 'Phone Number', 

                icon: Icons.phone, 

                type: TextInputType.phone, 

                validator: (v) { 

                  if (v == null || v.trim().isEmpty) return 'Required'; 

                  if (v.trim().length != 10) return '10-digit number required'; 

                  return null; 

                }, 

              ), 

  

              // Email: must contain @ and . 

              _field( 

                ctrl: _emailCtrl, 

                label: 'Email Address', 

                icon: Icons.email, 

                type: TextInputType.emailAddress, 

                validator: (v) { 

                  if (v == null || v.trim().isEmpty) return 'Required'; 

                  if (!v.contains('@') || !v.contains('.')) { 

                    return 'Enter a valid email'; 

                  } 

                  return null; 

                }, 

              ), 

  

              const SizedBox(height: 24), 

  

              // Submit Button 

              SizedBox( 

                width: double.infinity, 

                height: 52, 

                child: ElevatedButton( 

                  onPressed: _isLoading ? null : _submit, 

                  style: ElevatedButton.styleFrom( 

                    backgroundColor: const Color(0xFFF5C518), 

                    foregroundColor: Colors.black, 

                    shape: RoundedRectangleBorder( 

                      borderRadius: BorderRadius.circular(12)), 

                  ), 

                  child: _isLoading 

                      ? const CircularProgressIndicator(color: Colors.black) 

                      : Text( 

                          isEditing ? 'Update Student' : 'Add Student', 

                          style: const TextStyle( 

                            fontSize: 16, fontWeight: FontWeight.bold), 

                        ), 

                ), 

              ), 

              const SizedBox(height: 16), 

            ], 

          ), 

        ), 

      ), 

    ); 

  } 

} 

 