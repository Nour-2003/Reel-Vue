import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatelessWidget {
  late String url;
  WebviewScreen({required this.url});
  late WebViewController controller = WebViewController()
    ..loadRequest(
      Uri.parse(this.url),
    );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text('Web View',style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: WebViewWidget(controller:controller),
    );
  }
}
