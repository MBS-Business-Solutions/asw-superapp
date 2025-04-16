import 'package:AssetWise/src/consts/constants.dart';
import 'package:AssetWise/src/consts/hot_menu_const.dart';
import 'package:AssetWise/src/models/aw_hotmenu_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HotMenuProvider with ChangeNotifier {
  late final Map<String, HotMenuItem> _allHotMenu;
  final List<HotMenuItem> _selectedHotMenu = [];
  List<HotMenuItem> get selectedHotMenu => _selectedHotMenu;
  List<HotMenuItem> _availableHotMenu = [];
  List<HotMenuItem> get availableHotMenu => _availableHotMenu;
  bool get canAddMenu => _selectedHotMenu.length < mHotMenuRow;

  HotMenuProvider() {
    init();
  }

  Future<void> init() async {
    _allHotMenu = mHotMenuConfig.map((key, value) => MapEntry(key, HotMenuItem.fromJson(key, value)));
    await _loadSelectedHotMenu();
    await _loadAvailableHotMenu();
  }

  Future<void> _loadSelectedHotMenu() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedIds = prefs.getStringList('selectedHotMenu') ?? mDefaultMenuConfig;

    for (final hotMenuId in selectedIds) {
      if (mHotMenuConfig.containsKey(hotMenuId)) {
        _selectedHotMenu.add(_allHotMenu[hotMenuId]!);
      }
    }
    await _saveConfig();
    notifyListeners();
  }

  Future<void> _loadAvailableHotMenu() async {
    _availableHotMenu = _allHotMenu.values.where((item) => !_selectedHotMenu.contains(item)).toList();
    _availableHotMenu.sort((a, b) => a.id.compareTo(b.id));
    notifyListeners();
  }

  Future<void> addHotMenu(String id) async {
    if (_selectedHotMenu.length >= mHotMenuRow) {
      throw Exception('Maximum of mHotMenuRow hot menus can be selected.');
    }
    _selectedHotMenu.add(_allHotMenu[id]!);
    _loadAvailableHotMenu();
    await _saveConfig();
    notifyListeners();
  }

  Future<void> removeHotMenu(String id) async {
    _selectedHotMenu.removeWhere((item) => item.id == id);
    _loadAvailableHotMenu();
    await _saveConfig();
    notifyListeners();
  }

  Future<void> _saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedHotMenu', _selectedHotMenu.map((item) => item.id).toList());
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    newIndex--;

    final item = _selectedHotMenu.removeAt(oldIndex);
    _selectedHotMenu.insert(newIndex + 1, item);
    await _saveConfig();
    notifyListeners();
  }
}
