// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, library_private_types_in_public_api

import 'package:examiner/Screen/IAP%20EX%20Student/studentDetails.dart';
import 'package:examiner/Screen/firebase_data_fetch.dart';
import 'package:examiner/Screen/googleNavBar.dart';
import 'package:examiner/Screen/IAP%20EX%20Profile/profilePage.dart';
import 'package:examiner/Screen/auth_service.dart';
import 'package:examiner/Screen/pie_chart_generator.dart';
import 'package:examiner/Screen/sideNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class UserDataS {
  final String userId;
  final String company;

  UserDataS({
    required this.userId,
    required this.company,
  });
}


class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.title});
  final String title;
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentFinalIndex = 0;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;
  late DatabaseReference _totalStudentsRef;
    late DatabaseReference _finalReport;
  late DatabaseReference _monthlyReport;
  final FirebaseDataFetcher dataFetcher = FirebaseDataFetcher();
  final PieChartGenerator chartGenerator = PieChartGenerator();


  //Profile Page
  late DatabaseReference _studentRef;
  late Future<List<UserDataS>> _userDataFuture;


  @override
  void initState() {
    super.initState();
    if (user != null) {
      _studentRef =
          FirebaseDatabase.instance.ref('Student').child('Assign Examiner');
      _userDataFuture = _fetchUserData();
      _totalStudentsRef = FirebaseDatabase.instance
          .ref('Examiners')
          .child('Total Monthly Report')
          .child(userId);
      
    }
  }


  String generateSupervisorID(User user) {
    String supervisorID = 'EX${user.uid.substring(0, 4)}';

    return supervisorID;
  }

Future<List<FinalData1>> _fetchFinalData(String studentID) async {
  List<FinalData1> userDataList = [];
  try {
    DataSnapshot finalReportSnapshot =
        await _finalReport.once().then((event) => event.snapshot);

    Map<dynamic, dynamic>? finalReportData =
        finalReportSnapshot.value as Map<dynamic, dynamic>?;

    if (finalReportData != null) {
      finalReportData.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          String date = value['Date'] ?? '';
          String file = value['File'] ?? '';
          String fileName = value['File Name'] ?? '';
          String title = value['Report Title'] ?? '';
          String status = value['Status'] ?? '';
          String StatusEX = value['StatusEX'] ?? '';

          if (key == studentID && status == 'Approved') {
            FinalData1 userF = FinalData1(
              studentID: studentID,
              date: date,
              file: file,
              fileName: fileName,
              title: title,
              status: status,
              StatusEX: StatusEX,
            );

            userDataList.add(userF);
          }
        }
      });
    }
  } catch (e) {
    print('Error fetching data: $e');
  }

  return userDataList;
}



  Future<List<UserDataS>> _fetchUserData() async {
    List<UserDataS> userDataList = [];
    try {
      DataSnapshot studentSnapshot =
          await _studentRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? studentData =
          studentSnapshot.value as Map<dynamic, dynamic>?;

      if (studentData != null) {
        studentData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String company = value['Department'] ?? '';

            UserDataS user = UserDataS(
              userId: userId,
              company: company,
            );
            userDataList.add(user);
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
  }


  Widget _smallRect({
    required String profile,
    required VoidCallback profileTap,
  }) {
    return InkWell(
      onTap: profileTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(profile), // Use NetworkImage for URLs
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _name({required String name}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.black54, fontSize: 20),
            )
          ],
        ),
      );

  Widget _superviorContact(
          {required String supervisorID, required String email}) =>
      Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              supervisorID,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const VerticalDivider(
              color: Colors.white,
              width: 20,
            ),
            Text(
              email,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      );

  Widget _company({required String company, required IconData icon}) =>
      Container(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Text(
              company,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            )
          ],
        ),
      );

  void _handleForwardAction() {
    setState(() {
      if (currentFinalIndex < 1) {
        currentFinalIndex++;
      }
    });
  }

  int _currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex =
          index; // Update the current tab index when a tab is tapped
      if (index == 0) {
        Navigator.pushNamed(context, '/summary');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/student_list');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/announc');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    AuthService authService = AuthService();
    String supervisorID = generateSupervisorID(user!);
    // final Future<FirebaseApp> fApp = Firebase.initializeApp();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            'Examiner Dashboard',
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontFamily: 'Futura'),
            textAlign: TextAlign.right,
          )
        ]),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(0, 146, 143, 10),
          size: 30,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.sort,
                  color: Color.fromRGBO(0, 146, 143, 10), size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: sideNav(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: const AssetImage('assets/images/iiumlogo.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white30.withOpacity(0.2),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20), // Add space above the chart
              
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome!',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 40,
                                      //fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Futura'),
                                ),
                                const SizedBox(width: 5),
                                _name(name: '${user.displayName}'),
                                const SizedBox(height: 5),
                                FutureBuilder<List<UserDataS>>(
                                  future: _userDataFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else {
                                      var user =
                                          snapshot.data?.isNotEmpty == true
                                              ? snapshot.data![0]
                                              : null;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _company(
                                              company: user?.company ?? '',
                                              icon: Icons.business),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ]),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _smallRect(
                                profile:
                                    authService.currentUser?.photoURL ?? '',
                                profileTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfilePage()));
                                },
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            boxShadow: const [
                              BoxShadow(color: Color.fromRGBO(0, 146, 143, 10)),
                            ],
                            border: Border.all(
                              color: const Color.fromRGBO(0, 146, 143, 10),
                              width: 7,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _superviorContact(
                                email: '${user.email}',
                                supervisorID: supervisorID,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                       /* Container(
      height: 100, // Set a specific height for visibility
      width: double.infinity, // Match parent width
      color: Colors.black,
      child: const Center(
        child: Text(
          'Black Container',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),*/
    const SizedBox(height: 20),
    Container(
                 child: _buildChartSection(
                              'Student Status',
                              dataFetcher.fetchStatusCounts(),
                            ),
              ),
              const SizedBox(height: 20),
    Container(
                 child: _buildChartSection2(
                              'Final Report Status',
                              dataFetcher.fetchStatusCounts2(),
                            ),
              ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GNavbar(
        currentIndex: _currentIndex,
        onTabChange: onTabTapped,
      ),
    );
  }


    Widget _buildChartSection(String title, Future<Map<String, int>> chartData) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          child: FutureBuilder<Map<String, int>>(
            future: chartData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(
                  child: chartGenerator.generatePieChart(snapshot.data ?? {}),
                );
              }
            },
          ),
        ),
      ],
    );
  }


  Widget _buildChartSection2(String title, Future<Map<String, int>> chartData) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          child: FutureBuilder<Map<String, int>>(
            future: chartData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(
                  child: chartGenerator.generatePieChart2(snapshot.data ?? {}),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}