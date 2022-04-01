import 'package:admin_panel/common/token.dart';
import 'package:admin_panel/contants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Place {
  int placeId = 0;
  int hostId = 0;
  String name = "";
  String type = "";
  int price = 0;
  String address = "";
  String city = "";
  String state = "";
  String pincode = "";
  int maxGuest = 0;
  int bedCount = 0;
  int bedroomCount = 0;
  int bathroomCount = 0;
  String startingDate = "";
  String lastDate = "";
  String description = "";
  String averageStars = "";
  String isListed = "";
  int imageCount = 0;

  Place(Map<String, dynamic> map) {
    placeId = map['place_id'];
    hostId = map['host_id'];
    name = map['name'];
    type = map['type'];
    price = map['price'];
    address = map['address'];
    city = map['city'];
    state = map['state'];
    pincode = map['pincode'];
    maxGuest = map['max_guest'];
    bedCount = map['bed_count'];
    bedroomCount = map['bedroom_count'];
    bathroomCount = map['bathroom_count'];
    startingDate = map['starting_date'];
    lastDate = map['last_date'];
    description = map['description'];
    averageStars = map['average_star'].toString();
    imageCount = map['image_count'];
    isListed = map['is_listed'];
  }
}

Future<List<Place>> getPlaces() async {
  String? token = await getToken();

  var url = Uri.http(domain + portNumber2, "/getAllPlaces");
  Map<String, String> header = {
    "Content-type": "application/json",
    'Authorization': 'Bearer $token',
  };
  var response = await http.get(url, headers: header);
  List<dynamic> decoded = convert.jsonDecode(response.body);
  List<Place> data = [];
  for (var i = 0; i < decoded.length; i++) {
    Map<String, dynamic> map = decoded[i];
    Place property = Place(map);
    data.add(property);
  }
  return data;
}

//changeIsListed
Future<void> changeIsListed(String placeId, String status) async {
  String? token = await getToken();

  var url = Uri.http(domain + portNumber2, "/changeIsListed");
  Map<String, String> payload = {
    "place_id": placeId,
    "status": status,
  };
  Map<String, String> header = {
    "Content-type": "application/json",
    'Authorization': 'Bearer $token',
  };

  var response =
      await http.post(url, headers: header, body: convert.jsonEncode(payload));

  print(response.statusCode);
}
