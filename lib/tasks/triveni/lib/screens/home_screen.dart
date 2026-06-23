import 'package:flutter/material.dart'; 

import '../models/student.dart'; 
import '../services/firestore_service.dart'; 

import 'add_edit_student_screen.dart'; 

  

class HomeScreen extends StatefulWidget { 

  const HomeScreen({super.key}); 

  @override 

  State<HomeScreen> createState() => _HomeScreenState(); 

} 

  

class _HomeScreenState extends State<HomeScreen> { 

  // Create one FirestoreService instance to use throughout this screen 

  final FirestoreService _service = FirestoreService(); 

  final TextEditingController _searchController = TextEditingController(); 

  String _searchQuery = ''; 

  

  @override 

  void dispose() { 

    _searchController.dispose(); // Free memory when screen closes 

    super.dispose(); 

  } 

  

  // Navigate to AddEditStudentScreen 

  // If student is null → Add mode 

  // If student is provided → Edit mode (pre-fills the form) 

  void _goToAddEdit({Student? student}) { 

    Navigator.push( 

      context, 

      MaterialPageRoute( 

        builder: (_) => AddEditStudentScreen(student: student), 

      ), 

    ); 

  } 

  

  // Calls the service to delete, then shows a confirmation snackbar 

  Future<void> _deleteStudent(String id) async { 

    await _service.deleteStudent(id); 

    if (mounted) {  // 'mounted' check: make sure widget still exists 

      ScaffoldMessenger.of(context).showSnackBar( 

        const SnackBar( 

          content: Text('Student deleted'), 

          backgroundColor: Colors.red, 

        ), 

      ); 

    } 

  } 

  

  // Shows a confirmation dialog before actually deleting 

  void _showDeleteDialog(Student student) { 

    showDialog( 

      context: context, 

      builder: (ctx) => AlertDialog( 

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 

        title: const Row( 

          children: [ 

            Icon(Icons.warning_amber_rounded, color: Colors.red), 

            SizedBox(width: 8), 

            Text('Delete Student'), 

          ], 

        ), 

        content: Text( 

          'Are you sure you want to delete ${student.name}?\n' 

          'This action cannot be undone.', 

        ), 

        actions: [ 

          // Cancel: just close the dialog 

          TextButton( 

            onPressed: () => Navigator.pop(ctx), 

            child: const Text('Cancel'), 

          ), 

          // Delete: close dialog first, then delete 

          ElevatedButton( 

            style: ElevatedButton.styleFrom( 

              backgroundColor: Colors.red, 

              foregroundColor: Colors.white, 

              shape: RoundedRectangleBorder( 

                borderRadius: BorderRadius.circular(8)), 

            ), 

            onPressed: () { 

              Navigator.pop(ctx);          // Close dialog 

              _deleteStudent(student.id!); // Then delete 

            }, 

            child: const Text('Delete'), 

          ), 

        ], 

      ), 

    ); 

  } 

  

  @override 

