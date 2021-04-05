import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/screens/Maintenance.dart';
import 'package:flutter_pos/utils/Provider/provider.dart';
import 'package:flutter_pos/utils/navigator.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class API {
  BuildContext context;

  API(this.context) {
  }

  get(String url) async {
    final String full_url =
        'http://3.215.29.146/api/analyze/?sentence=%7B$url%7D&locale=ar-eg&debug=true';
    try {
      http.Response response = await http.get(full_url, headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      'Authorization': 'Token afdd74768a63495d54839847ffd85685c5c72d3b',
      });
      if(response.statusCode==200)
       {
         return json.decode(utf8.decode(response.bodyBytes));
       }

    } catch (e) {
      print(e);
      return e;
    } finally {}
  }
}
