// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:admin_panel/common/token.dart';
import 'package:admin_panel/contants.dart';
import 'package:admin_panel/models/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageService extends StatefulWidget {
  const ManageService({Key? key}) : super(key: key);

  @override
  State<ManageService> createState() => _ManageServiceState();
}

class _ManageServiceState extends State<ManageService> {
  String newServiceName = "";
  String newSerivceDescription = "";

  final _formKey = GlobalKey<FormState>();
  final _addFormKey = GlobalKey<FormState>();

  void updateService(int serviceId) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print(newServiceName);
      print(newSerivceDescription);

      String? token = await getToken();

      var url = Uri.http(domain + portNumber, "/editService");
      Map<String, String> payload = {
        "service_id": serviceId.toString(),
        "service_name": newServiceName,
        "service_description": newSerivceDescription
      };

      Map<String, String> headers = {
        "Content-type": "application/json",
        'Authorization': 'Bearer $token',
      };

      var response =
          await http.post(url, headers: headers, body: jsonEncode(payload));

      Navigator.of(context).pop();
    }
  }

  void tryAddService() async {
    if (_addFormKey.currentState!.validate()) {
      _addFormKey.currentState!.save();

      await addService(newServiceName, newSerivceDescription);

      Navigator.of(context).pop();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage services"),
      ),
      body: FutureBuilder<List<Service>>(
        future: getServices(),
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
                title: Text(snapshot.data![index].serviceName),
                subtitle: Text(snapshot.data![index].serviceDescription),
                trailing: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 500),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                TextFormField(
                                  initialValue:
                                      snapshot.data![index].serviceName,
                                  decoration:
                                      InputDecoration(hintText: "Service name"),
                                  onSaved: (newValue) {
                                    newServiceName = newValue.toString();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter value";
                                    }

                                    return null;
                                  },
                                ),
                                TextFormField(
                                  initialValue:
                                      snapshot.data![index].serviceDescription,
                                  decoration: InputDecoration(
                                      hintText: "Service description"),
                                  onSaved: (newValue) {
                                    newSerivceDescription = newValue.toString();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter value";
                                    }

                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    updateService(
                                        snapshot.data![index].serviceId);

                                    setState(() {});
                                  },
                                  child: Text("Update"),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.more_vert),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 500),
                child: Form(
                  key: _addFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Service name"),
                        onSaved: (newValue) {
                          newServiceName = newValue.toString();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter value";
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(hintText: "Service description"),
                        onSaved: (newValue) {
                          newSerivceDescription = newValue.toString();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter value";
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: tryAddService,
                        child: Text("Add"),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
