import 'package:channel_connect/network/Url_list.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool loading = true;
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // child: WebView(
              //   initialUrl: _loadHTML(),
              // ),
              child: InAppWebView(
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        mediaPlaybackRequiresUserGesture: false,
                        javaScriptEnabled: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                        useShouldInterceptFetchRequest: true,
                        useShouldInterceptAjaxRequest: true,
                        supportZoom: false,
                        useOnLoadResource: true),
                    android: AndroidInAppWebViewOptions(
                        useWideViewPort: false,
                        useHybridComposition: true,
                        loadWithOverviewMode: true,
                        domStorageEnabled: true,
                        useShouldInterceptRequest: true),
                    ios: IOSInAppWebViewOptions(
                        allowsInlineMediaPlayback: true,
                        enableViewportScale: true,
                        ignoresViewportScaleLimits: true)),
                initialUrlRequest:
                    URLRequest(url: Uri.parse(UrlList.forgotPassword)),
                //  initialData: InAppWebViewInitialData(data: _loadHTML()),
                onWebViewCreated: (InAppWebViewController controller) async {
                  _webViewController = controller;
                },
                onLoadStop: (controller, uri) {
                  setState(() {
                    loading = false;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  myPrint(navigationAction.request.url.toString());
                  // if (!navigationAction.request.url
                  //     .toString()
                  //     .contains(UrlList.register)) {
                  //   Navigator.pop(context);
                  // }
                },
                // :
                //     (InAppWebViewController controller, Uri? pageUri) async {
                //   // setState(() {
                //   loading = false;
                //   //  });
                //   final url = pageUri.toString();
                //   print("onLoadResource " + url.toString());
                //   if (url.toString() == widget.data!.redirectUrl) {
                //     // final result = await controller.evaluateJavascript(
                //     //   source:
                //     //       "document.getElementsByName('encResp')[0].value;",
                //     // );
                //     var result = await controller.evaluateJavascript(source: "1 + 1");
                //     print(" java script result " + "$result");
                //     showDialog(
                //         context: context,
                //         builder: (_) => AlertDialog(
                //               content: Text("$result"),
                //             ));
                //   }
                // },
              ),
            ),
            (loading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(),
          ],
        ),
      ),
    );
  }
}
