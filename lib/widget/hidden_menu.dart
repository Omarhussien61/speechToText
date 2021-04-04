import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/main.dart';
import 'package:flutter_pos/utils/Provider/provider.dart';
import 'package:flutter_pos/utils/local/LanguageTranslated.dart';
import 'package:flutter_pos/utils/screen_size.dart';
import 'package:flutter_pos/widget/item_hidden_menu.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class HiddenMenu extends StatefulWidget {
  @override
  _HiddenMenuState createState() => _HiddenMenuState();
}

class _HiddenMenuState extends State<HiddenMenu> {
  bool isconfiguredListern = false;
  String am_pm;

  @override
  void initState() {
    am_pm = new DateFormat('a').format(new DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);
    return Drawer(
      child: Container(
        color: Colors.blueAccent,
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              SizedBox(
                height: ScreenUtil.getHeight(context)/10,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ListTile(
                  title: Column (
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeText(
                        //  getTransrlate(context, 'welcome'),
                        am_pm == 'am'
                            ? getTransrlate(context, 'good_morning')
                            : getTransrlate(context, 'good_night'),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (scroll) {
                    scroll.disallowGlow();
                    return false;
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 28,
                          margin: EdgeInsets.only(left: 24, right: 48),
                          child: Divider(
                            color: Colors.white.withOpacity(0.5),
                          )),
                      Container(
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (scroll) {
                            scroll.disallowGlow();
                            return false;
                          },
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0.0),
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  await themeColor.local == 'ar'
                                      ? themeColor.setLocal('en')
                                      : themeColor.setLocal('ar');
                                  MyApp.setlocal(context,
                                      Locale(themeColor.getlocal(), ''));
                                  SharedPreferences.getInstance()
                                      .then((prefs) {
                                    prefs.setString(
                                        'local', themeColor.local);
                                  });
                                },
                                child: ItemHiddenMenu(
                                  icon: Icon(
                                    Icons.language,
                                    size: 25,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  name: Provider.of<Provider_control>(context)
                                              .local ==
                                          'ar'
                                      ? 'English'
                                      : 'عربى',
                                  baseStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.w800),
                                  colorLineSelected: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ])),
      ),
    );
  }
}
