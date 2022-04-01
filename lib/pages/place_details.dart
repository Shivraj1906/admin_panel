// ignore_for_file: prefer_const_constructors

import 'package:admin_panel/common/token.dart';
import 'package:admin_panel/contants.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceDetails extends StatefulWidget {
  final int placeId;
  const PlaceDetails({required this.placeId, Key? key}) : super(key: key);

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  Future<List<dynamic>> getBookings() async {
    String? token = await getToken();

    print(widget.placeId);

    var url = Uri.http(domain + portNumber, "/getPlaceBookingRequests",
        {"place_id": widget.placeId.toString()});
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
        title: Text("Place details"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getBookings(),
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
                title: Text(snapshot.data![index]["total_bill"].toString()),
              );
            },
          );
        },
      ),
    );
  }
}
