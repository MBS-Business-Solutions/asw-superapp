import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';

class ContractProvider {
  late List<Contract> _contracts;
  List<Contract> get contracts => _contracts;

  UserProvider? _userProvider;

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  Future<List<Contract>> fetchContracts() async {
    if (_userProvider == null) return [];
    _contracts = await AWContentService.fetchContracts(_userProvider!.token!);
    _contracts.sort((a, b) => a.isDefault ? -1 : 1);
    return _contracts;
  }

  Future<ContractDetail?> fetchContractDetail(String contractId) async {
    if (_userProvider == null) return null;
    return AWContentService.fetchContractDetail(_userProvider!.token!, contractId);
  }
}
