import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_contract_service.dart';
import 'package:flutter/material.dart';

class ContractProvider {
  late List<Contract> _contracts;

  UserProvider? _userProvider;

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  Future<List<Contract>> fetchContracts(BuildContext? context) async {
    if (_userProvider == null) return [];
    _contracts = await AwContractService().fetchContracts(token: _userProvider!.token!);
    _contracts.sort((a, b) => a.isDefault ? -1 : 1);
    return _contracts;
  }

  Future<ContractDetail?> fetchContractDetail(String contractId) async {
    if (_userProvider == null) return null;
    return AwContractService().fetchContractDetail(_userProvider!.token!, contractId);
  }

  Future<OverdueDetail?> fetchOverdueDetail(String contractId) async {
    if (_userProvider == null) return null;
    return AwContractService().fetchOverdueDetail(token: _userProvider!.token!, contractId: contractId);
  }

  Future<List<PaymentDetail>?> fetchPaymentsByYear(String contractId, int year) async {
    if (_userProvider == null) return [];
    return AwContractService().fetchPaymentsByYear(token: _userProvider!.token!, contractId: contractId, year: year);
  }

  Future<ReceiptDetail?> getReceiptDetail(String contractNumber, String receiptNumber) async {
    if (_userProvider == null) return null;
    return AwContractService().fetchReceiptDetail(token: _userProvider!.token!, contractId: contractNumber, receiptNumber: receiptNumber);
  }

  Future<List<DownPaymentDetail>?> fetchDownPayments(String contractId) async {
    if (_userProvider == null) return [];
    return AwContractService().fetchTerms(token: _userProvider!.token!, contractId: contractId);
  }

  Future<List<DownPaymentTermDue>?> fetchDownPaymentTermDues(String contractId) async {
    if (_userProvider == null) return [];
    return AwContractService().fetchDownPaymentDues(token: _userProvider!.token!, contractId: contractId);
  }

  Future<QRResponse?> getQRPaymentCode({required String contractId, double amount = 0}) async {
    if (_userProvider == null) return null;
    return AwContractService().getQRPaymentCode(token: _userProvider!.token!, contractId: contractId, amount: amount);
  }

  Future<PaymentGatewayResponse?> getPaymentGatewayURL({required Contract contract, double amount = 0, String? detail, required String email}) async {
    return AwContractService().getPaymentGatewayURL(token: _userProvider!.token!, contract: contract, amount: amount, detail: detail, email: email);
  }

  Future<String?> downloadContract(String contractId, String filename) async {
    if (_userProvider == null) return null;
    final url = AwContractService().getContractURL(contractId);
    return AwContractService().downloadFile(token: _userProvider!.token!, url: url, fileName: filename);
  }

  Future<String?> downloadReceipt(String contractId, String receiptNumber, String filename) async {
    if (_userProvider == null) return null;
    final url = AwContractService().getReceiptURL(contractId, receiptNumber);
    return AwContractService().downloadFile(token: _userProvider!.token!, url: url, fileName: filename);
  }

  Future<bool> setDefaultContract(String unitId) async {
    if (_userProvider == null) return false;
    final result = await AwContractService().setDefaultContract(token: _userProvider!.token!, unitId: unitId);
    return result;
  }

  Future<ServiceResponse?> removeContract(String unitId) async {
    if (_userProvider == null) return null;
    final result = await AwContractService().removeContract(token: _userProvider!.token!, unitId: unitId);
    return result;
  }

  Future<List<ContractProject>> fetchProjects(BuildContext? context) async {
    if (_userProvider == null) return [];
    return AwContractService().fetchProjects(token: _userProvider!.token!);
  }
}
