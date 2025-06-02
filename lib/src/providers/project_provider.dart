import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/features/find_projects/widgets/pin_widget.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:geolocator/geolocator.dart';

class ProjectProvider with ChangeNotifier {
  UserProvider? _userProvider;
  bool _isFiltering = false;
  bool get isFiltering => _isFiltering;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final _searchResults = <ProjectSearchItem>[];
  List<ProjectSearchItem> get searchResults => _searchResults;
  final List<KeyValue> _brands = [];
  List<KeyValue> get brands => _brands;
  final List<KeyValue> _locations = [];
  List<KeyValue> get locations => _locations;
  final List<ProjectFilterStatus> _projectStatus = [];
  List<ProjectFilterStatus> get projectStatus => _projectStatus;
  String _searchText = '';
  String get searchText => _searchText;
  final Set<int> _selectedBrands = {};
  Set<int> get selectedBrands => _selectedBrands;
  final Set<int> _selectedLocations = {};
  Set<int> get selectedLocations => _selectedLocations;
  String _selectedStatus = '';
  String get selectedStatus => _selectedStatus;
  Map<String, BitmapDescriptor>? _pinBitmapNormal;
  Map<String, BitmapDescriptor>? _pinBitmapSelected;
  Map<String, BitmapDescriptor>? get pinBitmapNormal => _pinBitmapNormal;
  Map<String, BitmapDescriptor>? get pinBitmapSelected => _pinBitmapSelected;
  bool get isPinBitmapLoaded => _pinBitmapNormal != null && _pinBitmapSelected != null;

  bool _serviceEnabled = false;
  LocationPermission? _permission;
  bool get serviceEnabled => _serviceEnabled;
  LocationPermission? get permission => _permission;
  ProjectProvider() {
    // load master data
    loadMasterData();
  }

  Future<void> loadMasterData() async {
    // load master data
    final locationsResponse = await AWContentService().fetchLocationsMasterData();
    if (locationsResponse.status == 'success') {
      _locations.clear();
      _locations.addAll(locationsResponse.data!);
    }
    final projectStatusResponse = await AWContentService().fetchProjectStatusMasterData();
    if (projectStatusResponse.status == 'success') {
      _projectStatus.clear();
      _projectStatus.addAll(projectStatusResponse.data!);
    }
    final brandsResponse = await AWContentService().fetchBrandsMasterData();
    if (brandsResponse.status == 'success') {
      _brands.clear();
      _brands.addAll(brandsResponse.data!);
      _initBrandImages(); // run on background
    }
  }

  Future<void> initSearchForm({bool isSearchProject = true}) async {
    // clear search filters
    _searchText = '';
    _selectedBrands.clear();
    _selectedLocations.clear();
    _searchResults.clear();
    // load master data

    final locationsResponse = await AWContentService().fetchLocationsMasterData();
    if (locationsResponse.status == 'success') {
      _locations.clear();
      _locations.addAll(locationsResponse.data!);
    }
    final projectStatusResponse = await AWContentService().fetchProjectStatusMasterData();
    if (projectStatusResponse.status == 'success') {
      _projectStatus.clear();
      _projectStatus.addAll(projectStatusResponse.data!);
    }
    // load projects
    if (isSearchProject) {
      await _search();
    }
    notifyListeners();
  }

  Future<void> _initBrandImages() async {
    _pinBitmapNormal = <String, BitmapDescriptor>{};
    _pinBitmapSelected = <String, BitmapDescriptor>{};
    for (var brand in _brands) {
      if (brand.image == null) continue;
      final image = await AWContentService().fetchFileBinary(brand.image!);
      if (image.isNotEmpty) {
        final imageNormal = await PinWidget(
          color: mBrightPrimaryColor,
          bytes: image,
        ).toBitmapDescriptor(logicalSize: const Size(150, 150), imageSize: const Size(350, 350));
        final imageSelect = await PinWidget(
          color: mTealColor,
          bytes: image,
        ).toBitmapDescriptor(logicalSize: const Size(150, 150), imageSize: const Size(350, 350));
        _pinBitmapNormal![brand.id.toString()] = imageNormal;
        _pinBitmapSelected![brand.id.toString()] = imageSelect;
      }
    }
  }

