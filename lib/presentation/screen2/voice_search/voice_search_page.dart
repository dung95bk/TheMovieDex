import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:themoviedex/generated/r.dart';
import 'package:themoviedex/presentation/custom_widgets/expandable.dart';
import 'package:themoviedex/presentation/screen2/widgets/horizontal_dash_line_painter.dart';
import 'package:themoviedex/presentation/util/adapt.dart';
import 'package:themoviedex/presentation/util/app_theme.dart';
import 'package:themoviedex/presentation/util/navigator_util.dart';

class VoiceSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpeechScreen();
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isError = false;
  double _confidence = 1.0;
  String textSuccess = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    double dashLineWidth = (Adapt.screenW() - 75 - 40 - 40) / 2;
    return Container(
      padding: EdgeInsets.only(top: Adapt.mediaQuery.padding.top),
      child: Scaffold(
          backgroundColor: AppTheme.bg_rank_top_rate,
          body: Container(
            margin:
                EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search voice",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Can I help you?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Container(
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: buildMicrophone()),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomPaint(
                              size: Size(dashLineWidth - 2, 2),
                              painter: HorizontalDashLinePainter(),
                            ),
                            CustomPaint(
                              size: Size(dashLineWidth, 2),
                              painter: HorizontalDashLinePainter(),
                            ),
                          ],
                        ),
                      ),
                      buildTextListening()
                    ]),
                  ),
                ),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        NavigatorUtil.popSinglePage(context);
                      },
                      child: Image.asset(
                        R.img_ic_close,
                        width: 20,
                        height: 20,
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  Widget buildTextListening() {
    if (_isListening) {
      return buildTextWidget("Listening...");
    } else if (_isError) {
      return buildTextWidget("Error");
    } else if (textSuccess.isNotEmpty) {
      return buildTextWidget(textSuccess);
    } else {
      return SizedBox();
    }
  }

  Widget buildTextWidget(String text) {
    return Align(
      alignment: Alignment.lerp(Alignment.center, Alignment.topCenter, 0.8),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildMicrophone() {
    return GestureDetector(
      onTap: () {
        _listen();
      },
      child: AvatarGlow(
          animate: _isListening,
          glowColor: Colors.deepOrangeAccent,
          endRadius: 100,
          showTwoGlows: true,
          duration: const Duration(milliseconds: 3000),
          repeatPauseDuration: const Duration(milliseconds: 10),
          repeat: true,
          child: _isListening
              ? Image.asset(
                  R.img_ic_microphone_active,
                  width: 60,
                  height: 60 * 1.42,
                )
              : Image.asset(
                  R.img_ic_microphone,
                  width: 60,
                  height: 60 * 1.42,
                )),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) {
          print('onStatus: $val');
          setState(() {
            _isListening = false;
            _isError = true;
          });
          _speech.stop();
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            textSuccess = val.recognizedWords;
            resetState();
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            NavigatorUtil.popSinglePageResult(context, textSuccess);
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void resetState() {
    _isListening = false;
    _isError = false;
  }
}
