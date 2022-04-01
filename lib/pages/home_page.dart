// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:admin_panel/common/token.dart';
import 'package:admin_panel/models/place.dart';
import 'package:admin_panel/pages/login_page.dart';
import 'package:admin_panel/pages/manage_place.dart';
import 'package:admin_panel/pages/manage_service.dart';
import 'package:admin_panel/pages/place_details.dart';
import 'package:admin_panel/pages/user_stats.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logOut() async {
    await deleteToken();
    print("Foo");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void navigateToManageService() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ManageService(),
      ),
    );
  }

  void navigateToManagePlace() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ManagePlace(),
      ),
    );
  }

  void navigateToUserStats() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserStats(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      body: FutureBuilder<List<Place>>(
        future: getPlaces(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].name),
                subtitle: Text(snapshot.data![index].type),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PlaceDetails(placeId: snapshot.data![index].placeId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      drawer: buildDrawer(logOut, navigateToManageService,
          navigateToManagePlace, navigateToUserStats),
    );
  }
}

Widget buildDrawer(Function logOut, Function navigateToManageService,
    Function navigateToManagePlace, Function navigateToUserStats) {
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Manage services"),
          onTap: () => navigateToManageService(),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text("Manage places"),
          onTap: () => navigateToManagePlace(),
        ),
        ListTile(
          leading: Icon(Icons.assignment_ind_outlined),
          title: Text("Host statistics"),
          onTap: () => navigateToUserStats(),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Log-out"),
          onTap: () => logOut(),
        )
      ],
    ),
  );
}
