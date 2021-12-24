import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class API {
  static String baseUrl1 =
      'https://wax.api.atomicassets.io/atomicassets/v1/assets/';
  static String baseUrl2 =
      'https://api.wax.alohaeos.com/v1/chain/get_table_rows';
  static String baseUrl3 =
      'https://wax.eu.eosamsterdam.net/v1/chain/get_table_rows';
  static String baseUrl4 = 'https://wax.eoseoul.io/v1/chain/get_table_rows';
  static String baseUrl5 = "https://wax.eosphere.io/v1/chain/get_table_rows";

  static get(path) async {
    print("cal get to xxxxx");
    try {
      final response = await http.get(Uri.parse(path));
      final data = utf8.decode(response.bodyBytes);
      final res = jsonDecode(data);
      return res;
    } catch (e) {
      print(e);
    }
  }

  static post(payload) async {
    print("post get to xxxxx");
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(baseUrl5));
      request.body = json.encode(payload);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      final res = await response.stream.bytesToString();
      final data = jsonDecode(res);
      // print('===== data form post ======');
      // print(data['rows'].length);
      // print('===========================');
      return data;
    } catch (err) {
      print(err);
      return false;
    }
  }

  static post1(payload) async {
    print("post get to xxxxx");
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse("https://wax.pink.gg/v1/chain/get_account"));
      request.body = json.encode(payload);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      final res = await response.stream.bytesToString();
      final data = jsonDecode(res);
      // print('===== data form post ======');
      // print(data['rows'].length);
      // print('===========================');
      return data;
    } catch (err) {
      print(err);
      return false;
    }
  }

  static post2(payload) async {
    print("post get to xxxxx");
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse("https://wax.pink.gg/v1/chain/get_account"));
      request.body = json.encode(payload);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      final res = await response.stream.bytesToString();
      final data = jsonDecode(res);
      // print('===== data form post ======');
      // print(data['rows'].length);
      // print('===========================');
      return data;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
