import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_detail_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Student Record',
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() => _searchQuery = val.trim().toLowerCase());
                },
                decoration: InputDecoration(
                  hintText: 'Search by name or roll no',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Table Header
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D4FBE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Roll No',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Student List (Live Stream from Firestore)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('students')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF5D4FBE),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No student records found.\nAdd one from Dashboard.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    // Filter based on search
                    final docs = snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final name =
                          (data['name'] ?? '').toString().toLowerCase();
                      final roll =
                          (data['rollNumber'] ?? '').toString().toLowerCase();
                      return name.contains(_searchQuery) ||
                          roll.contains(_searchQuery);
                    }).toList();

                    if (docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No matching student found.',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: Colors.black26),
                      itemBuilder: (context, index) {
                        final data =
                            docs[index].data() as Map<String, dynamic>;
                        final docId = docs[index].id;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StudentDetailScreen(
                                  docId: docId,
                                  data: data,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    data['name'] ?? '-',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    data['rollNumber'] ?? '-',
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(fontSize: 16),
                                  ),
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
        ),
      ),
    );
  }
}