import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rotary_nl_rye/core/presentation/widgets/circle_progress_bar.dart';
import 'package:rotary_nl_rye/core/presentation/widgets/native_video.dart';
import 'package:rotary_nl_rye/core/prop.dart';
import 'package:rotary_nl_rye/core/translation/translate.dart';

class NonPDFPage extends StatefulWidget {
  @override
  _NonPDFPageState createState() => _NonPDFPageState();
  final Map<String, dynamic> data;

  NonPDFPage({required this.data});
}

class _NonPDFPageState extends State<NonPDFPage> {
  bool isTranslating = false;
  String heading = "Placeholder";
  List<Widget> translate = [];
  bool _isLoading = false;
  double progressPercent = 0;
  int index = 0;
  int translationIndex = 0;

  bool translationSuccess = true;
  String errorMessage = "";

  void dispose() {
    isTranslating = false;
    translate.clear();
    index = 0;
    translationIndex = 0; // TODO: implement dispose

    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color foreground = Colors.red;

    if (progressPercent >= 0.8) {
      foreground = Colors.green;
    } else if (progressPercent >= 0.4) {
      foreground = Colors.orange;
    }

    Color background = foreground.withOpacity(0.2);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Container(
            margin: EdgeInsets.only(left: 10, top: 5),
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(40.0)),
            child: RawMaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Icon(
                Icons.arrow_back,
                color: Palette.accentColor,
                size: 30.0,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Palette.themeShadeColor,
              padding: const EdgeInsets.all(5.0),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10, top: 5),
              width: 50,
              height: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(40.0)),
              child: Platform.localeName == 'NL' ? Container() : RawMaterialButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    isTranslating = !isTranslating;
                    FutureBuilder(future: translated(widget.data['text'][1]["body"]),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (!translationSuccess && isTranslating) {
                          print('show dialog');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: TextButton.icon(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Palette.accentColor), label: Text(errorMessage, style: TextStyle(color: Palette.accentColor),)),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    );
                  });
                },
                child: new FaIcon(
                  FontAwesomeIcons.language,
                  color: Palette.accentColor,
                  size: 30.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Palette.themeShadeColor,
                padding: const EdgeInsets.all(5.0),
              ),
            ),
          ],
          title: Text(
            widget.data["title"],
            textScaleFactor: 1.4,
            style:
                TextStyle(color: Palette.indigo, fontWeight: FontWeight.bold),
          ),
        ),
        body: _isLoading
            ? Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircleProgressBar(
                          backgroundColor: background,
                          foregroundColor: foreground,
                          value: this.progressPercent,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${(this.progressPercent * 100).round()}%",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "COMPLETED",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        (isTranslating)
                            ? heading
                            : (widget.data["text"][0]["heading"]),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...((isTranslating)
                        ? translate
                        : (_text(widget.data["text"][1]['body'])))
                  ],
                ),
              ) // NativeVideo(url: "https://www.youtube.com/watch?v=ClpPvpbYBpY"),
        );
  }

  List<Widget> _text(List newsBody) {
    index = 1;
    List<Widget> resultList = [];
    for (Map<String, dynamic> bodyItem in newsBody) {
      if (bodyItem['paragraph'] != null) {
        for (String text in bodyItem['paragraph']) {
          index++;
          resultList.add(paragraphItem(text: text));
        }
      } else if (bodyItem['imageUrl'] != null) {
        resultList.add(imageItem(url: bodyItem["imageUrl"]));
      } else if (bodyItem['videoUrl'] != null) {
        resultList.add(videoItem(url: bodyItem["videoUrl"]));
      } else if (bodyItem['subHeader'] != null) {
        index++;
        resultList.add(subHeaderItem(text: bodyItem["subHeader"]));
      }
    }

    return resultList;
  }

  Future<void> translated(List newsBody) async {
    translate.clear();
    translationIndex = 0;
    heading = await header(widget.data['text'][0]["heading"]);
    setState(() {
      translationIndex++;
      progressPercent = translationIndex / index;
    });

    for (Map<String, dynamic> bodyItem in newsBody) {
      if (bodyItem['paragraph'] != null) {
        for (String text in bodyItem['paragraph']) {
          final value = await Translate.text(inputText: text);
          String translation = await value['translation'];
          if (translationSuccess) {
            translationSuccess = await value['success'];
          }
          if (errorMessage == "") {
            errorMessage = await value['message'];
          }
          translate.add(paragraphItem(text: translation));
          setState(() {
            translationIndex++;
            progressPercent = translationIndex / index;
          });
        }
      } else if (bodyItem['imageUrl'] != null) {
        translate.add(imageItem(url: bodyItem['imageUrl']));
      } else if (bodyItem['videoUrl'] != null) {
        translate.add(videoItem(url: bodyItem['videoUrl']));
      } else if (bodyItem['subHeader'] != null) {
        final value = await Translate.text(inputText: bodyItem['subHeader']);
        String translation = await value['translation'];
        if (translationSuccess) {
          translationSuccess = await value['success'];
        }
        if (errorMessage == "") {
          errorMessage = await value['message'];
        }
        translate.add(subHeaderItem(text: translation));
        setState(() {
          translationIndex++;
          progressPercent = translationIndex / index;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<String> header(String text) async {
    final value = await Translate.text(inputText: text);
    final heading = value['translation'];
    if (translationSuccess) {
      translationSuccess = value['success'];
    }
    if (errorMessage == "") {
      errorMessage = value['message'];
    }

    return heading;
  }

  Widget videoItem({required String url}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: NativeVideo(url: url),
    );
  }

  Widget imageItem({required String url}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Image.network(url),
    );
  }

  Widget paragraphItem({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      ),
    );
  }

  Widget subHeaderItem({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
