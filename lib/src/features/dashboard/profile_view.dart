import 'package:AssetWise/src/features/dashboard/widgets/change_languange_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  static const String routeName = '/profile';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 96,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                child: Icon(Icons.person),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('John Doe', style: Theme.of(context).textTheme.headlineSmall),
                  Text('ID: 1234567890', style: Theme.of(context).textTheme.labelLarge),
                ],
              ))
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SwitchListTile.adaptive(
            value: _isDarkMode,
            onChanged: (value) {
              context.read<SettingsController>().updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
            title: Text('โหมดสีเข้ม'),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  'ข้อมูลของฉัน',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: Text('เบอร์มือถือ'),
                subtitle: Text('081-234-5678'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                title: Text('อีเมล'),
                subtitle: Text('sample@gmail.com'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  'บ้านของฉัน',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: Text('3 หลัง'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  'ภาษา',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: Text('เปลี่ยนภาษา'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pushNamed(ChangeLanguangeView.routeName);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  'ตั้งค่าบัญชี',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: Text('จัดการข้อมูลส่วนตัว'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                title: Text('รหัส PIN'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                title: Text('ปิดใช้งานหรือลบบัญชี'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListTile(
            title: Text('เกี่ยวกับ Assetwise'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  'การเข้าสู่ระบบ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: Text('ออกจากแอปพลิเคชัน Assetwise'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                title: Text('ออกจากระบบ'),
                trailing: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 72,
        ),
      ],
    );
  }
}
