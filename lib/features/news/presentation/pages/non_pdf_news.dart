// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

// 🌎 Project imports:
import 'package:rotary2130_2140_rye/core/domain/entities/news.dart';
import 'package:rotary2130_2140_rye/core/presentation/widgets/native_video.dart';
import 'package:rotary2130_2140_rye/core/prop.dart';
import 'package:rotary2130_2140_rye/core/translation/translate.dart';
import 'package:rotary2130_2140_rye/features/news/presentation/widgets/pdf_viewer.dart';
import 'package:rotary2130_2140_rye/features/uniform_widgets/back_button.dart';

class NonPDFPage extends StatefulWidget {
  @override
  _NonPDFPageState createState() => _NonPDFPageState();
  final News data;

  NonPDFPage({required this.data});
}

class _NonPDFPageState extends State<NonPDFPage> {
  bool isTranslating = false;
  String heading = 'Placeholder';
  List<Widget> translate = [];
  bool _isLoading = false;
  double progressPercent = 0;
  int index = 0;
  int translationIndex = 0;

  bool translationSuccess = true;
  String errorMessage = '';

  String? _linkMessage;
  String? id;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  void dispose() {
    isTranslating = false;
    translate.clear();
    index = 0;
    translationIndex = 0; // TODO: implement dispose
    _linkMessage;

    // TODO: implement dispose

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._createDynamicLink(id = widget.data.id.toString());
    _removeBadge();
  }

  void _removeBadge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('newsBadge', 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? SystemUiOverlayStyle.dark
                  : SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: UniformBackButton(),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10, top: 5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Palette.themeShadeColor,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Platform.localeName == 'NL'
                  ? PopupMenuButton<int>(
                      // color: Colors.black,
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                            value: 0,
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.share,
                                  color: Palette.lightIndigo,
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text('Share')
                              ],
                            )),
                      ],
                      onSelected: (item) => selectedItem(context, item),
                    )
                  : PopupMenuButton<int>(
                      // color: Colors.black,
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                            value: 0,
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.share,
                                  color: Palette.lightIndigo,
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text('Share')
                              ],
                            )),
                        PopupMenuDivider(),
                        PopupMenuItem<int>(
                            value: 1,
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.language,
                                  color: Palette.lightIndigo,
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text('Translate')
                              ],
                            )),
                      ],
                      onSelected: (item) => selectedItem(context, item),
                      icon: FaIcon(
                        FontAwesomeIcons.list,
                        color: Palette.accentColor,
                        size: 22.0,
                      ),
                    ),
            ),
          ],
          title: Text(
            widget.data.title,
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
                    CircularPercentIndicator(
                      animation: true,
                      animateFromLastPercent: true,
                      radius: 80.0,
                      lineWidth: 8.0,
                      percent: this.progressPercent,
                      center: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${(this.progressPercent * 100).round()}%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'COMPLETED',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      progressColor: Colors.green,
                    )
                    // Container(
                    //   width: 200,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(20.0),
                    //     child: CircleProgressBar(
                    //       backgroundColor: background,
                    //       foregroundColor: foreground,
                    //       value: this.progressPercent,
                    //     ),
                    //   ),
                    // ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Text(
                    //       '${(this.progressPercent * 100).round()}%',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 30.0,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //     Text(
                    //       'COMPLETED',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 15.0,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ],
                    // ),
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
                            : (widget.data.text![0]['heading']),
                        style: TextStyle(
                            color: Palette.titleText,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...((isTranslating)
                        ? translate
                        : (_text(widget.data.text![1]['body'])))
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
        resultList.add(imageItem(url: bodyItem['imageUrl']));
      } else if (bodyItem['videoUrl'] != null) {
        resultList.add(videoItem(url: bodyItem['videoUrl']));
      } else if (bodyItem['pdfUrl'] != null) {
        resultList.add(pdfButton(pdfUrl: bodyItem['pdfUrl']));
      } else if (bodyItem['subHeader'] != null) {
        index++;
        resultList.add(subHeaderItem(text: bodyItem['subHeader']));
      }
    }

    return resultList;
  }

  Future<void> translated(List newsBody) async {
    translate.clear();
    translationIndex = 0;
    heading = await header(widget.data.text![0]['heading']);
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
          if (errorMessage == '') {
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
      } else if (bodyItem['pdfUrl'] != null) {
        translate.add(pdfButton(pdfUrl: bodyItem['pdfUrl']));
      } else if (bodyItem['subHeader'] != null) {
        final value = await Translate.text(inputText: bodyItem['subHeader']);
        String translation = await value['translation'];
        if (translationSuccess) {
          translationSuccess = await value['success'];
        }
        if (errorMessage == '') {
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
    if (errorMessage == '') {
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

  Widget pdfButton({required String pdfUrl}) {
    return Padding(
        padding: const EdgeInsets.only(top: 40.0, bottom: 30),
        child: Container(
          child: Center(
            child: CupertinoButton.filled(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PDFPage(
                            pdfUrl: pdfUrl,
                            data: widget.data,
                          )),
                );
              },
              child:
                  // Row(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 25.0),
                  //       child: FaIcon(
                  //         FontAwesomeIcons.phone,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 20.0),
                  //       child: Text(
                  //         'Call me ',
                  //         style: TextStyle(color: Colors.white, fontSize: 18.0),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Text('Open PDF'),
            ),
          ),
        ));
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
        style: TextStyle(color: Palette.bodyText, fontSize: 16.0),
      ),
    );
  }

  Widget subHeaderItem({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Text(
        text,
        style: TextStyle(
            color: Palette.titleText,
            fontSize: 14.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> selectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        _createDynamicLink(
            id = widget.data.id.toString()); //TODO add the parameters here

        if (await canLaunchUrlString(_linkMessage!)) {
          await Share.share(
              Platform.isIOS
                  ? 'Hier moet nog een leuk stukje komen. + de link naar de juiste pagina $_linkMessage' // iOS
                  : 'Hier moet nog een leuk stukje komen. + de link naar de juiste pagina $_linkMessage',
              //android
              subject: 'look at this nice app :)');
        } else {
          throw 'Could not launch $_linkMessage';
        }

        break;
      case 1:
        print('platform ${Platform.localeName}');
        setState(() {
          _isLoading = true;
          isTranslating = !isTranslating;
          FutureBuilder(
            future: translated(widget.data.text![1]['body']),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (!translationSuccess && isTranslating) {
                print('show dialog');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      insetPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close, color: Palette.accentColor),
                          label: Text(
                            errorMessage,
                            style: TextStyle(color: Palette.accentColor),
                          )),
                    );
                  },
                );
              }
              return Container();
            },
          );
        });

        break;
    }
  }

  Future<void> _createDynamicLink(String id) async {
    setState(() {});

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://rotarynl.page.link',
      link: Uri.parse(
          'https://rotarynl.page.link/news?id=$id'), //change this to the url in the main.dart
      androidParameters: AndroidParameters(
        packageName: 'org.rotary2130.commyouth',
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.caelitechnologies.rotary-nl-rye',
        minimumVersion: '1.0.0',
        appStoreId: '1567096118',
      ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //   title: 'Example of a Dynamic Link',
      //   description: 'This link works whether app is installed or not!',
      //   imageUrl: Uri.parse(
      //       'https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/6e/21/e4/6e21e45b-49cb-fa52-83c2-bb56ab288b49/AppIcon-0-0-1x_U007emarketing-0-0-0-4-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.jpeg/1200x630wa.png'),
      // ),
    );

    Uri url;
    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    url = shortLink.shortUrl;

    setState(() {
      _linkMessage = url.toString();
    });
  }
}
