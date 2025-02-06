import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';

class DashboardProvider {
  List<ImageContent> _banners = [];
  List<ImageContent> get banners => _banners;
  List<Project> _suggestProjects = [];
  List<Project> get suggestProjects => _suggestProjects;

  Future<void> reload() async {
    await Future.wait([
      _fetchProjects(),
      _fetchBanners(),
    ]);
  }

  Future<void> _fetchProjects() async {
    _suggestProjects = await AWContentService.fetchProjects();
  }

  Future<void> _fetchBanners() async {
    _banners = await AWContentService.fetchBanners();
  }
}
