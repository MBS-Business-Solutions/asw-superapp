import 'package:flutter/material.dart';

class RedirectPage {
  String? _redirectPage;
  dynamic _data;
  bool get shouldRedirect => _redirectPage != null;
  static final RedirectPage _instance = RedirectPage._();
  RedirectPage._();
  factory RedirectPage() => _instance;

  String? get redirectPage => _redirectPage;
  dynamic get data => _data;

  void setRedirectPage(String page, dynamic data) async {
    _redirectPage = page;
    _data = data;
  }

  void redirect(BuildContext context) async {
    if (_redirectPage != null) {
      await Navigator.pushNamed(
        context,
        _redirectPage!,
        arguments: _data,
      );
      _redirectPage = null;
      _data = null;
    }
  }
}
