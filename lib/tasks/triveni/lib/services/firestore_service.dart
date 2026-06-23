import 'package:cloud_firestore/cloud_firestore.dart'; 

import '../models/student.dart'; 

  

class FirestoreService { 

  // FirebaseFirestore.instance gives access to the database 

  final FirebaseFirestore _db = FirebaseFirestore.instance; 

  

  // The Firestore 'collection' is like a table in SQL databases 

  final String _collection = 'students'; 

  

  // ═══════════ CREATE ═══════════ 

  // add() creates a new document with an auto-generated ID 

  Future<void> addStudent(Student student) async { 

    await _db.collection(_collection).add(student.toMap()); 

  } 

  

  // ═══════════ READ ═══════════ 

  // Returns a Stream — like a live pipe from Firestore. 

  // Every time data changes in Firestore, the Stream emits new data. 

  // StreamBuilder in the UI listens to this Stream and rebuilds automatically. 

  Stream<List<Student>> getStudents() { 

    return _db 

        .collection(_collection) 

        .orderBy('name')   // Sort alphabetically 

        .snapshots()        // Real-time listener 

        .map((snapshot) {   // Transform snapshot → List<Student> 

          return snapshot.docs 

              .map((doc) => Student.fromMap(doc.data(), doc.id)) 

              .toList(); 

        }); 

  } 

  

  // ═══════════ UPDATE ═══════════ 

  // doc(id) finds the specific document; update() changes only listed fields 

  Future<void> updateStudent(Student student) async { 

    await _db 

        .collection(_collection) 

        .doc(student.id)        // Target specific document by ID 

        .update(student.toMap()); 

  } 

  

  // ═══════════ DELETE ═══════════ 

  Future<void> deleteStudent(String id) async { 

    await _db.collection(_collection).doc(id).delete(); 

  } 

} 