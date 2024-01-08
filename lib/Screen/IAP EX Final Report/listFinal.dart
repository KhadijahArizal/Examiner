// ignore_for_file: camel_case_types, avoid_print, file_names

import 'package:examiner/Screen/IAP%20EX%20Student/studentDetails.dart';
import 'package:examiner/Screen/common/models.dart';
import 'package:examiner/Screen/sideNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class listOfStudentFinal extends StatefulWidget {
  const listOfStudentFinal({Key? key}) : super(key: key);

  @override
  State<listOfStudentFinal> createState() => _listOfStudentFinalState();
}

class _listOfStudentFinalState extends State<listOfStudentFinal> {
  User? user = FirebaseAuth.instance.currentUser;
  late DatabaseReference _examinerRef;
  late DatabaseReference _iapFormRef;
  late DatabaseReference _monthlyReport;
  late DatabaseReference _finalReport;
  late List<UserDataC> userData = [];
  List<MonthlyReportC> monthlyReports = [];
  List<UserDataC> originalUserData = [];

  @override
  void initState() {
    super.initState();
    _examinerRef =
        FirebaseDatabase.instance.ref('Student').child('Assign Examiner');
    _iapFormRef =
        FirebaseDatabase.instance.ref().child('Student').child('IAP Form');
    _monthlyReport = FirebaseDatabase.instance
        .ref()
        .child('Student')
        .child('Monthly Report');
    _finalReport =
        FirebaseDatabase.instance.ref().child('Student').child('Final Report');
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      String examinerEmail = '${user?.email}';
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);
      DataSnapshot monthlyReportSnapshot =
          await _monthlyReport.once().then((event) => event.snapshot);
      DataSnapshot exReportSnapshot =
          await _examinerRef.once().then((event) => event.snapshot);
      DataSnapshot finalReportSnapshot =
          await _finalReport.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? monthlyReportData =
          monthlyReportSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? finalReportData =
          finalReportSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? exReportData =
          exReportSnapshot.value as Map<dynamic, dynamic>?;

      if (iapData != null &&
          monthlyReportData != null && 
          exReportData != null &&
          finalReportData != null) {
        exReportData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              finalReportData.containsKey(key) &&
              monthlyReportData.containsKey(key) &&
              iapData.containsKey(key)) {

            String matric = iapData[key]['Matric'] ?? '';
            String name = iapData[key]['Name'] ?? '';
            String studentID = iapData[key]['Student ID'] ?? '';
            String exemail = exReportData[key]['ExaminerEmail'] ?? '';

            //monthly
            List<MonthlyReportC> monthlyReports = [];
            if (monthlyReportData[key]['Reports'] is Map) {
              monthlyReportData[key]['Reports']
                  .forEach((reportKey, reportValue) {
                MonthlyReportC monthlyReport = MonthlyReportC(
                  month: reportValue['Month'] ?? '',
                  monthlyRname: reportValue['Name'] ?? '',
                  status: reportValue['Status'] ?? '',
                  date: reportValue['Submission Date'] ?? '',
                  monthlyFile: reportValue['File'] ?? '',
                );
                monthlyReports.add(monthlyReport);
              });
            }

           if (monthlyReports.length == 6) {
          //finalReport
          String date = finalReportData[key]['Date'] ?? '';
          String file = finalReportData[key]['File'] ?? '';
          String fileName = finalReportData[key]['File Name'] ?? '';
          String title = finalReportData[key]['Report Title'] ?? '';
          String status = finalReportData[key]['Status'] ?? '';
          String StatusEX = finalReportData[key]['StatusEX'] ?? '';

          if (exemail == examinerEmail &&
              date.isNotEmpty &&
              file.isNotEmpty &&
              fileName.isNotEmpty &&
              title.isNotEmpty) {
            UserDataC user = UserDataC(
              studentID: studentID,
              matric: matric,
              name: name,
              exemail: exemail,
              monthlyReports: monthlyReports,
              finalReport: FinalReportC(
                date: date,
                file: file,
                fileName: fileName,
                title: title,
                status: status, 
                statusEX: StatusEX,
              ),
            );

            userData.add(user);
            originalUserData.add(user);
          }
        }

            print('userData: $userData');
          }
        });
      }

      setState(() {});
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  List<UserDataC> _filterUserData(String searchValue) {
    return userData
        .where((user) => user.finalReport.statusEX
            .toLowerCase()
            .contains(searchValue.toLowerCase()))
        .toList();
  }

  Widget _name({required String name}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'Futura',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _matricNo({required String matricNo}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            matricNo,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontFamily: 'Futura',
            ),
          )
        ],
      );

  Widget _status({required String status}) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            status,
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Futura',
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Final Report Status',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura'),
        ),
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
      drawer: const sideNav(),
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
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            // If the search value is empty, reset to the original data
                            userData = originalUserData;
                          } else {
                            // Otherwise, filter the data based on the search value
                            userData = _filterUserData(value);

                            // Check if there are no students matching the search
                            if (userData.isEmpty) {
                              userData.add(UserDataC(
                                // You can customize this message or leave fields empty as needed
                                name: 'No student found',
                                matric: '',
                                studentID: '',
                                exemail: '',
                                monthlyReports: [],
                                finalReport: FinalReportC(
                                  date: '',
                                  file: '',
                                  fileName: '',
                                  title: '',
                                  status: '',
                                  statusEX: ''
                                ),
                              ));
                            }
                          }
                        });
                      },
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Search: Pending/ Approved/ Rejected",
                        prefixIcon: const Icon(Icons.search_rounded),
                        prefixIconColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: userData.isNotEmpty
                          ? ListView.separated(
                              itemCount: userData.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => S_Details(
                                        studentID: userData[index].studentID,
                                        name: userData[index].name,
                                        matric: userData[index].matric,
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(1),
                                  title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: _name(
                                                name: userData[index].name)),
                                        Expanded(
                                          child: _status(
                                              status: userData[index]
                                                  .finalReport
                                                  .status),
                                        )
                                      ]),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 3),
                                      _matricNo(
                                          matricNo: userData[index].matric),
                                    ],
                                  ),
                                ),
                              ),
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.black26,
                              ),
                            )
                          : const Text(
                              'No results found.',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ],
                ))),
      ),
    );
  }
}