import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kula_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail() async {
    try{
      final headers = {'Content-Type': 'application/json'};
      final url = Uri.parse(ApiEndPoints.baseUrl!+ApiEndPoints.authEndpoints.registerMail);
      final Map body = {
        'name': nameController.text,
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        var token = json['data']['Token'];
        final SharedPreferences prefs = await _prefs;

        await prefs.setString('token', token);
        nameController.clear();
        emailController.clear();
        passwordController.clear();
      }
      else{
        throw jsonDecode(response.body)['Message'] ?? 'Wystąpił nieznany błąd';
      }
    } catch (e) {
      Get.back();
      await showDialog(
          context: Get.context!,
          builder: (context){
            return SimpleDialog(
              title: const Text('error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          }
      );
    }
  }
}
