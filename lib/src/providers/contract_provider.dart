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

  Future<OverdueDetail?> fetchOverdueDetail(String contractId) async {
    if (_userProvider == null) return null;
    return AWContentService.fetchOverdueDetail(_userProvider!.token!, contractId);
  }

  Future<List<PaymentDetail>?> fetchPaymentsByYear(String contractId, int year) async {
    if (_userProvider == null) return [];
    // return AWContentService.fetchPaymentsByYear(_userProvider!.token!, contractId, year);
    return [
      PaymentDetail.fromJson({"date": "2024-11-29", "amount": 5000, "type": "Cash", "status": "รอยืนยันเงิน", "receipt_number": "RV-106C001-24110002"}),
      PaymentDetail.fromJson({"date": "2024-11-29", "amount": 9999, "type": "QR PromptPay", "status": "ชำระแล้ว", "receipt_number": "RV-EQC019-19100156"}),
    ];
  }

  Future<ReceiptDetail?> getReceiptDetail(String contractNumber, String receiptNumber) async {
    if (_userProvider == null) return null;
    return AWContentService.fetchReceiptDetail(_userProvider!.token!, contractNumber, receiptNumber);
  }
}
