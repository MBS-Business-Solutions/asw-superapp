import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'AssetWise'**
  String get appTitle;

  /// No description provided for @actionButtonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionButtonNext;

  /// No description provided for @actionButtonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionButtonCancel;

  /// No description provided for @errorUnableToProcess.
  ///
  /// In en, this message translates to:
  /// **'Unavailable Please try again.'**
  String get errorUnableToProcess;

  /// No description provided for @errorUnableToDownloadContract.
  ///
  /// In en, this message translates to:
  /// **'Unable to download contract documents Please try again.'**
  String get errorUnableToDownloadContract;

  /// No description provided for @errorFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get errorFieldRequired;

  /// No description provided for @errorNoData.
  ///
  /// In en, this message translates to:
  /// **'No data found.'**
  String get errorNoData;

  /// No description provided for @errorInvalidOTP.
  ///
  /// In en, this message translates to:
  /// **'Incorrect OTP number.'**
  String get errorInvalidOTP;

  /// No description provided for @errorInvalidPIN.
  ///
  /// In en, this message translates to:
  /// **'Please enter the PIN code correctly.'**
  String get errorInvalidPIN;

  /// No description provided for @errorComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Service not yet available.'**
  String get errorComingSoon;

  /// No description provided for @bahtUnit.
  ///
  /// In en, this message translates to:
  /// **'baht'**
  String get bahtUnit;

  /// The format of the price
  ///
  /// In en, this message translates to:
  /// **'{price}'**
  String priceFormat(double price);

  /// The format of the price
  ///
  /// In en, this message translates to:
  /// **'{price}'**
  String priceFormatDouble(double price);

  /// The format of the amount
  ///
  /// In en, this message translates to:
  /// **'{amount} baht'**
  String priceFormatBaht(double amount);

  /// The format of the amount
  ///
  /// In en, this message translates to:
  /// **'{amount} baht'**
  String priceFormatBahtDouble(double amount);

  /// No description provided for @bottomBarHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomBarHome;

  /// No description provided for @bottomBarService.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get bottomBarService;

  /// No description provided for @bottomBarChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get bottomBarChat;

  /// No description provided for @bottomBarMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get bottomBarMenu;

  /// No description provided for @bottomBarCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get bottomBarCalendar;

  /// No description provided for @bottomBarPrivilege.
  ///
  /// In en, this message translates to:
  /// **'Privilege'**
  String get bottomBarPrivilege;

  /// No description provided for @bottomBarMyQR.
  ///
  /// In en, this message translates to:
  /// **'My QR'**
  String get bottomBarMyQR;

  /// No description provided for @bottomBarProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get bottomBarProfile;

  /// No description provided for @bottomBarMyUnit.
  ///
  /// In en, this message translates to:
  /// **'My Unit'**
  String get bottomBarMyUnit;

  /// No description provided for @registerUserName.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number or email address'**
  String get registerUserName;

  /// No description provided for @registerUserNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile phone number or email to apply for membership.'**
  String get registerUserNameHint;

  /// No description provided for @registerUserNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number/email'**
  String get registerUserNameLabel;

  /// No description provided for @registerMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get registerMobileLabel;

  /// No description provided for @registerMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get registerMobile;

  /// No description provided for @registerMobileHint.
  ///
  /// In en, this message translates to:
  /// **'Provide your mobile number to register as a member'**
  String get registerMobileHint;

  /// No description provided for @registerEMailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEMailLabel;

  /// No description provided for @registerEMail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get registerEMail;

  /// No description provided for @registerEMailHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address to register'**
  String get registerEMailHint;

  /// No description provided for @registerLoginByEmail.
  ///
  /// In en, this message translates to:
  /// **'Log in with Email'**
  String get registerLoginByEmail;

  /// No description provided for @registerLast4Digits.
  ///
  /// In en, this message translates to:
  /// **'Last 4 digits of ID card'**
  String get registerLast4Digits;

  /// No description provided for @registerIsResident.
  ///
  /// In en, this message translates to:
  /// **'Existing customer'**
  String get registerIsResident;

  /// No description provided for @registerNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get registerNext;

  /// No description provided for @registerInvalidData.
  ///
  /// In en, this message translates to:
  /// **'Please check your input.'**
  String get registerInvalidData;

  /// No description provided for @registerInvalidResident.
  ///
  /// In en, this message translates to:
  /// **'Please enter your ID card number to match your registered mobile number.'**
  String get registerInvalidResident;

  /// No description provided for @registerInvalidUser.
  ///
  /// In en, this message translates to:
  /// **'Please enter your ID card number to match your registered mobile number/email address.'**
  String get registerInvalidUser;

  /// No description provided for @registerError.
  ///
  /// In en, this message translates to:
  /// **'Unable to process. Please try again.'**
  String get registerError;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get otpTitle;

  /// No description provided for @otpRequestIsResident.
  ///
  /// In en, this message translates to:
  /// **'Existing customer'**
  String get otpRequestIsResident;

  /// No description provided for @otpRequestLast4Digits.
  ///
  /// In en, this message translates to:
  /// **'Last 4 digits of ID card'**
  String get otpRequestLast4Digits;

  /// No description provided for @otpRequestAgain.
  ///
  /// In en, this message translates to:
  /// **'Request code again.'**
  String get otpRequestAgain;

  /// No description provided for @otpRequestCountdownPrefix.
  ///
  /// In en, this message translates to:
  /// **'Request code again in'**
  String get otpRequestCountdownPrefix;

  /// Message indicating the countdown time to request the OTP code again
  ///
  /// In en, this message translates to:
  /// **'{time, plural, =0{} =1{1 second} other{{time} seconds}}'**
  String otpRequestCountdown(int time);

  /// OTP confirmation message by selecting the type of sending (email or mobile number)
  ///
  /// In en, this message translates to:
  /// **'Enter the 6 digits sent to\n{sendto} REF : {refCode}'**
  String otpInstruction(String sendto, String refCode);

  /// No description provided for @userDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Name - Surname'**
  String get userDetailTitle;

  /// No description provided for @userDetailInstruction.
  ///
  /// In en, this message translates to:
  /// **'Provide your details to access the service'**
  String get userDetailInstruction;

  /// No description provided for @userDetailFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name *'**
  String get userDetailFirstName;

  /// No description provided for @userDetailLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name *'**
  String get userDetailLastName;

  /// No description provided for @userDetailMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get userDetailMobile;

  /// No description provided for @userDetailEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get userDetailEmail;

  /// No description provided for @userDetailCitizenId.
  ///
  /// In en, this message translates to:
  /// **'National ID / Passport No.'**
  String get userDetailCitizenId;

  /// No description provided for @userDetailInvalidFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name correctly without using special characters.'**
  String get userDetailInvalidFirstName;

  /// No description provided for @userDetailInvalidLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name correctly without using special characters.'**
  String get userDetailInvalidLastName;

  /// No description provided for @userDetailInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid E-mail address in the correct format.'**
  String get userDetailInvalidEmail;

  /// No description provided for @userDetailInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 10-digit mobile number.'**
  String get userDetailInvalidPhone;

  /// No description provided for @consentAgree.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get consentAgree;

  /// No description provided for @consentDisagree.
  ///
  /// In en, this message translates to:
  /// **'Don\'t accept'**
  String get consentDisagree;

  /// No description provided for @consentAgreeNext.
  ///
  /// In en, this message translates to:
  /// **'Consent'**
  String get consentAgreeNext;

  /// No description provided for @consentAgreeAll.
  ///
  /// In en, this message translates to:
  /// **'Consent to all'**
  String get consentAgreeAll;

  /// Message to set a PIN with a specified number of digits
  ///
  /// In en, this message translates to:
  /// **'Set a {digits}-digit PIN'**
  String setPinSetPin(int digits);

  /// No description provided for @setPinConfirm.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN code again.'**
  String get setPinConfirm;

  /// Message to set a PIN with a specified number of digits
  ///
  /// In en, this message translates to:
  /// **'Please enter a {digits}-digit PIN to set up your password'**
  String setPinInstruction(int digits);

  /// No description provided for @setPinSkipInstruction.
  ///
  /// In en, this message translates to:
  /// **'You can skip this step.\nYou will be able to access the system without having to enter a PIN.'**
  String get setPinSkipInstruction;

  /// No description provided for @setPinSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get setPinSkip;

  /// No description provided for @setPinError.
  ///
  /// In en, this message translates to:
  /// **'Please start setting a new PIN code again.'**
  String get setPinError;

  /// No description provided for @changeLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguageTitle;

  /// No description provided for @changeLanguageCurrentLang.
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get changeLanguageCurrentLang;

  /// No description provided for @changeLanguageLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get changeLanguageLanguage;

  /// The title of the favourite section
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get dashboardMainSectionFavourite;

  /// No description provided for @dashboardMainSectionFavouriteMore.
  ///
  /// In en, this message translates to:
  /// **'All menus'**
  String get dashboardMainSectionFavouriteMore;

  /// No description provided for @dashboardMainSectionNotification.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get dashboardMainSectionNotification;

  /// No description provided for @dashboardMainSectionRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended projects'**
  String get dashboardMainSectionRecommended;

  /// No description provided for @dashboardMainSectionRecommendedDetail.
  ///
  /// In en, this message translates to:
  /// **'We are committed to designing homes. For the happiness of the people Taking into account lifestyle and the lifestyle of each person is different Allowing you to live your life the way you want.'**
  String get dashboardMainSectionRecommendedDetail;

  /// The format of the full name
  ///
  /// In en, this message translates to:
  /// **'{firstName} {lastName}'**
  String profileNameFormat(String firstName, String lastName);

  /// No description provided for @profileRegisterBuyer.
  ///
  /// In en, this message translates to:
  /// **'Register Buyer'**
  String get profileRegisterBuyer;

  /// No description provided for @profileDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get profileDarkMode;

  /// No description provided for @profileMyInfo.
  ///
  /// In en, this message translates to:
  /// **'My Information'**
  String get profileMyInfo;

  /// No description provided for @profilePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profilePhoneNumber;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileMyAsset.
  ///
  /// In en, this message translates to:
  /// **'My Units'**
  String get profileMyAsset;

  /// Message indicating the number of assets
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{unit} other{units}}'**
  String profileMyAssetSum(int count);

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileChangeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get profileChangeLanguage;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get profileSettings;

  /// No description provided for @profilePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Manage Personal Information'**
  String get profilePersonalInfo;

  /// No description provided for @profilePin.
  ///
  /// In en, this message translates to:
  /// **'PIN Code'**
  String get profilePin;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Deactivate or Delete Account'**
  String get profileDeleteAccount;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About Assetwise'**
  String get profileAbout;

  /// No description provided for @profileAuthen.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get profileAuthen;

  /// No description provided for @profileExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get profileExit;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogout;

  /// No description provided for @contractsViewContract.
  ///
  /// In en, this message translates to:
  /// **'Contract Details'**
  String get contractsViewContract;

  /// No description provided for @overdueDetailAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Make Payment'**
  String get overdueDetailAmountLabel;

  /// No description provided for @overdueDetailDueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get overdueDetailDueDateLabel;

  /// No description provided for @overdueDetailCreditNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Deduct from Account'**
  String get overdueDetailCreditNumberLabel;

  /// No description provided for @overdueDetailDebitDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Deduction Date'**
  String get overdueDetailDebitDateLabel;

  /// No description provided for @overdueDetailPayment.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get overdueDetailPayment;

  /// No description provided for @overdueDetailViewDetail.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get overdueDetailViewDetail;

  /// No description provided for @paymentHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistoryTitle;

  /// No description provided for @contractDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Contract Details'**
  String get contractDetailTitle;

  /// No description provided for @contractDetailContractDate.
  ///
  /// In en, this message translates to:
  /// **'Contract Date'**
  String get contractDetailContractDate;

  /// No description provided for @contractDetailSigningDate.
  ///
  /// In en, this message translates to:
  /// **'Contract Date'**
  String get contractDetailSigningDate;

  /// No description provided for @contractDetailEstimatedTransferDate.
  ///
  /// In en, this message translates to:
  /// **'Estimated Transfer Date'**
  String get contractDetailEstimatedTransferDate;

  /// No description provided for @contractDetailContractValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Contract Value'**
  String get contractDetailContractValueTitle;

  /// No description provided for @contractDetailBookingSellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price'**
  String get contractDetailBookingSellingPrice;

  /// No description provided for @contractDetailBookingDiscountPrice.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get contractDetailBookingDiscountPrice;

  /// No description provided for @contractDetailBookingDiscountAtTransferPrice.
  ///
  /// In en, this message translates to:
  /// **'Discount on transfer date'**
  String get contractDetailBookingDiscountAtTransferPrice;

  /// No description provided for @contractDetailBookingNetPrice.
  ///
  /// In en, this message translates to:
  /// **'Net Price'**
  String get contractDetailBookingNetPrice;

  /// No description provided for @contractDetailBookingAmount.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get contractDetailBookingAmount;

  /// No description provided for @contractDetailContractAmount.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contractDetailContractAmount;

  /// No description provided for @contractDetailDownAmount.
  ///
  /// In en, this message translates to:
  /// **'Down payment'**
  String get contractDetailDownAmount;

  /// No description provided for @contractDetailDownAmountDetails.
  ///
  /// In en, this message translates to:
  /// **'details'**
  String get contractDetailDownAmountDetails;

  /// No description provided for @contractDetailTransferAmount.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get contractDetailTransferAmount;

  /// No description provided for @contractDetailPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get contractDetailPaymentTitle;

  /// No description provided for @contractDetailPaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get contractDetailPaymentAmount;

  /// No description provided for @contractDetailRemainDownAmount.
  ///
  /// In en, this message translates to:
  /// **'Remaining Down Payment'**
  String get contractDetailRemainDownAmount;

  /// No description provided for @contractDetailRemainHousePayment.
  ///
  /// In en, this message translates to:
  /// **'Total Remaining House Payment'**
  String get contractDetailRemainHousePayment;

  /// No description provided for @contractDetailFreebiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Freebies and Discounts List'**
  String get contractDetailFreebiesTitle;

  /// No description provided for @contractDetailDownloadDoc.
  ///
  /// In en, this message translates to:
  /// **'Download Contract Documents'**
  String get contractDetailDownloadDoc;

  /// No description provided for @receiptViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt Details'**
  String get receiptViewTitle;

  /// No description provided for @receiptViewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Transaction Successful'**
  String get receiptViewSuccess;

  /// No description provided for @receiptViewPaymentType.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get receiptViewPaymentType;

  /// No description provided for @receiptViewDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get receiptViewDate;

  /// No description provided for @receiptViewRef1.
  ///
  /// In en, this message translates to:
  /// **'Item number'**
  String get receiptViewRef1;

  /// No description provided for @receiptViewRef2.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get receiptViewRef2;

  /// No description provided for @receiptViewRemark.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get receiptViewRemark;

  /// No description provided for @receiptViewDue.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get receiptViewDue;

  /// No description provided for @receiptViewViewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View Receipt'**
  String get receiptViewViewReceipt;

  /// No description provided for @receiptViewFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receiptViewFileTitle;

  /// No description provided for @receiptViewFileDownload.
  ///
  /// In en, this message translates to:
  /// **'Download Receipt'**
  String get receiptViewFileDownload;

  /// No description provided for @downHistoryViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Down payment details'**
  String get downHistoryViewTitle;

  /// No description provided for @overduesViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Amount Due'**
  String get overduesViewTitle;

  /// No description provided for @overduesViewSumLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount Due'**
  String get overduesViewSumLabel;

  /// No description provided for @overduesViewMakePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get overduesViewMakePayment;

  /// No description provided for @paymentChannelViewPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentChannelViewPaymentTitle;

  /// No description provided for @paymentChannelViewCreditChannel.
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit Card'**
  String get paymentChannelViewCreditChannel;

  /// No description provided for @paymentChannelViewQRChannel.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get paymentChannelViewQRChannel;

  /// No description provided for @paymentChannelViewTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount Due'**
  String get paymentChannelViewTotalAmount;

  /// No description provided for @paymentChannelViewDue.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get paymentChannelViewDue;

  /// No description provided for @paymentChannelViewPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentChannelViewPayment;

  /// No description provided for @qrViewTitle.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrViewTitle;

  /// No description provided for @qrViewProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get qrViewProject;

  /// No description provided for @qrViewUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get qrViewUnit;

  /// No description provided for @qrViewTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get qrViewTotal;

  /// No description provided for @qrViewPromptPayInstruction.
  ///
  /// In en, this message translates to:
  /// **'How to pay with PromptPay QR Code'**
  String get qrViewPromptPayInstruction;

  /// No description provided for @qrViewPromptPayInstruction1.
  ///
  /// In en, this message translates to:
  /// **'1. Open your banking app and select the \"Scan\" menu.'**
  String get qrViewPromptPayInstruction1;

  /// No description provided for @qrViewPromptPayInstruction2.
  ///
  /// In en, this message translates to:
  /// **'2. Scan the store\'s QR Code.'**
  String get qrViewPromptPayInstruction2;

  /// No description provided for @qrViewPromptPayInstruction3.
  ///
  /// In en, this message translates to:
  /// **'3. Select your account, enter the amount, and tap \"Confirm\".'**
  String get qrViewPromptPayInstruction3;

  /// No description provided for @qrViewPromptPayInstruction4.
  ///
  /// In en, this message translates to:
  /// **'4. Confirm'**
  String get qrViewPromptPayInstruction4;

  /// No description provided for @qrViewPromptPayDownload.
  ///
  /// In en, this message translates to:
  /// **'Download QR Code'**
  String get qrViewPromptPayDownload;

  /// No description provided for @qrViewPromptPayDone.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get qrViewPromptPayDone;

  /// No description provided for @qrViewPromptSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'QR Code saved to gallery'**
  String get qrViewPromptSavedToGallery;

  /// No description provided for @pinEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get pinEntryTitle;

  /// Message to enter a PIN with a specified number of digits
  ///
  /// In en, this message translates to:
  /// **'Enter a {digits}-digit PIN to log in.'**
  String pinEntryInstruction(int digits);

  /// No description provided for @pinEntryForget.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN code'**
  String get pinEntryForget;

  /// No description provided for @otpRequestActionResetPin.
  ///
  /// In en, this message translates to:
  /// **'verify your identity for setting up a PIN.'**
  String get otpRequestActionResetPin;

  /// No description provided for @otpRequestActionFirstSetPin.
  ///
  /// In en, this message translates to:
  /// **'verify your identity every time you log in in the future.'**
  String get otpRequestActionFirstSetPin;

  /// No description provided for @otpRequestActionReLogin.
  ///
  /// In en, this message translates to:
  /// **'register as a member.'**
  String get otpRequestActionReLogin;

  /// No description provided for @otpRequestMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get otpRequestMobileLabel;

  /// No description provided for @otpRequestMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get otpRequestMobile;

  /// Hint for the mobile number input field
  ///
  /// In en, this message translates to:
  /// **'Provide your mobile number to {action}'**
  String otpRequestMobileHint(String action);

  /// No description provided for @otpRequestEMailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get otpRequestEMailLabel;

  /// No description provided for @otpRequestEMail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get otpRequestEMail;

  /// Hint for the email input field
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address to {action}'**
  String otpRequestEMailHint(String action);

  /// No description provided for @otpRequestLoginByEmail.
  ///
  /// In en, this message translates to:
  /// **'Log in with Email'**
  String get otpRequestLoginByEmail;

  /// No description provided for @otpRequestNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get otpRequestNext;

  /// No description provided for @otpRequestInvalidData.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all information completely.'**
  String get otpRequestInvalidData;

  /// No description provided for @otpRequestInvalidMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter your ID card number to match your registered mobile number.'**
  String get otpRequestInvalidMobile;

  /// No description provided for @otpRequestInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your ID card number to match your registered email address.'**
  String get otpRequestInvalidEmail;

  /// No description provided for @otpRequestInvalidUser.
  ///
  /// In en, this message translates to:
  /// **'Please enter your ID card number to match your registered mobile number/email address.'**
  String get otpRequestInvalidUser;

  /// No description provided for @logoutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out?'**
  String get logoutConfirmationTitle;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'You are about to log out of {userName}'**
  String logoutConfirmationMessage(Object userName);

  /// No description provided for @logoutConfirmationBottomTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmationBottomTitle;

  /// No description provided for @logoutConfirmationOKButton.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutConfirmationOKButton;

  /// No description provided for @closeAppConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit?'**
  String get closeAppConfirmationTitle;

  /// No description provided for @closeAppConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'You can re-log in\n by verifying your identity with a PIN.'**
  String get closeAppConfirmationMessage;

  /// No description provided for @closeAppConfirmationOKButton.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get closeAppConfirmationOKButton;

  /// No description provided for @emailOldValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Email'**
  String get emailOldValueTitle;

  /// No description provided for @emailOldValueInstructions.
  ///
  /// In en, this message translates to:
  /// **'If you wish to update your email here, all accounts linked to this user account will also be updated accordingly.'**
  String get emailOldValueInstructions;

  /// No description provided for @emailOldValueTextLabel.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get emailOldValueTextLabel;

  /// No description provided for @emailOldValueAction.
  ///
  /// In en, this message translates to:
  /// **'Change E-mail'**
  String get emailOldValueAction;

  /// No description provided for @emailNewValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a New E-mail'**
  String get emailNewValueTitle;

  /// No description provided for @emailNewValueInstructions.
  ///
  /// In en, this message translates to:
  /// **'If you wish to change your E-mail, please submit a request so that our staff can contact you later.'**
  String get emailNewValueInstructions;

  /// No description provided for @emailNewValueTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter a New E-mail'**
  String get emailNewValueTextLabel;

  /// No description provided for @emailNewValueAction.
  ///
  /// In en, this message translates to:
  /// **'Submit E-mail Change Request'**
  String get emailNewValueAction;

  /// No description provided for @emailChangeSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted'**
  String get emailChangeSuccessTitle;

  /// No description provided for @emailChangeSuccessIntructions.
  ///
  /// In en, this message translates to:
  /// **'You will be contacted within 24 hours.'**
  String get emailChangeSuccessIntructions;

  /// No description provided for @emailChangeSuccessAction.
  ///
  /// In en, this message translates to:
  /// **'Go back to Home'**
  String get emailChangeSuccessAction;

  /// No description provided for @phoneOldValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneOldValueTitle;

  /// No description provided for @phoneOldValueInstructions.
  ///
  /// In en, this message translates to:
  /// **'If you wish to change your phone number, please press \"Send Request\" to allow our staff to contact you later.'**
  String get phoneOldValueInstructions;

  /// No description provided for @phoneOldValueTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneOldValueTextLabel;

  /// No description provided for @phoneOldValueAction.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get phoneOldValueAction;

  /// No description provided for @phoneNewValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Specify a new phone number'**
  String get phoneNewValueTitle;

  /// No description provided for @phoneNewValueInstructions.
  ///
  /// In en, this message translates to:
  /// **'If you wish to change your phone number, please press \"Send Request\" to allow our staff to contact you later.'**
  String get phoneNewValueInstructions;

  /// No description provided for @phoneNewValueTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Specify a new phone number'**
  String get phoneNewValueTextLabel;

  /// No description provided for @phoneNewValueAction.
  ///
  /// In en, this message translates to:
  /// **'Submit a Phone Number Change Request'**
  String get phoneNewValueAction;

  /// No description provided for @phoneChangeSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted'**
  String get phoneChangeSuccessTitle;

  /// No description provided for @phoneChangeSuccessIntructions.
  ///
  /// In en, this message translates to:
  /// **'You will be contacted within 24 hours.'**
  String get phoneChangeSuccessIntructions;

  /// No description provided for @phoneChangeSuccessAction.
  ///
  /// In en, this message translates to:
  /// **'Go back to Home'**
  String get phoneChangeSuccessAction;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'All Notifications'**
  String get notificationTitle;

  /// No description provided for @notificationAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationAll;

  /// No description provided for @notificationPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get notificationPayment;

  /// No description provided for @notificationPromotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get notificationPromotion;

  /// No description provided for @notificationHotDeal.
  ///
  /// In en, this message translates to:
  /// **'Hot Deal'**
  String get notificationHotDeal;

  /// No description provided for @notificationNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get notificationNews;

  /// No description provided for @notificationReadAll.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get notificationReadAll;

  /// No description provided for @aboutAssetWiseTitle.
  ///
  /// In en, this message translates to:
  /// **'About Assetwise'**
  String get aboutAssetWiseTitle;

  /// No description provided for @aboutAssetWiseVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({build})'**
  String aboutAssetWiseVersion(Object build, Object version);

  /// No description provided for @aboutAssetWiseCopyright.
  ///
  /// In en, this message translates to:
  /// **'ⓒ 2025 บริษัท แอสเซทไวส์ จำกัด'**
  String get aboutAssetWiseCopyright;

  /// No description provided for @aboutAssetWiseTermOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get aboutAssetWiseTermOfService;

  /// No description provided for @aboutAssetWisePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutAssetWisePrivacyPolicy;

  /// No description provided for @aboutAssetWiseSecurityPolicy.
  ///
  /// In en, this message translates to:
  /// **'Security Policy'**
  String get aboutAssetWiseSecurityPolicy;

  /// No description provided for @registerBuyerTitle.
  ///
  /// In en, this message translates to:
  /// **'Buyer Registration'**
  String get registerBuyerTitle;

  /// No description provided for @registerBuyerHeader.
  ///
  /// In en, this message translates to:
  /// **'Verify Identity'**
  String get registerBuyerHeader;

  /// No description provided for @registerBuyerInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please verify your identity with your National ID number or Passport number for security purposes.'**
  String get registerBuyerInstruction;

  /// No description provided for @registerBuyerIdentifier.
  ///
  /// In en, this message translates to:
  /// **'National ID / Passport No.'**
  String get registerBuyerIdentifier;

  /// No description provided for @registerBuyerRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerBuyerRegister;

  /// No description provided for @registerBuyerInvalidId.
  ///
  /// In en, this message translates to:
  /// **'Please fill in your ID card number completely, 13 digits'**
  String get registerBuyerInvalidId;

  /// No description provided for @myAssetTitle.
  ///
  /// In en, this message translates to:
  /// **'My Home'**
  String get myAssetTitle;

  /// Message indicating the number of assets
  ///
  /// In en, this message translates to:
  /// **' {count, plural, =0{} =1{1 Unit} other{{count} Unit}}'**
  String myAssetSum(int count);

  /// No description provided for @myAssetAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Home'**
  String get myAssetAdd;

  /// No description provided for @myAssetViewDetail.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get myAssetViewDetail;

  /// No description provided for @myAssetSetDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get myAssetSetDefault;

  /// No description provided for @myAssetDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete house'**
  String get myAssetDelete;

  /// No description provided for @myAssetDeleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the house?'**
  String get myAssetDeleteConfirmation;

  /// No description provided for @myAssetDeleteDetail.
  ///
  /// In en, this message translates to:
  /// **'If you want to delete house number {unitNumber},\nall information will be removed from the system.'**
  String myAssetDeleteDetail(Object unitNumber);

  /// No description provided for @myAssetDeleteDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get myAssetDeleteDelete;

  /// No description provided for @myAssetDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get myAssetDeleteCancel;

  /// No description provided for @myAssetDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data deleted successfully'**
  String get myAssetDeleteSuccess;

  /// No description provided for @myAssetDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get myAssetDefault;

  /// No description provided for @addAssetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Home'**
  String get addAssetTitle;

  /// No description provided for @addAssetInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please provide your details for service access.'**
  String get addAssetInstruction;

  /// No description provided for @addAssetProject.
  ///
  /// In en, this message translates to:
  /// **'Project*'**
  String get addAssetProject;

  /// No description provided for @addAssetUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit Number*'**
  String get addAssetUnit;

  /// No description provided for @addAssetLast4Id.
  ///
  /// In en, this message translates to:
  /// **'Last 4 digits of ID Card*'**
  String get addAssetLast4Id;

  /// No description provided for @addAssetProjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Please specify the project.'**
  String get addAssetProjectRequired;

  /// No description provided for @addAssetUnitRequired.
  ///
  /// In en, this message translates to:
  /// **'Please specify your house number.'**
  String get addAssetUnitRequired;

  /// No description provided for @addAssetLast4IdRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the last 4 digits of your national ID card number.'**
  String get addAssetLast4IdRequired;

  /// No description provided for @managePersonalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Personal Information'**
  String get managePersonalInfoTitle;

  /// No description provided for @managePersonalInfoCollectionPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Collection and Use of Personal Information'**
  String get managePersonalInfoCollectionPersonalInfo;

  /// No description provided for @managePersonalInfoMarketingPurpose.
  ///
  /// In en, this message translates to:
  /// **'Consent for Marketing Purposes'**
  String get managePersonalInfoMarketingPurpose;

  /// No description provided for @managePersonalInfoDisclosureMarketing.
  ///
  /// In en, this message translates to:
  /// **'Consent for Disclosure of Information for Marketing Purposes'**
  String get managePersonalInfoDisclosureMarketing;

  /// No description provided for @managePersonalInfoGiveConsent.
  ///
  /// In en, this message translates to:
  /// **'Give Consent'**
  String get managePersonalInfoGiveConsent;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String lastUpdated(Object date);

  /// No description provided for @unableToPayHeading.
  ///
  /// In en, this message translates to:
  /// **'Payment is not available at this time.'**
  String get unableToPayHeading;

  /// No description provided for @unableToPayBack.
  ///
  /// In en, this message translates to:
  /// **'Return to contract page'**
  String get unableToPayBack;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTitle;

  /// No description provided for @mapSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get mapSearchHint;

  /// No description provided for @mapSearchCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{ผลการค้นหา : 1 รายการ} other{ผลการค้นหา : {count} รายการ}}'**
  String mapSearchCount(num count);

  /// No description provided for @mapShowProjectDetail.
  ///
  /// In en, this message translates to:
  /// **'View project details'**
  String get mapShowProjectDetail;

  /// No description provided for @mapNavigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get mapNavigate;

  /// No description provided for @mapDistanceKM.
  ///
  /// In en, this message translates to:
  /// **'{distance} km.'**
  String mapDistanceKM(Object distance);

  /// No description provided for @projectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsTitle;

  /// No description provided for @projectsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for project name'**
  String get projectsSearchHint;

  /// No description provided for @projectsSeeOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get projectsSeeOnMap;

  /// No description provided for @projectsFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get projectsFilterTitle;

  /// No description provided for @projectsBrands.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get projectsBrands;

  /// No description provided for @projectsLocations.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get projectsLocations;

  /// No description provided for @projectsClearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get projectsClearFilter;

  /// No description provided for @projectsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get projectsSearch;

  /// No description provided for @projectsSearchNoResult.
  ///
  /// In en, this message translates to:
  /// **'No search results found'**
  String get projectsSearchNoResult;

  /// No description provided for @projectsSearchTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get projectsSearchTryAgain;

  /// No description provided for @projectsSearchCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{ผลการค้นหา : 1 รายการ} other{ผลการค้นหา : {count} รายการ}}'**
  String projectsSearchCount(num count);

  /// No description provided for @projectDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Details'**
  String get projectDetailTitle;

  /// No description provided for @projectDetailSectionDetail.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get projectDetailSectionDetail;

  /// No description provided for @projectDetailSectionMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get projectDetailSectionMap;

  /// No description provided for @projectDetailSectionPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get projectDetailSectionPlan;

  /// No description provided for @projectDetailSectionGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get projectDetailSectionGallery;

  /// No description provided for @projectDetailSectionAdvertisement.
  ///
  /// In en, this message translates to:
  /// **'Brochure'**
  String get projectDetailSectionAdvertisement;

  /// No description provided for @projectDetailSectionVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get projectDetailSectionVideo;

  /// No description provided for @projectDetailProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get projectDetailProgressTitle;

  /// No description provided for @projectDetailProgressUpdated.
  ///
  /// In en, this message translates to:
  /// **'วันที่อัปเดต : {date}'**
  String projectDetailProgressUpdated(Object date);

  /// No description provided for @projectDetailProgressStructure.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get projectDetailProgressStructure;

  /// No description provided for @projectDetailProgressFinishing.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get projectDetailProgressFinishing;

  /// No description provided for @projectDetailProgressComplete.
  ///
  /// In en, this message translates to:
  /// **'System Installation'**
  String get projectDetailProgressComplete;

  /// No description provided for @projectDetailProgressConstruction.
  ///
  /// In en, this message translates to:
  /// **'Piling'**
  String get projectDetailProgressConstruction;

  /// No description provided for @projectDetailMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get projectDetailMapTitle;

  /// No description provided for @projectDetailNearbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby places'**
  String get projectDetailNearbyTitle;

  /// No description provided for @projectDetailPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Room Plan'**
  String get projectDetailPlanTitle;

  /// No description provided for @projectDetailGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get projectDetailGalleryTitle;

  /// No description provided for @projectDetailAdvertisementTitle.
  ///
  /// In en, this message translates to:
  /// **'Brochure'**
  String get projectDetailAdvertisementTitle;

  /// No description provided for @projectDetailAdvertisementDownload.
  ///
  /// In en, this message translates to:
  /// **'Download Brochure'**
  String get projectDetailAdvertisementDownload;

  /// No description provided for @projectDetailVideoTitle.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get projectDetailVideoTitle;

  /// No description provided for @projectRegisterInterest.
  ///
  /// In en, this message translates to:
  /// **'Interested in this project?'**
  String get projectRegisterInterest;

  /// No description provided for @projectRegisterNameField.
  ///
  /// In en, this message translates to:
  /// **'First Name*'**
  String get projectRegisterNameField;

  /// No description provided for @projectRegisterLastNameField.
  ///
  /// In en, this message translates to:
  /// **'Last Name*'**
  String get projectRegisterLastNameField;

  /// No description provided for @projectRegisterPhoneField.
  ///
  /// In en, this message translates to:
  /// **'Phone Number*'**
  String get projectRegisterPhoneField;

  /// No description provided for @projectRegisterEmailField.
  ///
  /// In en, this message translates to:
  /// **'Email*'**
  String get projectRegisterEmailField;

  /// No description provided for @projectRegisterPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Preferred Price Range*'**
  String get projectRegisterPriceRange;

  /// No description provided for @projectRegisterPurpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose of Purchase*'**
  String get projectRegisterPurpose;

  /// No description provided for @projectRegisterRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get projectRegisterRegister;

  /// No description provided for @projectRegisterRegisterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Submission Successful'**
  String get projectRegisterRegisterSuccess;

  /// No description provided for @projectRegisterBackToProject.
  ///
  /// In en, this message translates to:
  /// **'Back to Project Details Page'**
  String get projectRegisterBackToProject;

  /// No description provided for @myQRTitle.
  ///
  /// In en, this message translates to:
  /// **'My QR'**
  String get myQRTitle;

  /// No description provided for @myQRDescription.
  ///
  /// In en, this message translates to:
  /// **'QR for Identity Verification and Privileges'**
  String get myQRDescription;

  /// No description provided for @myQRRefCode.
  ///
  /// In en, this message translates to:
  /// **'รหัสอ้างอิง : {refCode}'**
  String myQRRefCode(Object refCode);

  /// No description provided for @myQRScanQR.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get myQRScanQR;

  /// No description provided for @myQRShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get myQRShare;

  /// No description provided for @myQRSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get myQRSave;

  /// No description provided for @myQRSaveCompleted.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get myQRSaveCompleted;

  /// No description provided for @promotionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get promotionsTitle;

  /// No description provided for @promotionsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search Promotion'**
  String get promotionsSearchHint;

  /// No description provided for @promotionsInterest.
  ///
  /// In en, this message translates to:
  /// **'Interested in this promotion?'**
  String get promotionsInterest;

  /// No description provided for @promotionsNameField.
  ///
  /// In en, this message translates to:
  /// **'First Name*'**
  String get promotionsNameField;

  /// No description provided for @promotionsLastNameField.
  ///
  /// In en, this message translates to:
  /// **'Last Name*'**
  String get promotionsLastNameField;

  /// No description provided for @promotionsPhoneField.
  ///
  /// In en, this message translates to:
  /// **'Phone Number*'**
  String get promotionsPhoneField;

  /// No description provided for @promotionsEmailField.
  ///
  /// In en, this message translates to:
  /// **'Email*'**
  String get promotionsEmailField;

  /// No description provided for @promotionsProject.
  ///
  /// In en, this message translates to:
  /// **'Project*'**
  String get promotionsProject;

  /// No description provided for @promotionsPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Preferred Price Range*'**
  String get promotionsPriceRange;

  /// No description provided for @promotionsPurpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose of Purchase*'**
  String get promotionsPurpose;

  /// No description provided for @promotionsRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get promotionsRegister;

  /// No description provided for @promotionsRegisterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Submission Successful'**
  String get promotionsRegisterSuccess;

  /// No description provided for @promotionsBackToPromotions.
  ///
  /// In en, this message translates to:
  /// **'Back to promotions page'**
  String get promotionsBackToPromotions;

  /// No description provided for @hotMenesConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'All Menus'**
  String get hotMenesConfigTitle;

  /// No description provided for @hotMenesConfigFavourite.
  ///
  /// In en, this message translates to:
  /// **'Favorite Menu'**
  String get hotMenesConfigFavourite;

  /// No description provided for @hotMenesConfigOthers.
  ///
  /// In en, this message translates to:
  /// **'Other Menus'**
  String get hotMenesConfigOthers;

  /// No description provided for @hotMenesConfigSetting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get hotMenesConfigSetting;

  /// No description provided for @hotMenesConfigDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get hotMenesConfigDone;

  /// No description provided for @favouritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favouritesTitle;

  /// No description provided for @favouritesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search project name'**
  String get favouritesSearchHint;

  /// No description provided for @favouritesSearchNoResult.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get favouritesSearchNoResult;

  /// No description provided for @favouritesSearchTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get favouritesSearchTryAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
