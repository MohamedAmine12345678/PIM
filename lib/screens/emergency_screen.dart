import 'package:flutter/material.dart';

class EmergencyScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _guides = [
    {
      'title': 'Nearest Hospital',
      'description': 'General Hospital - 5 km away',
      'icon': Icons.local_hospital,
    },
    {
      'title': 'Local Embassy',
      'description': 'U.S. Embassy - 8 km away',
      'icon': Icons.account_balance,
    },
    {
      'title': 'Police Station',
      'description': 'Central Police Station - 3 km away',
      'icon': Icons.local_police,
    },
    {
      'title': 'Fire Department',
      'description': 'City Fire Department - 4 km away',
      'icon': Icons.local_fire_department,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Assistance'),
        backgroundColor: Color(0xFF162447),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/globe.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.3)
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Placeholder for emergency call action
                  print('Emergency Call Button Pressed');
                },
                icon: Icon(Icons.phone_in_talk, size: 30),
                label: Text(
                  'Call Emergency Services',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: _guides.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.orangeAccent.withOpacity(0.8),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        leading: Icon(
                          _guides[index]['icon'],
                          size: 40,
                          color: Colors.white,
                        ),
                        title: Text(
                          _guides[index]['title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            _guides[index]['description'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        onTap: () {
                          // Placeholder for guide selection action
                          print('${_guides[index]['title']} selected');
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Placeholder for location sharing action
                  print('Share Location Button Pressed');
                },
                icon: Icon(Icons.share_location, size: 30),
                label: Text(
                  'Share Real-Time Location',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
