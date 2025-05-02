import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/promotions/views/promotion_register_done.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/promotion_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/aw_dropdownform.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PromotionRegisterView extends StatefulWidget {
  const PromotionRegisterView({super.key, required this.promotionItemDetail});
  final PromotionItemDetail promotionItemDetail;

  @override
  State<PromotionRegisterView> createState() => _PromotionRegisterViewState();
}

class _PromotionRegisterViewState extends State<PromotionRegisterView> {
  final _nameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _priceRangeKeyValues = <KeyValue>[];
  int? _selectedPriceRangeKeyValue;
  final _purposeKeyValues = <KeyValue>[];
  int? _selectedPurposeKeyValue;
  final _projectsValues = <ParticipanProject>[];
  int? _selectedProjectKeyValue;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initForm();
    });
    super.initState();
  }

  Future<void> _initForm() async {
    try {
      final userProvider = context.read<UserProvider>();
      if (userProvider.isAuthenticated) {
        _nameTextController.text = userProvider.userInformation?.firstName ?? '';
        _lastNameTextController.text = userProvider.userInformation?.lastName ?? '';
        _phoneTextController.text = userProvider.userInformation?.phone ?? '';
        _emailTextController.text = userProvider.userInformation?.email ?? '';
      }

      final promotionProvider = context.read<PromotionProvider>();
      final prices = await promotionProvider.fetchPromotionPriceRanges();
      if (prices.status == 'success') {
        _priceRangeKeyValues.addAll(prices.data ?? []);
        _selectedPriceRangeKeyValue = _priceRangeKeyValues.first.id;
      }
      final purposes = await promotionProvider.fetchPurposes();
      if (purposes.status == 'success') {
        _purposeKeyValues.addAll(purposes.data ?? []);
        _selectedPurposeKeyValue = _purposeKeyValues.first.id;
      }
      if (widget.promotionItemDetail.participantProjects != null && widget.promotionItemDetail.participantProjects!.isNotEmpty) {
        _selectedProjectKeyValue = widget.promotionItemDetail.participantProjects!.first.id;
      }
      setState(() {});
    } catch (e) {
      // Handle any errors that occur during the initialization
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.of(context)!.errorUnableToProcess,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(widget.promotionItemDetail.name),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue, top: mScreenEdgeInsetValue),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Name
                  AwTextFormField(
                    controller: _nameTextController,
                    label: AppLocalizations.of(context)!.promotionsNameField,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.errorFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: mScreenEdgeInsetValue),
                  // Last Name
                  AwTextFormField(
                    controller: _lastNameTextController,
                    label: AppLocalizations.of(context)!.promotionsLastNameField,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.errorFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: mScreenEdgeInsetValue),
                  // Phone
                  AwTextFormField(
                    controller: _phoneTextController,
                    label: AppLocalizations.of(context)!.promotionsPhoneField,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.errorFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: mScreenEdgeInsetValue),
                  // Email
                  AwTextFormField(
                    controller: _emailTextController,
                    label: AppLocalizations.of(context)!.promotionsEmailField,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.errorFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: mScreenEdgeInsetValue),
                  // Participate Project
                  if (_projectsValues.isNotEmpty) ...[
                    AwDropdownform<int>(
                      initialValue: _selectedProjectKeyValue,
                      itemBuilder: (context, index) => _projectsValues[index].id,
                      titleBuilder: (context, index) => Text(_projectsValues[index].name, style: Theme.of(context).textTheme.bodyLarge),
                      itemCount: _projectsValues.length,
                      label: AppLocalizations.of(context)!.promotionsProject,
                      onChanged: (dynamic projectId) {
                        _selectedProjectKeyValue = projectId;
                      },
                    ),
                    const SizedBox(height: mScreenEdgeInsetValue),
                  ],
                  // Price Range
                  AwDropdownform<int>(
                    initialValue: _selectedPriceRangeKeyValue,
                    itemBuilder: (context, index) => _priceRangeKeyValues[index].id,
                    titleBuilder: (context, index) => Text(_priceRangeKeyValues[index].value, style: Theme.of(context).textTheme.bodyLarge),
                    itemCount: _priceRangeKeyValues.length,
                    label: AppLocalizations.of(context)!.promotionsPriceRange,
                    onChanged: (dynamic priceId) {
                      _selectedPriceRangeKeyValue = priceId;
                    },
                  ),
                  const SizedBox(height: mScreenEdgeInsetValue),
                  // Purpose
                  AwDropdownform<int>(
                    initialValue: _selectedPurposeKeyValue,
                    itemBuilder: (context, index) => _purposeKeyValues[index].id,
                    titleBuilder: (context, index) => Text(_purposeKeyValues[index].value, style: Theme.of(context).textTheme.bodyLarge),
                    itemCount: _purposeKeyValues.length,
                    label: AppLocalizations.of(context)!.promotionsPurpose,
                    onChanged: (dynamic purposeId) {
                      _selectedPriceRangeKeyValue = purposeId;
                    },
                  ),
                  const SizedBox(height: mScreenEdgeInsetValue),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _register(context),
                      child: Text(AppLocalizations.of(context)!.promotionsRegister),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    CommonUtil.dismissKeyboard(context);
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    final promotionProvider = context.read<PromotionProvider>();
    final registerResult = await promotionProvider.registerInterestPromotion(
      promotionId: widget.promotionItemDetail.id,
      firstName: _nameTextController.text,
      lastName: _lastNameTextController.text,
      phone: _phoneTextController.text,
      email: _emailTextController.text,
      priceInterest: _priceRangeKeyValues.firstWhere((element) => element.id == _selectedPriceRangeKeyValue).value,
      objectiveInterest: _purposeKeyValues.firstWhere((element) => element.id == _selectedPurposeKeyValue).value,
      projectId: _selectedProjectKeyValue!,
    );
    if (registerResult.status == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          registerResult.message ?? AppLocalizations.of(context)!.errorUnableToProcess,
        ),
      ));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PromotionRegisterDone()));
  }
}
