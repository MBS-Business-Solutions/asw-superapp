import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutPolicyView extends StatelessWidget {
  const AboutPolicyView({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Html(
        data: '<p>${title}</p>',
      ),
    );
  }
}
