import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/main.dart';
import 'package:flutter_pos/utils/Provider/provider.dart';
import 'package:flutter_pos/utils/local/LanguageTranslated.dart';
import 'package:flutter_pos/utils/screen_size.dart';
import 'package:flutter_pos/utils/service/API.dart';
import 'package:flutter_pos/widget/coustme_dialog.dart';
import 'package:flutter_pos/widget/item_hidden_menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = false;
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text;

  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<Provider_control>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(getTransrlate(context, 'AppName')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await themeColor.local == 'ar'
                          ? themeColor.setLocal('en')
                          : themeColor.setLocal('ar');
                      MyApp.setlocal(
                          context, Locale(themeColor.getlocal(), ''));
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setString('local', themeColor.local);
                      });
                    },
                    child: ItemHiddenMenu(
                      icon: Icon(
                        Icons.language,
                        size: 25,
                        color: themeColor.getColor(),
                      ),
                      name: Provider.of<Provider_control>(context).local == 'ar'
                          ? 'English'
                          : 'عربى',
                      baseStyle: TextStyle(
                          fontSize: 19.0, fontWeight: FontWeight.w800),
                    ),
                  ),
                  AutoSizeText(
                    _text ?? getTransrlate(context, 'start_speaking'),
                    minFontSize: 18,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            _loading
                ? Container(
                    color: Colors.black38,
                    width: ScreenUtil.getWidth(context),
                    height: ScreenUtil.getHeight(context),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    _confidence = val.confidence;
                    setState(() {
                      _loading = true;
                    });
                    API(context).get(val.recognizedWords).then((value) {
                      setState(() {
                        _loading = false;
                        _isListening = false;
                      });
                      if(value!=null){
                      print(value);
                        showDialog(
                            context: context,
                            builder: (_) => RusultOverlay(
                              title: "${value['response']==null?' ':value['response']['text']}",
                              Content: "${value['item']==null?' ':value['item']['name_ar']}",
                            ));
                      }
                    });
                  }
                }),
            localeId: Provider.of<Provider_control>(context).local);
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
