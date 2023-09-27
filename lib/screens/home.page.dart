import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_whm_2/screens/Members/attendanceBisBis.dart';
import 'package:mobile_whm_2/screens/Leaman/attendanceBisBis2.dart';
import 'package:mobile_whm_2/widgets/default.colors.dart';
import 'package:mobile_whm_2/widgets/mydrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool ligth = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Defaults.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Defaults.appBarColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Column(
              children: [
                SizedBox(height: 60),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    'Welcome to',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Defaults.white),
                  ),
                  subtitle: Text('VHM Mobile App',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey)),
                  trailing: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/logo_vhm_blanc.png'),
                  ),
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Defaults.appBarColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard(
                    'Pointage',
                    CupertinoIcons.pencil,
                    Defaults.greenMenuColor,
                    () {
                      // Navigation vers la page de face
                      Navigator.pushNamed(context, '/attendanceBisBis');
                    },
                  ),
                  itemDashboard(
                    'Leaman',
                    CupertinoIcons.person_2_alt,
                    Defaults.leamanPrincipal,
                    () {
                      // Navigation vers la page de face
                      // Navigator.pushNamed(context, '/listMembers');
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  itemDashboard(
    String title,
    IconData iconData,
    Color background,
    Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: Colors.white,
                size: 36, // Ajustez la taille ici selon vos besoins
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
