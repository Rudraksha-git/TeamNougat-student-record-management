import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController searchController =
      TextEditingController();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController rollController =
      TextEditingController();

  final TextEditingController branchController =
      TextEditingController();

  final TextEditingController cgpaController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF6FF),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [

                /// TOP BAR

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.menu),
                    ),

                    Row(
                      children: [

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none,
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.logout,
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.info_outline,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  "Welcome to",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                const Text(
                  "Student Management App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF071E63),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Simple. Fast. Efficient.",
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 25),

                /// PROFILE CARD

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC8F0F4),
                    borderRadius:
                        BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.cyan,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [

                      CircleAvatar(
                        radius: 45,
                        backgroundColor:
                            Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Hello, Khushi",
                              style: TextStyle(
                                fontSize: 28,
                              ),
                            ),

                            const Text(
                              "CSE - NIT Patna",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),

                            const SizedBox(height: 12),

                            OutlinedButton(
                              onPressed: () {},
                              child: const Text(
                                "Edit Profile",
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// SEARCH BAR

                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText:
                        "Search Students here...",
                    prefixIcon:
                        const Icon(Icons.search),
                    filled: true,
                    fillColor:
                        const Color(0xFFCAE8F7),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// STUDENT DETAILS CARD

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF89D7DE),
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [

                      buildField(
                        Icons.person_outline,
                        "Name",
                        nameController,
                      ),

                      buildField(
                        Icons.tag,
                        "Roll Number",
                        rollController,
                      ),

                      buildField(
                        Icons.school_outlined,
                        "Branch",
                        branchController,
                      ),

                      buildField(
                        Icons.star_border,
                        "CGPA",
                        cgpaController,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// BUTTONS

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    buildButton(
                      "Create",
                      Icons.add_circle_outline,
                      Colors.blue,
                    ),

                    buildButton(
                      "Refresh",
                      Icons.refresh,
                      Colors.orange,
                    ),

                    buildButton(
                      "Update",
                      Icons.update,
                      Colors.green,
                    ),

                    buildButton(
                      "Delete",
                      Icons.delete_outline,
                      Colors.red,
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Students",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  Widget buildField(
    IconData icon,
    String hint,
    TextEditingController controller,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),

          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }

  Widget buildButton(
    String text,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [

          Icon(
            icon,
            color: color,
          ),

          const SizedBox(height: 4),

          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}