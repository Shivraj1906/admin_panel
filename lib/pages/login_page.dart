// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:admin_panel/common/token.dart';
import 'package:admin_panel/contants.dart';
import 'package:admin_panel/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  void tryLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var url = Uri.http(domain + portNumber, "/login");
      Map<String, String> payload = {"email": email, "password": password};
      Map<String, String> header = {
        "Content-type": "application/json",
      };
      var response =
          await http.post(url, headers: header, body: jsonEncode(payload));

      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email was not found, or password is wrong"),
          ),
        );
        return;
      }

      var decoded = await jsonDecode(response.body);
      saveToken(decoded['token']);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  void tryRegister() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var url = Uri.http(domain + portNumber, "/register");
      Map<String, String> payload = {"email": email, "password": password};
      Map<String, String> header = {
        "Content-type": "application/json",
        "Access-Control-Allow-Origin": "*"
      };
      var response =
          await http.post(url, headers: header, body: jsonEncode(payload));

      if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email is already in use"),
          ),
        );
        return;
      }

      var decoded = jsonDecode(response.body);
      saveToken(decoded['token']);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Form(
          key: _formKey,
          child: Center(
              child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.symmetric(horizontal: 500),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      email = newValue.toString();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter email!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      password = newValue.toString();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter password!";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    onPressed: tryLogin,
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: tryRegister,
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
