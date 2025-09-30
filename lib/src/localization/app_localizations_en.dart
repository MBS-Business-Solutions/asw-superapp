// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AssetWise';

  @override
  String get actionButtonNext => 'Next';

  @override
  String get actionButtonCancel => 'Cancel';

  @override
  String get errorUnableToProcess => 'Unavailable Please try again.';

  @override
  String get errorUnableToDownloadContract =>
      'Unable to download contract documents Please try again.';

  @override
  String get errorFieldRequired => 'This field is required.';

  @override
  String get errorNoData => 'No data found.';

  @override
  String get errorInvalidOTP => 'Incorrect OTP number.';

  @override
  String get errorInvalidPIN => 'Please enter the PIN code correctly.';

  @override
  String get errorComingSoon => 'Service not yet available.';

  @override
  String get bahtUnit => 'baht';

  @override
  String priceFormat(double price) {
    final intl.NumberFormat priceNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String priceString = priceNumberFormat.format(price);

    return '$priceString';
  }

  @override
  String priceFormatDouble(double price) {
    final intl.NumberFormat priceNumberFormat = intl.NumberFormat.currency(
        locale: localeName, decimalDigits: 2, customPattern: '#,##0.00');
    final String priceString = priceNumberFormat.format(price);

    return '$priceString';
  }

  @override
  String priceFormatBaht(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString baht';
  }

  @override
  String priceFormatBahtDouble(double amount) {
    final intl.NumberFormat amountNumberFormat = intl.NumberFormat.currency(
        locale: localeName, decimalDigits: 2, customPattern: '#,##0.00');
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString baht';
  }

  @override
  String get bottomBarHome => 'Home';

  @override
  String get bottomBarService => 'Services';

  @override
  String get bottomBarChat => 'Chat';

  @override
  String get bottomBarMenu => 'Menu';

  @override
  String get bottomBarCalendar => 'Calendar';

  @override
  String get bottomBarPrivilege => 'Privilege';

  @override
  String get bottomBarMyQR => 'My QR';

  @override
  String get bottomBarProfile => 'Profile';

  @override
  String get bottomBarMyUnit => 'My Unit';

  @override
  String get registerUserName => 'Enter your mobile number or email address';

  @override
  String get registerUserNameHint =>
      'Enter your mobile phone number or email to apply for membership.';

  @override
  String get registerUserNameLabel => 'Mobile Number/email';

  @override
  String get registerMobileLabel => 'Mobile Number';

  @override
  String get registerMobile => 'Enter your mobile number';

  @override
  String get registerMobileHint =>
      'Provide your mobile number to register as a member';

  @override
  String get registerEMailLabel => 'Email';

  @override
  String get registerEMail => 'Enter Email';

  @override
  String get registerEMailHint => 'Please enter your email address to register';

  @override
  String get registerLoginByEmail => 'Log in with Email';

  @override
  String get registerLast4Digits => 'Last 4 digits of ID card';

  @override
  String get registerIsResident => 'Existing customer';

  @override
  String get registerNext => 'Next';

  @override
  String get registerInvalidData => 'Please check your input.';

  @override
  String get registerInvalidResident =>
      'Please enter your ID card number to match your registered mobile number.';

  @override
  String get registerInvalidUser =>
      'Please enter your ID card number to match your registered mobile number/email address.';

  @override
  String get registerError => 'Unable to process. Please try again.';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get otpTitle => 'Enter OTP';

  @override
  String get otpRequestIsResident => 'Existing customer';

  @override
  String get otpRequestLast4Digits => 'Last 4 digits of ID card';

  @override
  String get otpRequestAgain => 'Request code again.';

  @override
  String get otpRequestCountdownPrefix => 'Request code again in';

  @override
  String otpRequestCountdown(int time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: '$time seconds',
      one: '1 second',
      zero: '',
    );
    return '$_temp0';
  }

  @override
  String otpInstruction(String sendto, String refCode) {
    return 'Enter the 6 digits sent to\n$sendto REF : $refCode';
  }

  @override
  String get userDetailTitle => 'Enter Name - Surname';

  @override
  String get userDetailInstruction =>
      'Provide your details to access the service';

  @override
  String get userDetailFirstName => 'First Name *';

  @override
  String get userDetailLastName => 'Last Name *';

  @override
  String get userDetailMobile => 'Mobile';

  @override
  String get userDetailEmail => 'Email';

  @override
  String get userDetailCitizenId => 'National ID / Passport No.';

  @override
  String get userDetailInvalidFirstName =>
      'Please enter your first name correctly without using special characters.';

  @override
  String get userDetailInvalidLastName =>
      'Please enter your last name correctly without using special characters.';

  @override
  String get userDetailInvalidEmail =>
      'Please enter a valid E-mail address in the correct format.';

  @override
  String get userDetailInvalidPhone => 'Please enter a 10-digit mobile number.';

  @override
  String get consentAgree => 'Accept';

  @override
  String get consentDisagree => 'Don\'t accept';

  @override
  String get consentAgreeNext => 'Consent';

  @override
  String get consentAgreeAll => 'Consent to all';

  @override
  String setPinSetPin(int digits) {
    return 'Set a $digits-digit PIN';
  }

  @override
  String get setPinConfirm => 'Enter the PIN code again.';

  @override
  String setPinInstruction(int digits) {
    return 'Please enter a $digits-digit PIN to set up your password';
  }

  @override
  String get setPinSkipInstruction =>
      'You can skip this step.\nYou will be able to access the system without having to enter a PIN.';

  @override
  String get setPinSkip => 'Skip';

  @override
  String get setPinError => 'Please start setting a new PIN code again.';

  @override
  String get changeLanguageTitle => 'Change Language';

  @override
  String get changeLanguageCurrentLang => 'Current Language';

  @override
  String get changeLanguageLanguage => 'Language';

  @override
  String get dashboardMainSectionFavourite => 'Favorite';

  @override
  String get dashboardMainSectionFavouriteMore => 'All menus';

  @override
  String get dashboardMainSectionNotification => 'Notifications';

  @override
  String get dashboardMainSectionRecommended => 'Recommended projects';

  @override
  String get dashboardMainSectionRecommendedDetail =>
      'We are committed to designing homes. For the happiness of the people Taking into account lifestyle and the lifestyle of each person is different Allowing you to live your life the way you want.';

  @override
  String profileNameFormat(String firstName, String lastName) {
    return '$firstName $lastName';
  }

  @override
  String get profileRegisterBuyer => 'Register Buyer';

  @override
  String get profileDarkMode => 'Dark Mode';

  @override
  String get profileMyInfo => 'My Information';

  @override
  String get profilePhoneNumber => 'Phone Number';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileMyAsset => 'My Units';

  @override
  String profileMyAssetSum(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'units',
      one: 'unit',
    );
    return '$count $_temp0';
  }

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileChangeLanguage => 'Change Language';

  @override
  String get profileSettings => 'Account Settings';

  @override
  String get profilePersonalInfo => 'Manage Personal Information';

  @override
  String get profilePin => 'PIN Code';

  @override
  String get profileDeleteAccount => 'Deactivate or Delete Account';

  @override
  String get profileAbout => 'About Assetwise';

  @override
  String get profileAuthen => 'Login';

  @override
  String get profileExit => 'Exit';

  @override
  String get profileLogout => 'Log Out';

  @override
  String get contractsViewContract => 'Contract Details';

  @override
  String get overdueDetailAmountLabel => 'Make Payment';

  @override
  String get overdueDetailDueDateLabel => 'Due Date';

  @override
  String get overdueDetailCreditNumberLabel => 'Deduct from Account';

  @override
  String get overdueDetailDebitDateLabel => 'Deduction Date';

  @override
  String get overdueDetailPayment => 'Pay';

  @override
  String get overdueDetailViewDetail => 'View Details';

  @override
  String get paymentHistoryTitle => 'Payment History';

  @override
  String get contractDetailTitle => 'Contract Details';

  @override
  String get contractDetailContractDate => 'Contract Date';

  @override
  String get contractDetailSigningDate => 'Contract Date';

  @override
  String get contractDetailEstimatedTransferDate => 'Estimated Transfer Date';

  @override
  String get contractDetailContractValueTitle => 'Contract Value';

  @override
  String get contractDetailBookingSellingPrice => 'Selling Price';

  @override
  String get contractDetailBookingDiscountPrice => 'Discount';

  @override
  String get contractDetailBookingDiscountAtTransferPrice =>
      'Discount on transfer date';

  @override
  String get contractDetailBookingNetPrice => 'Net Price';

  @override
  String get contractDetailBookingAmount => 'Booking';

  @override
  String get contractDetailContractAmount => 'Contract';

  @override
  String get contractDetailDownAmount => 'Down payment';

  @override
  String get contractDetailDownAmountDetails => 'details';

  @override
  String get contractDetailTransferAmount => 'Transfer';

  @override
  String get contractDetailPaymentTitle => 'Payment Details';

  @override
  String get contractDetailPaymentAmount => 'Payment Amount';

  @override
  String get contractDetailRemainDownAmount => 'Remaining Down Payment';

  @override
  String get contractDetailRemainHousePayment =>
      'Total Remaining House Payment';

  @override
  String get contractDetailFreebiesTitle => 'Freebies and Discounts List';

  @override
  String get contractDetailDownloadDoc => 'Download Contract Documents';

  @override
  String get contractDetailDownloadEDoc => 'Download e-contract';

  @override
  String get receiptViewTitle => 'Receipt Details';

  @override
  String get receiptViewSuccess => 'Transaction Successful';

  @override
  String get receiptViewPaymentType => 'Payment Method';

  @override
  String get receiptViewDate => 'Transaction Date';

  @override
  String get receiptViewRef1 => 'Item number';

  @override
  String get receiptViewRef2 => 'Reference Number';

  @override
  String get receiptViewRemark => 'Notes';

  @override
  String get receiptViewDue => 'Due Date';

  @override
  String get receiptViewViewReceipt => 'View Receipt';

  @override
  String get receiptViewFileTitle => 'Receipt';

  @override
  String get receiptViewFileDownload => 'Download Receipt';

  @override
  String get downHistoryViewTitle => 'Down payment details';

  @override
  String get overduesViewTitle => 'Amount Due';

  @override
  String get overduesViewSumLabel => 'Amount Due';

  @override
  String get overduesViewMakePayment => 'Payment';

  @override
  String get paymentChannelViewPaymentTitle => 'Payment';

  @override
  String get paymentChannelViewCreditChannel => 'Credit/Debit Card';

  @override
  String get paymentChannelViewQRChannel => 'QR Code';

  @override
  String get paymentChannelViewTotalAmount => 'Total Amount Due';

  @override
  String get paymentChannelViewDue => 'Due Date';

  @override
  String get paymentChannelViewPayment => 'Payment';

  @override
  String get qrViewTitle => 'QR Code';

  @override
  String get qrViewProject => 'Project';

  @override
  String get qrViewUnit => 'Unit';

  @override
  String get qrViewTotal => 'Total Payment';

  @override
  String get qrViewPromptPayInstruction => 'How to pay with PromptPay QR Code';

  @override
  String get qrViewPromptPayInstruction1 =>
      '1. Open your banking app and select the \"Scan\" menu.';

  @override
  String get qrViewPromptPayInstruction2 => '2. Scan the store\'s QR Code.';

  @override
  String get qrViewPromptPayInstruction3 =>
      '3. Select your account, enter the amount, and tap \"Confirm\".';

  @override
  String get qrViewPromptPayInstruction4 => '4. Confirm';

  @override
  String get qrViewPromptPayDownload => 'Download QR Code';

  @override
  String get qrViewPromptPayDone => 'Completed';

  @override
  String get qrViewPromptSavedToGallery => 'QR Code saved to gallery';

  @override
  String get pinEntryTitle => 'Enter PIN';

  @override
  String pinEntryInstruction(int digits) {
    return 'Enter a $digits-digit PIN to log in.';
  }

  @override
  String get pinEntryForget => 'Forgot PIN code';

  @override
  String get otpRequestActionResetPin =>
      'verify your identity for setting up a PIN.';

  @override
  String get otpRequestActionFirstSetPin =>
      'verify your identity every time you log in in the future.';

  @override
  String get otpRequestActionReLogin => 'register as a member.';

  @override
  String get otpRequestMobileLabel => 'Mobile Number';

  @override
  String get otpRequestMobile => 'Enter Mobile Number';

  @override
  String otpRequestMobileHint(String action) {
    return 'Provide your mobile number to $action';
  }

  @override
  String get otpRequestEMailLabel => 'Email';

  @override
  String get otpRequestEMail => 'Enter Email';

  @override
  String otpRequestEMailHint(String action) {
    return 'Please enter your email address to $action';
  }

  @override
  String get otpRequestLoginByEmail => 'Log in with Email';

  @override
  String get otpRequestNext => 'Next';

  @override
  String get otpRequestInvalidData =>
      'Please fill in all information completely.';

  @override
  String get otpRequestInvalidMobile =>
      'Please enter your ID card number to match your registered mobile number.';

  @override
  String get otpRequestInvalidEmail =>
      'Please enter your ID card number to match your registered email address.';

  @override
  String get otpRequestInvalidUser =>
      'Please enter your ID card number to match your registered mobile number/email address.';

  @override
  String get logoutConfirmationTitle => 'Do you want to log out?';

  @override
  String logoutConfirmationMessage(Object userName) {
    return 'You are about to log out of $userName';
  }

  @override
  String get logoutConfirmationBottomTitle =>
      'Are you sure you want to log out?';

  @override
  String get logoutConfirmationOKButton => 'Log out';

  @override
  String get closeAppConfirmationTitle => 'Do you want to exit?';

  @override
  String get closeAppConfirmationMessage =>
      'You can re-log in\n by verifying your identity with a PIN.';

  @override
  String get closeAppConfirmationOKButton => 'Exit';

  @override
  String get emailOldValueTitle => 'Edit Email';

  @override
  String get emailOldValueInstructions =>
      'If you wish to update your email here, all accounts linked to this user account will also be updated accordingly.';

  @override
  String get emailOldValueTextLabel => 'E-mail';

  @override
  String get emailOldValueAction => 'Change E-mail';

  @override
  String get emailNewValueTitle => 'Enter a New E-mail';

  @override
  String get emailNewValueInstructions =>
      'If you wish to change your E-mail, please submit a request so that our staff can contact you later.';

  @override
  String get emailNewValueTextLabel => 'Enter a New E-mail';

  @override
  String get emailNewValueAction => 'Submit E-mail Change Request';

  @override
  String get emailChangeSuccessTitle => 'Request Submitted';

  @override
  String get emailChangeSuccessIntructions =>
      'You will be contacted within 24 hours.';

  @override
  String get emailChangeSuccessAction => 'Go back to Home';

  @override
  String get phoneOldValueTitle => 'Phone Number';

  @override
  String get phoneOldValueInstructions =>
      'If you wish to change your phone number, please press \"Send Request\" to allow our staff to contact you later.';

  @override
  String get phoneOldValueTextLabel => 'Phone Number';

  @override
  String get phoneOldValueAction => 'Change number';

  @override
  String get phoneNewValueTitle => 'Specify a new phone number';

  @override
  String get phoneNewValueInstructions =>
      'If you wish to change your phone number, please press \"Send Request\" to allow our staff to contact you later.';

  @override
  String get phoneNewValueTextLabel => 'Specify a new phone number';

  @override
  String get phoneNewValueAction => 'Submit a Phone Number Change Request';

  @override
  String get phoneChangeSuccessTitle => 'Request Submitted';

  @override
  String get phoneChangeSuccessIntructions =>
      'You will be contacted within 24 hours.';

  @override
  String get phoneChangeSuccessAction => 'Go back to Home';

  @override
  String get notificationTitle => 'All Notifications';

  @override
  String get notificationAll => 'All';

  @override
  String get notificationPayment => 'Payment';

  @override
  String get notificationPromotion => 'Promotion';

  @override
  String get notificationHotDeal => 'Hot Deal';

  @override
  String get notificationNews => 'News';

  @override
  String get notificationReadAll => 'Mark All as Read';

  @override
  String get aboutAssetWiseTitle => 'About Assetwise';

  @override
  String aboutAssetWiseVersion(Object build, Object version) {
    return 'Version $version ($build)';
  }

  @override
  String get aboutAssetWiseCopyright => 'ⓒ 2025 บริษัท แอสเซทไวส์ จำกัด';

  @override
  String get aboutAssetWiseTermOfService => 'Terms of Service';

  @override
  String get aboutAssetWisePrivacyPolicy => 'Privacy Policy';

  @override
  String get aboutAssetWiseSecurityPolicy => 'Security Policy';

  @override
  String get registerBuyerTitle => 'Buyer Registration';

  @override
  String get registerBuyerHeader => 'Verify Identity';

  @override
  String get registerBuyerInstruction =>
      'Please verify your identity with your National ID number or Passport number for security purposes.';

  @override
  String get registerBuyerIdentifier => 'National ID / Passport No.';

  @override
  String get registerBuyerRegister => 'Register';

  @override
  String get registerBuyerInvalidId =>
      'Please fill in your ID card number completely, 13 digits';

  @override
  String get myAssetTitle => 'My Home';

  @override
  String myAssetSum(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Unit',
      one: '1 Unit',
      zero: '',
    );
    return ' $_temp0';
  }

  @override
  String get myAssetAdd => 'Add Home';

  @override
  String get myAssetViewDetail => 'View Details';

  @override
  String get myAssetSetDefault => 'Set as Default';

  @override
  String get myAssetDelete => 'Delete house';

  @override
  String get myAssetDeleteConfirmation => 'Do you want to delete the house?';

  @override
  String myAssetDeleteDetail(Object unitNumber) {
    return 'If you want to delete house number $unitNumber,\nall information will be removed from the system.';
  }

  @override
  String get myAssetDeleteDelete => 'Delete';

  @override
  String get myAssetDeleteCancel => 'Cancel';

  @override
  String get myAssetDeleteSuccess => 'Data deleted successfully';

  @override
  String get myAssetDefault => 'Default';

  @override
  String get addAssetTitle => 'Add Home';

  @override
  String get addAssetInstruction =>
      'Please provide your details for service access.';

  @override
  String get addAssetProject => 'Project*';

  @override
  String get addAssetUnit => 'House Number / Unit Number*';

  @override
  String get addAssetLast4Id => 'Last 4 digits of ID Card*';

  @override
  String get addAssetProjectRequired => 'Please specify the project.';

  @override
  String get addAssetUnitRequired =>
      'Please specify your house number / unit number.';

  @override
  String get addAssetLast4IdRequired =>
      'Please enter the last 4 digits of your national ID card number.';

  @override
  String get managePersonalInfoTitle => 'Manage Personal Information';

  @override
  String get managePersonalInfoCollectionPersonalInfo =>
      'Collection and Use of Personal Information';

  @override
  String get managePersonalInfoMarketingPurpose =>
      'Consent for Marketing Purposes';

  @override
  String get managePersonalInfoDisclosureMarketing =>
      'Consent for Disclosure of Information for Marketing Purposes';

  @override
  String get managePersonalInfoGiveConsent => 'Give Consent';

  @override
  String lastUpdated(Object date) {
    return 'Last updated $date';
  }

  @override
  String get unableToPayHeading => 'Payment is not available at this time.';

  @override
  String get unableToPayBack => 'Return to contract page';

  @override
  String get mapTitle => 'Map';

  @override
  String get mapSearchHint => 'Search';

  @override
  String mapSearchCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ผลการค้นหา : $count รายการ',
      one: 'ผลการค้นหา : 1 รายการ',
    );
    return '$_temp0';
  }

  @override
  String get mapShowProjectDetail => 'View project details';

  @override
  String get mapNavigate => 'Navigate';

  @override
  String mapDistanceKM(Object distance) {
    return '$distance km.';
  }

  @override
  String get projectsTitle => 'Projects';

  @override
  String get projectsSearchHint => 'Search for project name';

  @override
  String get projectsSeeOnMap => 'View on Map';

  @override
  String get projectsFilterTitle => 'Filter';

  @override
  String get projectsBrands => 'Brand';

  @override
  String get projectsLocations => 'Location';

  @override
  String get projectsClearFilter => 'Clear Filter';

  @override
  String get projectsSearch => 'Search';

  @override
  String get projectsSearchNoResult => 'No search results found';

  @override
  String get projectsSearchTryAgain => 'Please try again';

  @override
  String projectsSearchCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ผลการค้นหา : $count รายการ',
      one: 'ผลการค้นหา : 1 รายการ',
    );
    return '$_temp0';
  }

  @override
  String get projectDetailTitle => 'Project Details';

  @override
  String get projectDetailSectionDetail => 'Details';

  @override
  String get projectDetailSectionMap => 'Map';

  @override
  String get projectDetailSectionPlan => 'Plan';

  @override
  String get projectDetailSectionGallery => 'Gallery';

  @override
  String get projectDetailSectionAdvertisement => 'Brochure';

  @override
  String get projectDetailSectionVideo => 'Video';

  @override
  String get projectDetailProgressTitle => 'Progress';

  @override
  String projectDetailProgressUpdated(Object date) {
    return 'วันที่อัปเดต : $date';
  }

  @override
  String get projectDetailProgressStructure => 'Structure';

  @override
  String get projectDetailProgressFinishing => 'Architecture';

  @override
  String get projectDetailProgressComplete => 'System Installation';

  @override
  String get projectDetailProgressConstruction => 'Piling';

  @override
  String get projectDetailMapTitle => 'Map';

  @override
  String get projectDetailNearbyTitle => 'Nearby places';

  @override
  String get projectDetailPlanTitle => 'Room Plan';

  @override
  String get projectDetailGalleryTitle => 'Gallery';

  @override
  String get projectDetailAdvertisementTitle => 'Brochure';

  @override
  String get projectDetailAdvertisementDownload => 'Download Brochure';

  @override
  String get projectDetailVideoTitle => 'Video';

  @override
  String get projectRegisterInterest => 'Interested in this project?';

  @override
  String get projectRegisterNameField => 'First Name*';

  @override
  String get projectRegisterLastNameField => 'Last Name*';

  @override
  String get projectRegisterPhoneField => 'Phone Number*';

  @override
  String get projectRegisterEmailField => 'Email*';

  @override
  String get projectRegisterPriceRange => 'Preferred Price Range*';

  @override
  String get projectRegisterPurpose => 'Purpose of Purchase*';

  @override
  String get projectRegisterRegister => 'Register';

  @override
  String get projectRegisterRegisterSuccess => 'Submission Successful';

  @override
  String get projectRegisterBackToProject => 'Back to Project Details Page';

  @override
  String get myQRTitle => 'My QR';

  @override
  String get myQRDescription => 'QR for Identity Verification and Privileges';

  @override
  String myQRRefCode(Object refCode) {
    return 'รหัสอ้างอิง : $refCode';
  }

  @override
  String get myQRScanQR => 'Scan QR code';

  @override
  String get myQRShare => 'Share';

  @override
  String get myQRSave => 'Save';

  @override
  String get myQRSaveCompleted => 'Saved successfully';

  @override
  String get promotionsTitle => 'Promotions';

  @override
  String get promotionsSearchHint => 'Search Promotion';

  @override
  String get promotionsInterest => 'Interested in this promotion?';

  @override
  String get promotionsNameField => 'First Name*';

  @override
  String get promotionsLastNameField => 'Last Name*';

  @override
  String get promotionsPhoneField => 'Phone Number*';

  @override
  String get promotionsEmailField => 'Email*';

  @override
  String get promotionsProject => 'Project*';

  @override
  String get promotionsPriceRange => 'Preferred Price Range*';

  @override
  String get promotionsPurpose => 'Purpose of Purchase*';

  @override
  String get promotionsRegister => 'Register';

  @override
  String get promotionsRegisterSuccess => 'Submission Successful';

  @override
  String get promotionsBackToPromotions => 'Back to promotions page';

  @override
  String get hotMenesConfigTitle => 'All Menus';

  @override
  String get hotMenesConfigFavourite => 'Favorite Menu';

  @override
  String get hotMenesConfigOthers => 'Other Menus';

  @override
  String get hotMenesConfigSetting => 'Settings';

  @override
  String get hotMenesConfigDone => 'Done';

  @override
  String get favouritesTitle => 'Favorites';

  @override
  String get favouritesSearchHint => 'Search project name';

  @override
  String get favouritesSearchNoResult => 'No results found';

  @override
  String get favouritesSearchTryAgain => 'Please try again';

  @override
  String get existingUsersTitle => 'เลือกชื่อลูกค้า';

  @override
  String existingUsersSubtitlePhone(Object phoneNumber) {
    return 'พบข้อมูลลูกค้าหลายรายการสำหรับเบอร์ $phoneNumber';
  }

  @override
  String get existingUsersSubtitleEmail =>
      'พบข้อมูลลูกค้าหลายรายการสำหรับอีเมล';

  @override
  String get existingUsersSubtitleCont =>
      'กรุณาเลือกชื่อลูกค้าที่ต้องการเพื่อดำเนินการลงทะเบียนต่อ';

  @override
  String get existingUsersSearchHint => 'ค้นหาชื่อ-นามสกุล หรือรหัสลูกค้า';

  @override
  String get existingUsersSearchHintEmail =>
      'ค้นหาชื่อ-นามสกุล รหัสลูกค้า หรือเบอร์โทร';

  @override
  String existingUsersSearchResult(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'รายการลูกค้า ($count รายการ)',
      one: 'รายการลูกค้า (1 รายการ)',
      zero: 'ไม่พบข้อมูลลูกค้า',
    );
    return '$_temp0';
  }

  @override
  String get existingUsersInstruction => 'แตะเพื่อเลือกชื่อที่ต้องการ';

  @override
  String existingUsersNextButton(Object name) {
    return 'ดำเนินการต่อด้วยชื่อ $name';
  }

  @override
  String existingUsersItemCustomerId(Object customerId) {
    return 'รหัสลูกค้า: $customerId';
  }

  @override
  String existingUsersItemPhone(Object phone) {
    return 'เบอร์มือถือ: $phone';
  }
}
