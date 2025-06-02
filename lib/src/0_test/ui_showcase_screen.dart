import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/aw_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';

class UIShowcaseScreen extends StatefulWidget {
  const UIShowcaseScreen({super.key, required this.onSwitchToDarkMode, required this.onSwitchToLightMode, this.widgets});
  static const String routeName = '/ui-showcase';
  final Function onSwitchToDarkMode;
  final Function onSwitchToLightMode;
  final List<Widget>? widgets;

  @override
  State<UIShowcaseScreen> createState() => _UIShowcaseScreenState();
}

class _UIShowcaseScreenState extends State<UIShowcaseScreen> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('UI Showcase'),
          actions: [
            IconButton(
              icon: const Icon(Icons.dark_mode),
              onPressed: () => widget.onSwitchToDarkMode(),
            ),
            IconButton(
              icon: const Icon(Icons.light_mode),
              onPressed: () => widget.onSwitchToLightMode(),
            ),
          ],
        ),
        body: ListView(
          children: [
            SvgPicture.asset(
              height: 300,
              'assets/images/ASW_Logo_Rac_dark-bg.svg',
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              alignment: Alignment.centerLeft,
            ),
            ListTile(
              title: const Text('Text showcases'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TextShowCases(),
                ));
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            SwitchListTile.adaptive(value: value, onChanged: (v) => setState(() => value = v), title: const Text('Switch')),
            ..._textfieldShowcase(context),
            ..._buttonsShowcase(context),
            ..._iconButtonShowcase(context),
            ...widget.widgets ?? [],
            SizedBox(
              width: double.infinity,
              child: Html(data: '''<h2>คุณมีสิทธิในการ:</h2>
<ul>
<li>เข้าถึงและขอสำเนาข้อมูลส่วนบุคคลของคุณ</li>
<li>ขอแก้ไขข้อมูลส่วนบุคคลที่ไม่ถูกต้อง</li>
<li>ขอให้ลบข้อมูลส่วนบุคคลของคุณ เมื่อไม่มีความจำเป็นในการเก็บรักษาข้อมูลอีกต่อไป</li>
<li>ขอให้จำกัดการประมวลผลข้อมูลส่วนบุคคลของคุณ</li>
<li>เพิกถอนความยินยอมในการประมวลผลข้อมูลส่วนบุคคลของคุณได้ทุกเมื่อ</li></ul>'''),
            )
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
              decoration: const InputDecoration(
                label: Text('Text field'),
                hintText: 'TextField',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const TextField(
              decoration: InputDecoration(
                label: Text('Hint text'),
                hintText: 'Hint text',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: TextEditingController(text: 'Lorem ipsum'),
              enabled: false,
              decoration: const InputDecoration(
                label: Text('Disabled'),
                hintText: 'TextField',
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const AwTextField(label: 'เบอร์มือถือ'),
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
            ElevatedButton(onPressed: () {}, child: const Text('ElevatedButton')),
            const ElevatedButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ),
      paddingText('FilledButton', context),
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(onPressed: () {}, child: const Text('FilledButton')),
            FilledButton.tonal(onPressed: () {}, child: const Text('FilledButton.tonal')),
            const FilledButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ),
      paddingText('OutlinedButton', context),
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('OutlinedButton')),
            const OutlinedButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ),
      paddingText('TextButton', context),
      ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(onPressed: () {}, child: const Text('TextButton')),
            const TextButton(onPressed: null, child: Text('Disabled')),
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
                      IconButton(onPressed: () {}, icon: const Icon(Icons.add_a_photo_rounded)),
                      const Text('IconButton'),
                    ],
                  ),
                ),
                const Expanded(
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
                      IconButton.filled(onPressed: () {}, icon: const Icon(Icons.add_a_photo_rounded)),
                      const Text('IconButton.filled'),
                    ],
                  ),
                ),
                const Expanded(
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
                      IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.add_a_photo_rounded)),
                      const Text('IconButton.filled'),
                    ],
                  ),
                ),
                const Expanded(
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
                      IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.add_a_photo_rounded)),
                      const Text('IconButton.filled'),
                    ],
                  ),
                ),
                const Expanded(
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

class TextShowCases extends StatelessWidget {
  const TextShowCases({super.key});
  final String shortText = 'ABC ทั้งที่ 12';
  final String longText = '''ASW คว้าเรตติ้ง “AA” หุ้นยั่งยืน SET ESG Ratings ปี 2567 พร้อม CGR 5 ดาว ระดับ “ดีเลิศ” 3 ปีซ้อน ตอกย้ำองค์กรยั่งยืนตามหลักบรรษัทภิบาล''';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('displayLarge', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.displayLarge),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('displayMedium', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.displayMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('displaySmall', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.displaySmall),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('headlineLarge', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.headlineLarge),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('headlineMedium', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('headlineSmall', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.headlineSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('titleLarge', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.titleLarge),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('titleMedium', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('titleSmall', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('bodyLarge', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(longText, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('bodyMedium', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(longText, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('bodySmall', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(longText, style: Theme.of(context).textTheme.bodySmall),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('labelLarge', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.labelLarge),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('labelMedium', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.labelMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('labelSmall', style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: Text(shortText, style: Theme.of(context).textTheme.labelSmall),
          ),
        ],
      ),
    );
  }
}
