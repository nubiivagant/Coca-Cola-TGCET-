import 'package:flutter/material.dart';

class BloodBankDashboard extends StatelessWidget {
  const BloodBankDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bloodAvailability = [
      {'Blood Type': 'O+', 'Units Available': 10, 'Location': 'City Hospital'},
      {'Blood Type': 'A+', 'Units Available': 5, 'Location': 'Health Center'},
      {'Blood Type': 'B+', 'Units Available': 7, 'Location': 'Red Cross Center'},
      {'Blood Type': 'AB+', 'Units Available': 2, 'Location': 'General Clinic'},
      {'Blood Type': 'O-', 'Units Available': 3, 'Location': 'City Hospital'},
      {'Blood Type': 'A-', 'Units Available': 6, 'Location': 'Health Center'},
      {'Blood Type': 'B-', 'Units Available': 4, 'Location': 'Red Cross Center'},
      {'Blood Type': 'AB-', 'Units Available': 1, 'Location': 'General Clinic'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Bank Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header with summary
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Blood Types: ${bloodAvailability.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'Last Updated: Today',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Blood Availability Cards with units and progress bar
            Expanded(
              child: ListView.builder(
                itemCount: bloodAvailability.length,
                itemBuilder: (context, index) {
                  final bloodData = bloodAvailability[index];
                  final unitsAvailable = bloodData['Units Available'];
                  final color = unitsAvailable > 5 ? Colors.green : Colors.red;
                  final progress = unitsAvailable / 10; // Progress bar scale

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
                                'Blood Type: ${bloodData['Blood Type']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${bloodData['Units Available']} units',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Location: ${bloodData['Location']}',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          // Custom Progress Indicator for units
                          Stack(
                            children: [
                              Container(
                                height: 10,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Container(
                                height: 10,
                                width: MediaQuery.of(context).size.width * progress * 0.8,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Handle more details or alerts
                                },
                                icon: const Icon(Icons.info),
                                label: const Text('More Info'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton.icon(
                                onPressed: () {
                                  // Handle donation request alert
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Request Donation'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
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
          ],
        ),
      ),
    );
  }
}
