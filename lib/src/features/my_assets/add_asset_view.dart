import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/verify_otp/verify_otp_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/providers/verify_otp_provider.dart';
import 'package:AssetWise/src/widgets/aw_dropdownform.dart';
import 'package:AssetWise/src/widgets/aw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AddAssetView extends StatefulWidget {
  const AddAssetView({super.key});

  @override
  State<AddAssetView> createState() => _AddAssetViewState();
}

class _AddAssetViewState extends State<AddAssetView> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProject;
  late Future<List<ContractProject>> _fetchProjectsFuture;
  String? _errorMessage;
  final _unitController = TextEditingController();
  final _last4IdController = TextEditingController();

  @override
  void initState() {
    _fetchProjectsFuture = context.read<ContractProvider>().fetchProjects(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: const SizedBox(),
              actions: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            body: FutureBuilder(
                future: _fetchProjectsFuture,
                builder: (context, sanpshot) {
                  if (sanpshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final projects = sanpshot.data as List<ContractProject>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.addAssetTitle,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          AppLocalizations.of(context)!.addAssetInstruction,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: mDefaultPadding),
                        AwDropdownform<String>(
                          itemBuilder: (context, index) => projects[index].id,
                          titleBuilder: (context, index) => Text(projects[index].name),
                          itemCount: projects.length,
                          label: AppLocalizations.of(context)!.addAssetProject,
                          onChanged: (dynamic project) {
                            _selectedProject = project;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.addAssetProjectRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: mDefaultPadding),
                        AwTextFormField(
                          controller: _unitController,
                          label: AppLocalizations.of(context)!.addAssetUnit,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.addAssetUnitRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: mDefaultPadding),
                        AwTextFormField(
                          controller: _last4IdController,
                          label: AppLocalizations.of(context)!.addAssetLast4Id,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 4,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.addAssetLast4IdRequired;
                            }
                            return null;
                          },
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: mDefaultPadding),
                          Text(_errorMessage ?? 'Error message', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: mRedColor), textAlign: TextAlign.center),
                        ],
                        const SizedBox(height: mDefaultPadding),
                        SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _submit(), child: const Text('ถัดไป'))),
                      ],
                    ),
                  );
                })),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final otp = await context.read<VerifyOtpProvider>().sendOTPForUnitAdd(
            projectCode: _selectedProject!, //'W8C001',
            unitNumber: _unitController.text, //'78/245',
            last4Id: _last4IdController.text, //'7940',
          );
      if (otp != null) {
        if (otp.success != 'success') {
          setState(() {
            _errorMessage = otp.message;
          });
          return;
        }
        final otpVerified = await Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifyOTPView(action: OTPFor.addUnit))) as OTPAddUnitResponse?;
        if (otpVerified != null) {
          Navigator.pushReplacementNamed(context, ContractsView.routeName, arguments: {'linkId': otpVerified.contractId});
        }
      }
    }
  }
}
