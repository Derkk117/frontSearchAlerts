import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Browser extends StatefulWidget {
  final String firstUrl; //first url part.
  final String lasttUrl; //last url part.
  final ValueNotifier<String> searchQuery; //key words that we'll search
  final String domainName; //name of the page.
  final String source; //element we'll be serching.

  Browser(
      {Key key,
      @required this.firstUrl,
      @required this.lasttUrl,
      @required this.searchQuery,
      @required this.source,
      this.domainName})
      : super(key: key);

  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  InAppWebView browser;
  InAppWebViewController webView;
  String text = ""; //text that we'll return.
  String search = "";
  Future<String> _calculation;

  @override
  void initState() {
    widget.searchQuery.addListener(() => setState(initText));
    initText();
    browser = InAppWebView(
        initialUrl: widget.firstUrl + this.search + widget.lasttUrl,
        initialHeaders: {},
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
              preferredContentMode: UserPreferredContentMode.DESKTOP,
              debuggingEnabled: true,
              userAgent:
                  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0"),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
        },
        onLoadStart: (InAppWebViewController controller, String url) {},
        onLoadStop: (InAppWebViewController controller, String url) async {
          webView = controller;
          // if JavaScript is enabled, you can use.
          this.text =
              await controller.evaluateJavascript(source: widget.source);
        });

    _calculation = Future<String>.delayed(Duration(seconds: 15), () => text);
    super.initState();
  }

  initText() {
    this.search = widget.searchQuery.value;
    if (webView != null)
      webView.loadUrl(url: widget.firstUrl + this.search + widget.lasttUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [Expanded(child: browser)],
            ),
            height: 100,
          ),
          FutureBuilder(
            future: _calculation,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Network connection loss.');
                case ConnectionState.waiting:
                  return new Text('Awaiting result...');
                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else {
                    if (text != null)
                      return new Text(widget.domainName + ": " + text ??
                          "Answer" + ": " + text);
                    else
                      return new Text(widget.domainName + ": did not respond" ??
                          "Unanswer");
                  }
              }
            },
          )
        ],
      ),
    );
  }
}