  void selectLocation(int id) {
    if (_selectedLocations.contains(id)) {
      _selectedLocations.remove(id);
    } else {
      _selectedLocations.add(id);
    }
    notifyListeners();
  }

  void selectBrand(int id) {
    if (_selectedBrands.contains(id)) {
      _selectedBrands.remove(id);
    } else {
      _selectedBrands.add(id);
    }
    notifyListeners();
  }

  void setSearchText(String text) async {
    _searchText = text;
    await _search();
    notifyListeners();
  }

  void setProjectStatus(String status) async {
    _selectedStatus = status;
    await _search();
    notifyListeners();
  }

  Future<void> clearFilter() async {
    _searchText = '';
    _selectedBrands.clear();
    _selectedLocations.clear();
    _selectedStatus = '';
    await _search();
    notifyListeners();
  }

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  Future<void> applySearchFilter() async {
    await _search();
    notifyListeners();
  }

  Future<String?> setFavorite(
    int id,
    bool fav,
  ) async {
    if (_userProvider == null) return null;
    ServiceResponse? response;
    if (fav) {
      response = await AWContentService().setFavoriteProject(id, _userProvider!.token!);
    } else {
      response = await AWContentService().unsetFavoriteProject(id, _userProvider!.token!);
    }

    if (response.status == 'success' && _searchResults.isNotEmpty) {
      // เฉพาะกรณีที่มีการค้นหาจากหน้า ProjectsView
      // ให้ทำการอัปเดตข้อมูลใน _searchResults
      _searchResults.firstWhere((element) => element.id == id).isFavorite = fav;
    } else {
      return response.message ?? 'Error';
    }

    notifyListeners();
    return null;
  }

  Future<void> _search() async {
    _isLoading = true;
    _searchResults.clear();
    notifyListeners();
    final projectsResponse = await AWContentService().searchProjects(
      search: _searchText,
      brandIds: _selectedBrands.map((e) => e.toString()).toList(),
      locationIds: _selectedLocations.map((e) => e.toString()).toList(),
      status: _selectedStatus.isEmpty ? (_projectStatus.firstOrNull?.code ?? '') : _selectedStatus,
      token: _userProvider?.token,
    );
    if (projectsResponse.status == 'success') {
      _isFiltering = _searchText.isNotEmpty || _selectedBrands.isNotEmpty || _selectedLocations.isNotEmpty || _selectedStatus.isNotEmpty;
      _searchResults.clear();
      _searchResults.addAll(projectsResponse.data!);
    }
    _isLoading = false;
  }

  Future<ServiceResponseWithData<ProjectDetail>> fetchProjectDetail(int id) async {
    final projectsResponse = await AWContentService().fetchProjectDetail(id);
    return projectsResponse;
  }

  Future<ServiceResponseWithData<List<FavouriteProjectSearchItem>>> fetchFavouriteProjects() async {
    final favouritesResponse = await AWContentService().fetchFavouriteProjects(_userProvider?.token);
    return favouritesResponse;
  }

  Future<ServiceResponse> registerInterestProject({
    required int projectId,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String priceInterest,
    required String objectiveInterest,
  }) async {
    return AWContentService().registerInterest(
      refId: projectId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      priceInterest: priceInterest,
      objectiveInterest: objectiveInterest,
    );
  }

  Future<ServiceResponseWithData<List<KeyValue>>> fetchPromotionPriceRanges() async {
    return AWContentService().fetchPriceRanges();
  }

  Future<ServiceResponseWithData<List<KeyValue>>> fetchPurposes() async {
    return AWContentService().fetchPurposes();
  }

  Future<Position?> getCurrentLocation() async {
    // เช็กว่าเปิด location service หรือยัง
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (kDebugMode) print("Location service is disabled");
      return null;
    }

    // ขอ permission
    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        if (kDebugMode) print("Permission denied");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) print("Permission denied forever");
      return null;
    }

    // ดึงตำแหน่ง
    return await Geolocator.getCurrentPosition();
  }

  Future<String?> download(String url) async {
    if (_userProvider == null) return null;
    return AWContentService().downloadFile(url: url, fileName: url.split('/').last);
  }
}
