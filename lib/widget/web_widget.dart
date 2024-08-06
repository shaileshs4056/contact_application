import 'package:flutter/material.dart';
import 'package:contact_number_demo/values/export.dart';
import 'package:contact_number_demo/widget/base_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage({
    required this.title,
    required this.url,
    super.key,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _isLoadingPage = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoadingPage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leadingIcon: true,
        showTitle: true,
        title: widget.title,
        backgroundColor: AppColor.white,
        leadingWidgetColor: AppColor.osloGray,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onPageFinished: (finish) {
                      setState(() {
                        _isLoadingPage = false;
                      });
                    },
                  ),
                )
                ..loadRequest(
                  Uri.parse(widget.url),
                ),
            ),
            Visibility(
              visible: _isLoadingPage,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