  Widget build(BuildContext context) { 

    return Scaffold( 

      appBar: AppBar( 

        title: const Text('Student App', 

            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)), 

      ), 

      body: Column( 

        children: [ 

  

          // ─── SEARCH BAR ─── 

          Padding( 

            padding: const EdgeInsets.all(12.0), 

            child: TextField( 

              controller: _searchController, 

              // setState() tells Flutter to rebuild the UI with new _searchQuery 

              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()), 

              decoration: InputDecoration( 

                hintText: 'Search by name or roll number...', 

                prefixIcon: const Icon(Icons.search), 

                border: OutlineInputBorder( 

                  borderRadius: BorderRadius.circular(30), 

                  borderSide: BorderSide.none, 

                ), 

                filled: true, 

                fillColor: Colors.grey.shade200, 

                suffixIcon: _searchQuery.isNotEmpty 

                    ? IconButton( 

                        icon: const Icon(Icons.clear), 

                        onPressed: () { 

                          _searchController.clear(); 

                          setState(() => _searchQuery = ''); 

                        }) 

                    : null, 

              ), 

            ), 

          ), 

  

          // ─── STUDENT LIST ─── 

          Expanded( 

            child: StreamBuilder<List<Student>>( 

              stream: _service.getStudents(), // Listen to live Firestore data 

              builder: (context, snapshot) { 

  

                // Show spinner while waiting for first data 

                if (snapshot.connectionState == ConnectionState.waiting) { 

                  return const Center(child: CircularProgressIndicator()); 

                } 

  

                // Show error message if something went wrong 

                if (snapshot.hasError) { 

                  return Center(child: Text('Error: ${snapshot.error}')); 

                } 

  

                final students = snapshot.data ?? []; 

  

                // Filter students by search query 

                final filtered = students.where((s) => 

                  s.name.toLowerCase().contains(_searchQuery) || 

                  s.rollNumber.toLowerCase().contains(_searchQuery) 

                ).toList(); 

  

                // Empty state (no students or no search match) 

                if (filtered.isEmpty) { 

                  return Center( 

                    child: Column( 

                      mainAxisAlignment: MainAxisAlignment.center, 

                      children: [ 

                        Icon(Icons.school, size: 80, color: Colors.grey.shade400), 

                        const SizedBox(height: 16), 

                        Text( 

                          _searchQuery.isEmpty ? 'No students yet' : 'No results found', 

                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600), 

                        ), 

                        if (_searchQuery.isEmpty) 

                          Text('Tap + to add your first student', 

                              style: TextStyle(color: Colors.grey.shade500)), 

                      ], 

                    ), 

                  ); 

                } 

  

                // Build the list of student cards 

                return ListView.builder( 

                  padding: const EdgeInsets.symmetric(horizontal: 12), 

                  itemCount: filtered.length, 

                  itemBuilder: (context, index) { 

                    final s = filtered[index]; 

                    return Card( 

                      margin: const EdgeInsets.symmetric(vertical: 6), 

                      elevation: 2, 

                      shape: RoundedRectangleBorder( 

                        borderRadius: BorderRadius.circular(12)), 

                      child: ListTile( 

                        contentPadding: const EdgeInsets.symmetric( 

                          horizontal: 16, vertical: 8), 

                        leading: CircleAvatar( 

                          backgroundColor: const Color(0xFFF5C518), 

                          child: Text( 

                            s.name.isNotEmpty ? s.name[0].toUpperCase() : '?', 

                            style: const TextStyle( 

                              color: Colors.black, fontWeight: FontWeight.bold), 

                          ), 

                        ), 

                        title: Text(s.name, 

                            style: const TextStyle(fontWeight: FontWeight.bold)), 

                        subtitle: Column( 

                          crossAxisAlignment: CrossAxisAlignment.start, 

                          children: [ 

                            Text('Roll No: ${s.rollNumber}'), 

                            Text('${s.department} | Sem ${s.semester} | CGPA: ${s.cgpa}', 

                                style: TextStyle(color: Colors.grey.shade600)), 

                          ], 

                        ), 

                        trailing: Row( 

                          mainAxisSize: MainAxisSize.min, 

                          children: [ 

                            IconButton( 

                              icon: const Icon(Icons.edit, color: Colors.blue), 

                              onPressed: () => _goToAddEdit(student: s), 

                            ), 

                            IconButton( 

                              icon: const Icon(Icons.delete, color: Colors.red), 

                              onPressed: () => _showDeleteDialog(s), 

                            ), 

                          ], 

                        ), 

                      ), 

                    ); 

                  }, 

                ); 

              }, 

            ), 

          ), 

        ], 

      ), 

  

      // ─── FAB — Opens Add Student screen ─── 

      floatingActionButton: FloatingActionButton.extended( 

        onPressed: () => _goToAddEdit(), 

        backgroundColor: const Color(0xFFF5C518), 

        icon: const Icon(Icons.add, color: Colors.black), 

        label: const Text('Add Student', 

            style: TextStyle(color: Colors.black)), 

      ), 

    ); 

  } 

} 