import 'package:QRtendance/utils/theme.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:mlkit/mlkit.dart';

class MLDetail extends StatefulWidget {
  final File _file;

  MLDetail(this._file);

  @override
  State<StatefulWidget> createState() {
    return _MLDetailState();
  }
}

class _MLDetailState extends State<MLDetail> {
  FirebaseVisionTextDetector textDetector = FirebaseVisionTextDetector.instance;
  List<VisionText> _currentTextLabels = <VisionText>[];

  Stream sub;
  StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    super.initState();
    sub = new Stream.empty();
    subscription = sub.listen((_) => _getImageSize)..onDone(analyzeLabels);
  }

  void analyzeLabels() async {
    try {
      var currentLabels;
      currentLabels = await textDetector.detectFromPath(widget._file.path);
      if (this.mounted) {
        setState(() {
          _currentTextLabels = currentLabels;
        });
      }
    } catch (e) {
      print("MyEx: " + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.9],
                    colors: [
                      Colors.white70,
                      Colors.amber,
                    ],
                  ),
                ),
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                          'Select the List which contain the name of student.\nIf the name not appear, please scan again.',
                          style: mediumTextStyle),
                    ),
                    buildTextList(_currentTextLabels)
                  ],
                ))));
  }

  Widget buildTextList(List<VisionText> texts) {
    if (texts.length == 0) {
      return Expanded(
          flex: 1,
          child: Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          ));
    }
    return Expanded(
      flex: 1,
      child: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(1.0),
            itemCount: texts.length,
            itemBuilder: (context, i) {
              return _buildTextRow(texts[i].text);
            }),
      ),
    );
  }

  Widget _buildTextRow(text) {
    print(text);
    return InkWell(
      onTap: () {
        Navigator.pop(context, text);
      },
      child: ListTile(
        title: Container(
          color: Colors.white30,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "$text",
              style: smallTextStyle,
            ),
          ),
        ),
        dense: true,
      ),
    );
  }

  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble())));
    return completer.future;
  }
}
