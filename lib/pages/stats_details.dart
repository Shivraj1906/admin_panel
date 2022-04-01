// ignore_for_file: prefer_const_constructors

import 'package:admin_panel/common/token.dart';
import 'package:admin_panel/contants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatsDetails extends StatefulWidget {
  final int hostId;

  const StatsDetails({Key? key, required this.hostId}) : super(key: key);

  @override
  State<StatsDetails> createState() => _StatsDetailsState();
}

class _StatsDetailsState extends State<StatsDetails> {
  Future<List<dynamic>> getPlaces() async {
    String? token = await getToken();

    var url = Uri.http(domain + portNumber, "/getPlaces",
        {"host_id": widget.hostId.toString()});
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(url, headers: headers);

    List<dynamic> decoded = jsonDecode(response.body);

    return decoded;
  }

  Future<List<dynamic>> getBookings() async {
    String? token = await getToken();

    var url = Uri.http(domain + portNumber, "/getBookingRequests",
        {"host_id": widget.hostId.toString()});
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(url, headers: headers);

    List<dynamic> decoded = jsonDecode(response.body);

    return decoded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Center(
          child: Card(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: FutureBuilder<List<dynamic>>(
            future: getPlaces(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return FutureBuilder<List<dynamic>>(
                future: getBookings(),
                builder: (context, innerSnapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Number of places: " +
                          snapshot.data!.length.toString()),
                      Text("Number of bookings: " +
                          innerSnapshot.data!.length.toString()),
                    ],
                  );
                },
              );
            },
          ),
        ),
      )),
    );
  }
}
