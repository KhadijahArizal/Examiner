import 'package:flutter/material.dart';
import 'package:examiner/Screen/IAP%20EX%20Final%20Report/listFinal.dart';
import 'package:examiner/Screen/IAP%20EX%20Monthly%20Report/listMonthly.dart';
import 'package:examiner/Screen/dashboard.dart';
import 'package:examiner/Screen/start.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your App Title'),
      ),
      body: const Center(
        child: Text('Your main content here'),
      ),
      drawer: const sideNav(),
    );
  }
}

class sideNav extends StatelessWidget {
  const sideNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 146, 143, 10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/iium.png',
                  height: 50,
                  width: 50,
                ),
                const SizedBox(width: 10),
                const Text(
                  'i-KICT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Futura',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          buildMenuItem(
              text: 'Summary',
              icon: Icons.dashboard_rounded,
              onClicked: () => selectedItem(context, 0)),
          const SizedBox(height: 10),
          buildMenuItem(
              text: 'Student Monthly Report',
              icon: Icons.description_rounded,
              onClicked: () => selectedItem(context, 1)),
          const SizedBox(height: 10),
          buildMenuItem(
              text: 'Student Final Report',
              icon: Icons.insert_drive_file_rounded,
              onClicked: () => selectedItem(context, 2)),
          const SizedBox(height: 10),
          const Divider(thickness: 1),
          buildMenuItem(
            text: 'Logout',
            icon: Icons.exit_to_app_rounded,
            onClicked: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Start(),
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logout'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(
        icon,
        color: const Color.fromRGBO(0, 146, 143, 10),
      ),
      title: Text(
        text,
        style: const TextStyle(color: Colors.black87, fontFamily: 'Futura'),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Dashboard(title: ''),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const listOfStudentMonthly(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const listOfStudentFinal(),
        ));
        break;
    }
  }
}
