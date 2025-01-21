import 'package:asset_wise_super_app/src/0_widgets/aw_textfield.dart';
import 'package:flutter/material.dart';

class UIShowcaseScreen extends StatelessWidget {
  UIShowcaseScreen({super.key, required this.onSwitchToDarkMode, required this.onSwitchToLightMode, this.widgets});
  final Function onSwitchToDarkMode;
  final Function onSwitchToLightMode;
  final List<Widget>? widgets;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('UI Showcase'),
          actions: [
            IconButton(
              icon: const Icon(Icons.dark_mode),
              onPressed: () => onSwitchToDarkMode(),
            ),
            IconButton(
              icon: const Icon(Icons.light_mode),
              onPressed: () => onSwitchToLightMode(),
            ),
          ],
        ),
        body: ListView(
          children: [
            ..._textfieldShowcase(context),
            ..._buttonsShowcase(context),
            ..._iconButtonShowcase(context),
            ...widgets ?? [],
          ],
        ),
      ),
    );
  }

  List<Widget> _textfieldShowcase(BuildContext context) {
    return [
      paddingText('TextField', context),
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: TextEditingController(text: 'Lorem ipsum'),
              decoration: InputDecoration(
                label: Text('Text field'),
                hintText: 'TextField',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text('Hint text'),
                hintText: 'Hint text',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: TextEditingController(text: 'Lorem ipsum'),
              enabled: false,
              decoration: InputDecoration(
                label: Text('Disabled'),
                hintText: 'TextField',
              ),
            ),
            SizedBox(
              height: 50,
            ),
            AwTextField(label: 'เบอร์มือถือ'),
          ],
        ),
      )
    ];
  }

  List<Widget> _buttonsShowcase(BuildContext context) {
    return [
      paddingText('ElevatedButton', context),
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(onPressed: () {}, child: Text('ElevatedButton')),
            ElevatedButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ),
      paddingText('FilledButton', context),
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(onPressed: () {}, child: Text('FilledButton')),
            FilledButton.tonal(onPressed: () {}, child: Text('FilledButton.tonal')),
            FilledButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ),
      paddingText('OutlinedButton', context),
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(onPressed: () {}, child: Text('OutlinedButton')),
            OutlinedButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ),
      paddingText('TextButton', context),
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(onPressed: () {}, child: Text('TextButton')),
            TextButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ),
    ];
  }

  List<Widget> _iconButtonShowcase(BuildContext context) {
    return [
      paddingText('IconButton', context),
      ListTile(
        title: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.add_a_photo_rounded)),
                      Text('IconButton'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      IconButton(onPressed: null, icon: Icon(Icons.add_a_photo_rounded)),
                      Text('Disabled'),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      IconButton.filled(onPressed: () {}, icon: Icon(Icons.add_a_photo_rounded)),
                      Text('IconButton.filled'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      IconButton.filled(onPressed: null, icon: Icon(Icons.add_a_photo_rounded)),
                      Text('Disabled'),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      IconButton.filledTonal(onPressed: () {}, icon: Icon(Icons.add_a_photo_rounded)),
                      Text('IconButton.filled'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      IconButton.filledTonal(onPressed: null, icon: Icon(Icons.add_a_photo_rounded)),
                      Text('Disabled'),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      IconButton.outlined(onPressed: () {}, icon: Icon(Icons.add_a_photo_rounded)),
                      Text('IconButton.filled'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      IconButton.outlined(onPressed: null, icon: Icon(Icons.add_a_photo_rounded)),
                      Text('Disabled'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    ];
  }

  Widget paddingText(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
