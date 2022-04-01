// ignore_for_file: prefer_const_constructors

import 'package:admin_panel/common/token.dart';
import 'package:admin_panel/contants.dart';
import 'package:admin_panel/pages/stats_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserStats extends StatefulWidget {
  const UserStats({Key? key}) : super(key: key);

  @override
  State<UserStats> createState() => _UserStatsState();
}

class _UserStatsState extends State<UserStats> {
  Future<List<dynamic>> getHosts() async {
    String? token = await getToken();

    var url = Uri.http(domain + portNumber, "/getHosts");

    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(url, headers: headers);

    List<dynamic> decoded = jsonDecode(response.body);

    print(decoded);
    return decoded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Host stats"),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: getHosts(),
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
                  title: Text(
                    snapshot.data![index]['first_name'] +
                        " " +
                        snapshot.data![index]['last_name'],
                  ),
                  subtitle: Text(snapshot.data![index]["email"]),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StatsDetails(
                            hostId: snapshot.data![index]["user_id"]),
                      ),
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
