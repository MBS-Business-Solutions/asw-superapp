import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:flutter/material.dart';

class ProjectProvider with ChangeNotifier {
  UserProvider? _userProvider;
  bool _isFiltering = false;
  bool get isFiltering => _isFiltering;

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

  Future<void> initSearchForm({bool isSearchProject = true}) async {
    // clear search filters
    _searchText = '';
    _selectedBrands.clear();
    _selectedLocations.clear();
    // load master data
    final brandsResponse = await AWContentService().fetchBrandsMasterData();
    if (brandsResponse.status == 'success') {
      _brands.clear();
      _brands.addAll(brandsResponse.data!);
    }
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
    final projectsResponse = await AWContentService().searchProjects(
      search: _searchText,
      brandIds: _selectedBrands.map((e) => e.toString()).toList(),
      locationIds: _selectedLocations.map((e) => e.toString()).toList(),
      status: _selectedStatus.isEmpty ? (_projectStatus.firstOrNull?.code ?? '') : _selectedStatus,
    );
    if (projectsResponse.status == 'success') {
      _isFiltering = _searchText.isNotEmpty || _selectedBrands.isNotEmpty || _selectedLocations.isNotEmpty || _selectedStatus.isNotEmpty;
      _searchResults.clear();
      _searchResults.addAll(projectsResponse.data!);
    }
  }

  Future<ServiceResponseWithData<ProjectDetail>> fetchProjectDetail(int id) async {
    final projectsResponse = await AWContentService().fetchProjectDetail(id);
    return projectsResponse;
  }

  Future<ServiceResponseWithData<List<FavouriteProjectSearchItem>>> fetchFavouriteProjects() async {
    final favouritesResponse = await AWContentService().fetchFavouriteProjects();
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
}
