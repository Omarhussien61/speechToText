import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/Provider/provider.dart';
import 'package:flutter_pos/utils/screen_size.dart';
import 'package:provider/provider.dart';

class RusultOverlay extends StatefulWidget {
  String title,Content;
  RusultOverlay({this.Content, this.title});
  @override
  State<StatefulWidget> createState() => RusultOverlayState();
}

class RusultOverlayState extends State<RusultOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  int index=1;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize:MainAxisSize.min ,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AutoSizeText(
                      " ${widget.title}",
                      maxLines: 2,
                      minFontSize: 10,
                      style: TextStyle(
                        color: themeColor.getColor(),
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        // color: themeColor.getColor()

                      )),
                  SizedBox(height: 20,),
                  Container(
                    width: ScreenUtil.getWidth(context)/1.5,
                    child: Center(
                      child: AutoSizeText(
                          " ${widget.Content}",
                          maxLines: 4,
                          minFontSize: 10,
                          style: TextStyle(
                            color: Color(0xffaaaaaa),
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                            // color: themeColor.getColor()

                          )),
                    ),
                  ),
                  SizedBox(height: 20,),
                  FlatButton(
                    color: Colors.red,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(10.0)),
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('إغلاق',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        // color: themeColor.getColor()

                      ),),
                    ),),
                  SizedBox(height: 10,),

                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}