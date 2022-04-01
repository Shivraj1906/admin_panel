// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:admin_panel/models/place.dart';
import 'package:flutter/material.dart';

class ManagePlace extends StatefulWidget {
  const ManagePlace({Key? key}) : super(key: key);

  @override
  State<ManagePlace> createState() => _ManagePlaceState();
}

class _ManagePlaceState extends State<ManagePlace> {
  void changePlaceStatus(String placeId, String newStatus) async {
    print("Foo");
    print(newStatus);
    await changeIsListed(placeId, newStatus);

    Navigator.of(context).pop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage place"),
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
                leading: CircleAvatar(
                  backgroundColor: snapshot.data![index].isListed == "1"
                      ? Colors.green
                      : Colors.red,
                ),
                title: Text(snapshot.data![index].name),
                subtitle: Text(snapshot.data![index].description),
                trailing: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ListTile(
                          title: Text(snapshot.data![index].isListed == "1"
                              ? "Disable place"
                              : "Enable place"),
                          onTap: () => changePlaceStatus(
                              snapshot.data![index].placeId.toString(),
                              snapshot.data![index].isListed == "1"
                                  ? "0"
                                  : "1"),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.more_vert_outlined),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
