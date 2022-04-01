// ignore_for_file: avoid_print

import 'package:admin_panel/common/token.dart';
import 'package:admin_panel/contants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Service {
  int serviceId = 0;
  String serviceName = "";
  String serviceDescription = "";

  Service(Map<String, dynamic> map) {
    serviceId = map['service_id'];
    serviceName = map['service_name'];
    serviceDescription = map['service_description'];
  }
}

Future<List<Service>> getServices() async {
  String? token = await getToken();

  Map<String, String> headers = {
    "Content-type": "application/json",
    'Authorization': 'Bearer $token',
  };

  var url = Uri.http(domain + portNumber2, "/getServices");
  var response = await http.get(url, headers: headers);

  List<dynamic> decoded = jsonDecode(response.body);
  List<Service> data = [];

  for (var i = 0; i < decoded.length; i++) {
    Map<String, dynamic> map = decoded[i];

    Service service = Service(map);

    data.add(service);
  }
  return data;
}

Future<void> addService(String name, String description) async {
  String? token = await getToken();

  var url = Uri.http(domain + portNumber, "/addService");
  Map<String, String> payload = {
    "service_name": name,
    "service_description": description
  };
  Map<String, String> headers = {
    "Content-type": "application/json",
    'Authorization': 'Bearer $token',
  };

  await http.post(url, headers: headers, body: jsonEncode(payload));
}
