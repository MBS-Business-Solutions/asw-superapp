import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_contract_service.dart';

class ContractProvider {
  late List<Contract> _contracts;

  UserProvider? _userProvider;

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  Future<List<Contract>> fetchContracts() async {
    if (_userProvider == null) return [];
    _contracts = await AwContractService.fetchContracts(_userProvider!.token!);
    _contracts.sort((a, b) => a.isDefault ? -1 : 1);
    return _contracts;
  }

  Future<ContractDetail?> fetchContractDetail(String contractId) async {
    if (_userProvider == null) return null;
    return AwContractService.fetchContractDetail(_userProvider!.token!, contractId);
  }

  Future<OverdueDetail?> fetchOverdueDetail(String contractId) async {
    if (_userProvider == null) return null;
    return AwContractService.fetchOverdueDetail(_userProvider!.token!, contractId);
  }

  Future<List<PaymentDetail>?> fetchPaymentsByYear(String contractId, int year) async {
    if (_userProvider == null) return [];
    return AwContractService.fetchPaymentsByYear(_userProvider!.token!, contractId, year);
    // return [
    //   PaymentDetail.fromJson({"date": "2024-11-29", "amount": 5000, "type": "Cash", "status": "รอยืนยันเงิน", "receipt_number": "RV-106C001-24110002"}),
    //   PaymentDetail.fromJson({"date": "2024-11-29", "amount": 9999, "type": "QR PromptPay", "status": "ชำระแล้ว", "receipt_number": "RV-EQC019-19100156"}),
    // ];
  }

  Future<ReceiptDetail?> getReceiptDetail(String contractNumber, String receiptNumber) async {
    if (_userProvider == null) return null;
    return AwContractService.fetchReceiptDetail(_userProvider!.token!, contractNumber, receiptNumber);
  }

  Future<List<DownPaymentDetail>?> fetchDownPayments(String contractId) async {
    if (_userProvider == null) return [];
    return AwContractService.fetchTerms(_userProvider!.token!, contractId);
  }

  Future<List<DownPaymentTermDue>?> fetchDownPaymentTermDues(String contractId) async {
    if (_userProvider == null) return [];
    return AwContractService.fetchDownPaymentDues(_userProvider!.token!, contractId);
  }

  Future<QRResponse?> getQRPaymentCode({required String contractId, double amount = 0}) async {
    if (_userProvider == null) return null;
    return AwContractService.getQRPaymentCode(_userProvider!.token!, contractId: contractId, amount: amount);
  }

  Future<PaymentGatewayResponse?> getPaymentGatewayURL({required Contract contract, double amount = 0, String? detail, required String email}) async {
    return AwContractService.getPaymentGatewayURL(token: _userProvider!.token!, contract: contract, amount: amount, detail: detail, email: email);
  }

  Future<String?> downloadContract(String contractId, String filename) async {
    if (_userProvider == null) return null;
    final url = AwContractService.getContractURL(contractId);
    return AwContractService.downloadFile(_userProvider!.token!, url, filename);
  }

  Future<bool> setDefaultContract(String unitId) async {
    if (_userProvider == null) return false;
    final result = await AwContractService.setDefaultContract(_userProvider!.token!, unitId);
    return result;
  }

  Future<ServiceResponse?> removeContract(String unitId) async {
    if (_userProvider == null) return null;
    final result = await AwContractService.removeContract(_userProvider!.token!, unitId);
    return result;
  }

  Future<List<ContractProject>> fetchProjects() async {
    if (_userProvider == null) return [];
    return AwContractService.fetchProjects(_userProvider!.token!);
  }
}
