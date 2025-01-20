import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // ทำให้ body ขยายลงใต้ bottom navigation bar
      body: Container(
        color: Colors.red,
        child: Center(
          child: Text(
            'เนื้อหาเต็มหน้าจอ',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.yellow,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, color: Colors.cyan),
                Text('Home', style: TextStyle(color: Colors.cyan)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.settings, color: Colors.orange),
                Text('Settings', style: TextStyle(color: Colors.orange)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
