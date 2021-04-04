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
        '${GlobalConfiguration().getString('api_base_url')}$url&locale=${Provider.of<Provider_control>(context).getlocal()}&debug=true';
    try {
      print(full_url);

      http.Response response = await http.get(full_url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      print(response.body);
      if (response.statusCode == 500) {
        Nav.route(
            context,
            Maintenance(
              erorr: response.body,
            ));
      } else if (response.statusCode == 404) {
        Nav.route(
            context,
            Maintenance(
              erorr: full_url + '\n' + response.body,
            ));
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
      Nav.route(context, Maintenance());
    } finally {}
  }
}
