class Student {
  final String name;
  final String rollNumber;
  final String department;
  final int semester;
  final double cgpa;
  final String phoneNumber;
  final String email;

  Student({
    required this.name,
    required this.rollNumber,
    required this.department,
    required this.semester,
    required this.cgpa,
    required this.phoneNumber,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rollNumber': rollNumber,
      'department': department,
      'semester': semester,
      'cgpa': cgpa,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'] ?? '',
      rollNumber: map['rollNumber'] ?? '',
      department: map['department'] ?? '',
      semester: (map['semester'] ?? 0) as int,
      cgpa: (map['cgpa'] ?? 0.0) as double,
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Student copyWith({
    String? name,
    String? rollNumber,
    String? department,
    int? semester,
    double? cgpa,
    String? phoneNumber,
    String? email,
  }) {
    return Student(
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      cgpa: cgpa ?? this.cgpa,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }
}
