import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/register/register_view.dart';
import 'package:AssetWise/src/features/register/user_detail_view.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/providers/register_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExistingUsersView extends StatefulWidget {
  static const String routeName = '/existing-users';
  const ExistingUsersView({super.key, this.phoneNumber, this.email});

  final String? phoneNumber;
  final String? email;

  @override
  State<ExistingUsersView> createState() => _ExistingUsersViewState();
}

class _ExistingUsersViewState extends State<ExistingUsersView> {
  final TextEditingController _searchController = TextEditingController();
  CustomerItem? _selectedCustomer;
  String? _phoneNumber;
  String? _email;
  bool _isLoginByPhone = false;

  // Sample customer data
  final List<CustomerItem> _customers = [];

  final List<CustomerItem> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _phoneNumber = widget.phoneNumber;
    _email = widget.email;

    final verifyOTPResponse = context.read<RegisterProvider>().verifyOTPResponse;
    _customers.clear();
    _customers.addAll(verifyOTPResponse?.items.map((item) {
          return CustomerItem(
            name: '${item.firstName} ${item.lastName}',
            customerId: item.remCode ?? '',
            phone: item.phone ?? '',
            isSelected: false,
            item: item,
          );
        }) ??
        []);
    if (_customers.isNotEmpty) {
      _customers.first.isSelected = true;
    }
    _isLoginByPhone = _phoneNumber != null && _phoneNumber!.isNotEmpty;

    _filteredCustomers.addAll(_customers);
    // Set initial selection
    _selectedCustomer = _filteredCustomers.firstWhere((customer) => customer.isSelected, orElse: () => _filteredCustomers.first);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectCustomer(CustomerItem? customer) {
    setState(() {
      for (var c in _customers) {
        c.isSelected = false;
      }
      customer?.isSelected = true;
      _selectedCustomer = customer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Scaffold(
        backgroundColor: mDarkBackgroundDimColor,
        appBar: AppBar(
          backgroundColor: mDarkBackgroundDimColor,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.existingUsersTitle,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLoginByPhone ? AppLocalizations.of(context)!.existingUsersSubtitlePhone(_phoneNumber ?? '') : AppLocalizations.of(context)!.existingUsersSubtitleEmail,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: mMediumPadding),
                      if (!_isLoginByPhone)
                        Padding(
                          padding: const EdgeInsets.only(bottom: mMediumPadding),
                          child: Text(
                            _email ?? '',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: mBrightPrimaryColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Text(
                        AppLocalizations.of(context)!.existingUsersSubtitleCont,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Search field
                      _buildSearchTextField(context),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Customer list section
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mDefaultPadding),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: mMediumPadding),
                          child: Text(
                            AppLocalizations.of(context)!.existingUsersSearchResult(_filteredCustomers.length),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: mLightBodyTextColor,
                            ),
                          ),
                        ),
                        if (_filteredCustomers.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: mMediumPadding),
                            child: Text(AppLocalizations.of(context)!.existingUsersInstruction,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: mLightBodyTextColor,
                                    )),
                          ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _filteredCustomers.length,
                            itemBuilder: (context, index) {
                              final customer = _filteredCustomers[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: mMediumPadding),
                                decoration: BoxDecoration(
                                  color: customer.isSelected ? mBrightPrimaryColor.withValues(alpha: 0.3) : Colors.white,
                                  border: Border.all(
                                    color: customer.isSelected ? mBrightPrimaryColor : mLightBorderTextFieldColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(
                                    customer.name,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: mLightBodyTextColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: mSmallPadding),
                                        child: Text(
                                          AppLocalizations.of(context)!.existingUsersItemCustomerId(customer.customerId),
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: Colors.grey.shade600,
                                              ),
                                        ),
                                      ),
                                      if (!_isLoginByPhone)
                                        Padding(
                                          padding: const EdgeInsets.only(top: mSmallPadding),
                                          child: Text(
                                            AppLocalizations.of(context)!.existingUsersItemPhone(customer.phone),
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: Radio<CustomerItem>(
                                    value: customer,
                                    groupValue: _selectedCustomer,
                                    fillColor: WidgetStateColor.resolveWith(
                                      (states) {
                                        if (states.contains(WidgetState.selected)) {
                                          return mBrightPrimaryColor;
                                        }
                                        return mLightBottomBarTextColor;
                                      },
                                    ),
                                    onChanged: (CustomerItem? value) {
                                      if (value != null) {
                                        _selectCustomer(value);
                                      }
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  onTap: () {
                                    _selectCustomer(customer);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 70),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, -1),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: SafeArea(
                    child: FilledButton(
                  onPressed: _selectedCustomer != null ? _processToUserForm : null,
                  child: Text(
                    AppLocalizations.of(context)!.existingUsersNextButton(_selectedCustomer?.name ?? ''),
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildSearchTextField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _filterCustomers(value);
        },
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: _isLoginByPhone ? AppLocalizations.of(context)!.existingUsersSearchHint : AppLocalizations.of(context)!.existingUsersSearchHintEmail,
          hintStyle: const TextStyle(color: Colors.white54),
          icon: const Icon(Icons.search, color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _filterCustomers(String query) {
    setState(() {
      _filteredCustomers.clear();
      if (query.isEmpty) {
        _filteredCustomers.addAll(_customers);
      } else {
        _filteredCustomers.addAll(_customers.where((customer) {
          return customer.name.toLowerCase().contains(query.toLowerCase()) ||
              customer.customerId.replaceAll('-', '').toLowerCase().contains(query.replaceAll('-', '').toLowerCase()) ||
              (!_isLoginByPhone && customer.phone.replaceAll('-', '').contains(query.replaceAll('-', '')));
        }));
      }
      _selectCustomer(_filteredCustomers.firstOrNull);
    });
  }

  void _processToUserForm() {
    CommonUtil.dismissKeyboard(context);
    if (_selectedCustomer != null) {
      context.read<RegisterProvider>().setSelectREPUser(_selectedCustomer!.item);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RegisterUserDetailView()), ModalRoute.withName(RegisterView.routeName));
    }
  }
}
