import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> users = [
      {'name': 'User A', 'bloodGroup': 'O+', 'age': '29', 'location': 'New York'},
      {'name': 'User B', 'bloodGroup': 'A+', 'age': '34', 'location': 'Los Angeles'},
      {'name': 'User C', 'bloodGroup': 'B+', 'age': '40', 'location': 'Chicago'},
      {'name': 'User D', 'bloodGroup': 'AB+', 'age': '27', 'location': 'Houston'},
      {'name': 'User E', 'bloodGroup': 'O-', 'age': '31', 'location': 'Philadelphia'},
      {'name': 'User F', 'bloodGroup': 'A-', 'age': '36', 'location': 'Phoenix'},
      {'name': 'User G', 'bloodGroup': 'B-', 'age': '43', 'location': 'San Diego'},
      {'name': 'User H', 'bloodGroup': 'AB-', 'age': '25', 'location': 'Dallas'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Profile Icon with initial
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        user['name']![0], // Display first letter as avatar text
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Blood Group: ${user['bloodGroup']}',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            'Age: ${user['age']}',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            'Location: ${user['location']}',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Action Buttons (Call and Message)
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.message),
                          label: const Text('Message'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
