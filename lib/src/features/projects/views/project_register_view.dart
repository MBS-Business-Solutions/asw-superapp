import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/projects/views/project_register_done.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/aw_dropdownform.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProjectRegisterView extends StatefulWidget {
  const ProjectRegisterView({super.key, required this.projectItemDetail, required this.projectId});
  final ProjectDetail projectItemDetail;
  final int projectId;

  @override
  State<ProjectRegisterView> createState() => _ProjectRegisterViewState();
}

class _ProjectRegisterViewState extends State<ProjectRegisterView> {
  final _nameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _priceRangeKeyValues = <KeyValue>[];
  int? _selectedPriceRangeKeyValue;
  final _purposeKeyValues = <KeyValue>[];
  int? _selectedPurposeKeyValue;
  bool _isEditable = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initForm();
    });
    super.initState();
  }

  Future<void> _initForm() async {
    final userProvider = context.read<UserProvider>();
    if (userProvider.isAuthenticated) {
      _isEditable = false;
      _nameTextController.text = userProvider.userInformation?.firstName ?? '';
      _lastNameTextController.text = userProvider.userInformation?.lastName ?? '';
      _phoneTextController.text = userProvider.userInformation?.phone ?? '';
      _emailTextController.text = userProvider.userInformation?.email ?? '';
    }

    final projectProvider = context.read<ProjectProvider>();
    await projectProvider.fetchPromotionPriceRanges().then((value) {
      if (value.status == 'success') {
        _priceRangeKeyValues.addAll(value.data ?? []);
        _selectedPriceRangeKeyValue = _priceRangeKeyValues.first.id;
      }
    });
    await projectProvider.fetchPurposes().then((value) {
      if (value.status == 'success') {
        _purposeKeyValues.addAll(value.data ?? []);
        _selectedPurposeKeyValue = _purposeKeyValues.first.id;
      }
    });
    setState(() {});
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
          title: Text(widget.projectItemDetail.name),
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
                    isEditable: _isEditable,
                    controller: _nameTextController,
                    label: AppLocalizations.of(context)!.projectRegisterNameField,
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
                    isEditable: _isEditable,
                    controller: _lastNameTextController,
                    label: AppLocalizations.of(context)!.projectRegisterLastNameField,
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
                    isEditable: _isEditable,
                    controller: _phoneTextController,
                    label: AppLocalizations.of(context)!.projectRegisterPhoneField,
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
                    isEditable: _isEditable,
                    controller: _emailTextController,
                    label: AppLocalizations.of(context)!.projectRegisterEmailField,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.errorFieldRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: mScreenEdgeInsetValue),
                  // Price Range
                  AwDropdownform<int>(
                    initialValue: _selectedPriceRangeKeyValue,
                    itemBuilder: (context, index) => _priceRangeKeyValues[index].id,
                    titleBuilder: (context, index) => Text(_priceRangeKeyValues[index].value, style: Theme.of(context).textTheme.bodyLarge),
                    itemCount: _priceRangeKeyValues.length,
                    label: AppLocalizations.of(context)!.projectRegisterPriceRange,
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
                    label: AppLocalizations.of(context)!.projectRegisterPurpose,
                    onChanged: (dynamic purposeId) {
                      _selectedPriceRangeKeyValue = purposeId;
                    },
                  ),
                  const SizedBox(height: mScreenEdgeInsetValue),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _register(context),
                      child: Text(AppLocalizations.of(context)!.projectRegisterRegister),
                    ),
                  ),
                  const SafeArea(
                      child: SizedBox(
                    height: mScreenEdgeInsetValue,
                  )),
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
    final projectProvider = context.read<ProjectProvider>();
    final registerResult = await projectProvider.registerInterestProject(
      projectId: widget.projectId,
      firstName: _nameTextController.text,
      lastName: _lastNameTextController.text,
      phone: _phoneTextController.text,
      email: _emailTextController.text,
      priceInterest: _priceRangeKeyValues.firstWhere((element) => element.id == _selectedPriceRangeKeyValue).value,
      objectiveInterest: _purposeKeyValues.firstWhere((element) => element.id == _selectedPurposeKeyValue).value,
    );
    if (registerResult.status == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          registerResult.message ?? AppLocalizations.of(context)!.errorUnableToProcess,
        ),
      ));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProjectRegisterDone()));
  }
}
