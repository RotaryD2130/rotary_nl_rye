// 🎯 Dart imports:
import 'dart:async';
import 'dart:io';

// 🐦 Flutter imports:
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

// 🌎 Project imports:
import 'package:rotary2130_2140_rye/core/prop.dart';
import 'package:rotary2130_2140_rye/features/uniform_widgets/back_button.dart';

class PDFPageWithShare extends StatefulWidget {
  final String pdfUrl;

  PDFPageWithShare({required this.pdfUrl});
  @override
  _PDFPageWithShareState createState() =>
      _PDFPageWithShareState(pdfUrl: pdfUrl);
}

class _PDFPageWithShareState extends State<PDFPageWithShare> {
  final String pdfUrl;

  _PDFPageWithShareState({required this.pdfUrl});

  String title = 'Loading';

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  final StreamController<String> _pageCountController =
      StreamController<String>();

  String? _linkMessage;
  String? id;

  @override
  void initState() {
    super.initState();

    this._createDynamicLink(pdfUrl);

    print(pdfUrl);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
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
              // margin: EdgeInsets.only(right: 10, top: 5),
              // width: 50,
              // height: 50,
              // decoration: BoxDecoration(
              //   color: Palette.themeShadeColor,
              //   borderRadius: BorderRadius.circular(40.0),
              // ),
              child: PopupMenuButton<int>(
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
                          Text('Share in-app Link')
                        ],
                      )),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.filePdf,
                            color: Palette.lightIndigo,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text('Share Document')
                        ],
                      )),
                ],
                onSelected: (item) => selectedItem(context, item),
                icon: FaIcon(
                  FontAwesomeIcons.list,
                  color: Palette.indigo,
                  size: 22.0,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            PDF(
              onPageChanged: (int? current, int? total) =>
                  _pageCountController.add('${current! + 1} / $total'),
              onViewCreated: (PDFViewController pdfViewController) async {
                _pdfViewController.complete(pdfViewController);
                final int currentPage =
                    await pdfViewController.getCurrentPage() ?? 0;
                final int? pageCount = await pdfViewController.getPageCount();
                _pageCountController.add('${currentPage + 1} / $pageCount');
              },
            ).cachedFromUrl(
              pdfUrl,
              placeholder: (progress) => Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    new CircularPercentIndicator(
                      animation: true,
                      animateFromLastPercent: true,
                      radius: 80.0,
                      lineWidth: 8.0,
                      percent: (progress / 100),
                      center: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${(progress).round()}%',
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
                  ],
                ),
              ),
              errorWidget: (error) => Center(child: Text(error.toString())),
              maxAgeCacheObject: const Duration(days: 10),
            ),
            StreamBuilder<String>(
                stream: _pageCountController.stream,
                builder: (_, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                            padding: EdgeInsets.only(
                                top: 4.0, left: 16.0, bottom: 4.0, right: 16.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: Colors.grey[400]),
                            child: Text(snapshot.data!,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400))));
                  }

                  return const SizedBox();
                }),
          ],
        ));
  }

  Future<void> _createDynamicLink(String pdfUrl) async {
    setState(() {});

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://rotarynl.page.link',
      link: Uri.parse(
          'https://rotarynl.page.link/pdfUrl?url=$pdfUrl'), //change this to the url in the main.dart
      androidParameters: AndroidParameters(
        packageName: 'org.rotary2130.commyouth',
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.caelitechnologies.rotary-nl-rye',
        minimumVersion: '1',
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

    if (this.mounted) {
      setState(() {
        _linkMessage = url.toString();
      });
    }
  }

  Future<void> selectedItem(BuildContext context, item) async {
    _createDynamicLink(pdfUrl);

    switch (item) {
      case 0:
        if (await canLaunchUrlString(_linkMessage!)) {
          await Share.share(
              Platform.isIOS
                  ? 'Hierbij verstuur ik een linkje van een Document: $_linkMessage' // iOS
                  : 'Hierbij verstuur ik een linkje van een Document: $_linkMessage', //android
              subject: 'look at this nice app :)');
        } else {
          throw 'Could not launch $_linkMessage';
        }

        break;

      case 1:
        Directory tempDir = await getTemporaryDirectory();
        String fielName = pdfUrl.split('/').last;

        final path = '${tempDir.path}/${fielName}';

        await Dio().download(pdfUrl, path);

        if (await canLaunchUrlString(_linkMessage!)) {
          await Share.shareXFiles([XFile(path)],
              text:
                  'Hierbij verstuur ik een linkje van een Document: $_linkMessage',
              subject: fielName);
        } else {
          throw 'Could not launch $_linkMessage';
        }

        break;
    }
  }
}
