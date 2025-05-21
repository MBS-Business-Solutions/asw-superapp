import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWithCloseButton extends StatefulWidget {
  const WebViewWithCloseButton({super.key, required this.link});
  final String link;
  static const String routeName = '/webview_with_close';

  @override
  State<WebViewWithCloseButton> createState() => _WebViewWithCloseButtonState();
}

class _WebViewWithCloseButtonState extends State<WebViewWithCloseButton> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!widget.link.startsWith('http')) {
        launchUrlString(widget.link);
        Navigator.pop(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setUserAgent('Mozilla/5.0 (Mobile; CPU like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile Safari/604.1')
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                bool isAboutBlank = request.url.startsWith('about:blank');
                if (!request.url.startsWith('http') && !isAboutBlank) {
                  launchUrlString(request.url);
                  // if (!_isPoped) {
                  //   _isPoped = true;
                  //   Navigator.pop(context);
                  // }
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(
            Uri.parse(widget.link),
          ),
      ),
    );
  }
}
