import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> matches = [
      {
        'id': '1',
        'donor': 'John Doe',
        'recipient': 'Jane Smith',
        'bloodGroup': 'O+',
        'timestamp': '2025-03-28 10:30 AM',
        'matchStatus': 'Approved',
      },
      {
        'id': '2',
        'donor': 'Alice Johnson',
        'recipient': 'Mark Evans',
        'bloodGroup': 'A+',
        'timestamp': '2025-03-27 3:45 PM',
        'matchStatus': 'Pending Approval',
      },
      {
        'id': '3',
        'donor': 'Michael Brown',
        'recipient': 'Laura Wilson',
        'bloodGroup': 'B+',
        'timestamp': '2025-03-26 2:15 PM',
        'matchStatus': 'Approved',
      },
      {
        'id': '4',
        'donor': 'Chris Martin',
        'recipient': 'Emily Davis',
        'bloodGroup': 'AB-',
        'timestamp': '2025-03-25 4:10 PM',
        'matchStatus': 'Rejected',
      },
      {
        'id': '5',
        'donor': 'Jessica Lee',
        'recipient': 'Daniel Harris',
        'bloodGroup': 'O-',
        'timestamp': '2025-03-24 11:30 AM',
        'matchStatus': 'Approved',
      },
      {
        'id': '6',
        'donor': 'David Thompson',
        'recipient': 'Sarah Lewis',
        'bloodGroup': 'A-',
        'timestamp': '2025-03-23 1:20 PM',
        'matchStatus': 'Pending Approval',
      },
      {
        'id': '7',
        'donor': 'Nancy Robinson',
        'recipient': 'Paul Walker',
        'bloodGroup': 'B-',
        'timestamp': '2025-03-22 3:00 PM',
        'matchStatus': 'Approved',
      },
      {
        'id': '8',
        'donor': 'Kevin Adams',
        'recipient': 'Sophia Moore',
        'bloodGroup': 'AB+',
        'timestamp': '2025-03-21 10:00 AM',
        'matchStatus': 'Rejected',
      },
      {
        'id': '9',
        'donor': 'Linda White',
        'recipient': 'James Hill',
        'bloodGroup': 'O+',
        'timestamp': '2025-03-20 12:45 PM',
        'matchStatus': 'Pending Approval',
      },
      {
        'id': '10',
        'donor': 'George Wright',
        'recipient': 'Emma King',
        'bloodGroup': 'A+',
        'timestamp': '2025-03-19 9:15 AM',
        'matchStatus': 'Approved',
      },
    ];


    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard - Matchmaking'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Match ID: ${match['id']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          match['matchStatus'],
                          style: TextStyle(
                            fontSize: 14,
                            color: match['matchStatus'] == 'Approved'
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Donor: ${match['donor']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Recipient: ${match['recipient']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Blood Group: ${match['bloodGroup']}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Matched on: ${match['timestamp']}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Handle view details action here
                          },
                          icon: const Icon(Icons.details),
                          label: const Text('View Details'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            // Handle approve action here
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Approve'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
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
