import 'package:flutter/material.dart';

class TestRoute extends StatelessWidget {
  const TestRoute({super.key});
  static const String routeName = '/test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            ListTile(
              title: const Text('UI Showcase'),
              onTap: () => Navigator.pushNamed(context, '/ui-showcase'),
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () => Navigator.pushNamed(context, '/dashboard'),
            ),
            ListTile(
              title: const Text('Register'),
              onTap: () => Navigator.pushNamed(context, '/register'),
            ),
            ListTile(
              title: const Text('Set Pin'),
              onTap: () => Navigator.pushNamed(context, '/set-pin'),
            ),
            ListTile(
              title: const Text('Consents'),
              onTap: () => Navigator.pushNamed(context, '/consents'),
            ),
          ],
        ));
  }
}
