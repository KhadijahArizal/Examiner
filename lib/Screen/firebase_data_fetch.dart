import 'package:firebase_database/firebase_database.dart';

class FirebaseDataFetcher {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<Map<String, int>> fetchStatusCounts() async {
    Map<String, int> statusCounts = {
      'Active': 0,
      'Inactive': 0,
      

      // Add more statuses if needed
    };

    try {
      DataSnapshot snapshot = await _databaseReference.child('Student').child('Company Details').once().then((event) => event.snapshot);
      
      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> students = snapshot.value as Map<dynamic, dynamic>;

        students.forEach((key, value) {
          if (value != null && value['Status'] != null) {
            String status = value['Status'];
            if (statusCounts.containsKey(status)) {
              statusCounts[status] = statusCounts[status]! + 1;
            } else {
              statusCounts[status] = 1;
            }
          }
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }

    return statusCounts;
  }


  Future<Map<String, int>> fetchStatusCounts2() async {
    Map<String, int> statusCounts = {
      'Pending': 0,
      'Approved': 0,
      'Rejected':0,
      

      // Add more statuses if needed
    };

    try {
      DataSnapshot snapshot = await _databaseReference.child('Student').child('Final Report').once().then((event) => event.snapshot);
      
      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> students = snapshot.value as Map<dynamic, dynamic>;

        students.forEach((key, value) {
          if (value != null && value['StatusEX'] != null) {
            String status = value['StatusEX'];
            if (statusCounts.containsKey(status)) {
              statusCounts[status] = statusCounts[status]! + 1;
            } else {
              statusCounts[status] = 1;
            }
          }
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }

    return statusCounts;
  }

}
