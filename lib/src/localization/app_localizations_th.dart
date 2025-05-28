// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'AssetWise';

  @override
  String get actionButtonNext => 'ถัดไป';

  @override
  String get actionButtonCancel => 'ยกเลิก';

  @override
  String get errorUnableToProcess => 'ไม่สามารถใช้งานได้ กรุณาลองใหม่อีกครั้ง';

  @override
  String get errorUnableToDownloadContract =>
      '***ไม่สามารถดาวน์โหลดเอกสารสัญญาได้ กรุณาลองใหม่อีกครั้ง***';

  @override
  String get errorFieldRequired => 'กรุณากรอกข้อมูล';

  @override
  String get errorNoData => 'ไม่พบข้อมูล';

  @override
  String get errorInvalidOTP => 'หมายเลข OTP ไม่ถูกต้อง';

  @override
  String get errorInvalidPIN => 'กรุณากรอกรหัส PIN ให้ถูกต้อง';

  @override
  String get errorComingSoon => 'ยังไม่เปิดใช้บริการ';

  @override
  String get bahtUnit => 'บาท';

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

    return '$amountString บาท';
  }

  @override
  String priceFormatBahtDouble(double amount) {
    final intl.NumberFormat amountNumberFormat = intl.NumberFormat.currency(
        locale: localeName, decimalDigits: 2, customPattern: '#,##0.00');
    final String amountString = amountNumberFormat.format(amount);

    return '$amountString บาท';
  }

  @override
  String get bottomBarHome => 'หน้าหลัก';

  @override
  String get bottomBarService => 'บริการ';

  @override
  String get bottomBarChat => 'แชท';

  @override
  String get bottomBarMenu => 'เมนู';

  @override
  String get bottomBarCalendar => 'ปฏิทิน';

  @override
  String get bottomBarPrivilege => 'สิทธิพิเศษ';

  @override
  String get bottomBarMyQR => 'QR ของฉัน';

  @override
  String get bottomBarProfile => 'โปรไฟล์';

  @override
  String get bottomBarMyUnit => 'บ้านของฉัน';

  @override
  String get registerUserName => 'กรอกเบอร์มือถือหรือ E-mail';

  @override
  String get registerUserNameHint =>
      'ระบุเบอร์มือถือหรือ E-mail ของท่าน เพื่อทำการสมัครสมาชิก';

  @override
  String get registerUserNameLabel => 'เบอร์มือถือ/E-mail';

  @override
  String get registerMobileLabel => 'เบอร์มือถือ';

  @override
  String get registerMobile => 'กรอกเบอร์มือถือ';

  @override
  String get registerMobileHint =>
      'ระบุเบอร์มือถือของท่าน เพื่อทำการสมัครสมาชิก';

  @override
  String get registerEMailLabel => 'Email';

  @override
  String get registerEMail => 'กรอก E-Mail';

  @override
  String get registerEMailHint => 'ระบุ E-mail ของท่าน เพื่อทำการสมัครสมาชิก';

  @override
  String get registerLoginByEmail => 'เข้าสู่ระบบผ่าน E-mail';

  @override
  String get registerLast4Digits => 'เลขบัตรประชาชน 4 ตัวหลัง';

  @override
  String get registerIsResident => 'เป็นลูกบ้าน';

  @override
  String get registerNext => 'ถัดไป';

  @override
  String get registerInvalidData => 'กรุณากรอกข้อมูลให้ครบถ้วน';

  @override
  String get registerInvalidResident =>
      'กรุณากรอกเลขบัตรประชาชนให้ตรงกับเบอร์มือถือที่ลงทะเบียน';

  @override
  String get registerInvalidUser =>
      'กรุณากรอกเลขบัตรประชาชนให้ตรงกับ เบอร์มือถือ/อีเมล ที่ลงทะเบียน';

  @override
  String get registerError => 'ไม่สามารถทำงานได้ กรุณาลองใหม่อีกครั้ง';

  @override
  String get otpTitle => 'กรอก OTP';

  @override
  String get otpRequestIsResident => 'เป็นลูกบ้าน';

  @override
  String get otpRequestLast4Digits => 'เลขบัตรประชาชน 4 ตัวหลัง';

  @override
  String get otpRequestAgain => 'ขอรหัสอีกครั้ง';

  @override
  String get otpRequestCountdownPrefix => 'ขอรหัสอีกครั้งใน';

  @override
  String otpRequestCountdown(int time) {
    String _temp0 = intl.Intl.pluralLogic(
      time,
      locale: localeName,
      other: '$time วินาที',
      one: '1 วินาที',
      zero: '',
    );
    return '$_temp0';
  }

  @override
  String otpInstruction(String sendto, String refCode) {
    return 'ระบุตัวเลข 6 หลักที่ถูกส่งไปยัง\n$sendto รหัสอ้างอิง : $refCode';
  }

  @override
  String get userDetailTitle => 'ระบุ - ชื่อนามสกุล';

  @override
  String get userDetailInstruction =>
      'ระบุรายละเอียดของคุณสำหรับการเข้าใช้บริการ';

  @override
  String get userDetailFirstName => 'ชื่อ *';

  @override
  String get userDetailLastName => 'นามสกุล *';

  @override
  String get userDetailMobile => 'เบอร์โทร';

  @override
  String get userDetailEmail => 'อีเมล';

  @override
  String get userDetailCitizenId => 'เลขบัตรประจำตัวประชาชน / Passport No.';

  @override
  String get userDetailInvalidFirstName =>
      'กรุณากรอกชื่อให้ถูกต้อง โดยไม่ใช้อักขระพิเศษ';

  @override
  String get userDetailInvalidLastName =>
      'กรุณากรอกนามสกุลให้ถูกต้อง โดยไม่ใช้อักขระพิเศษ';

  @override
  String get userDetailInvalidEmail => 'กรุณากรอกรูปแบบ E-mail ให้ถูกต้อง';

  @override
  String get userDetailInvalidPhone => 'กรุณากรอกเบอร์มือถือให้ครบ 10 หลัก';

  @override
  String get consentAgree => 'ยินยอม';

  @override
  String get consentDisagree => 'ไม่ยินยอม';

  @override
  String get consentAgreeNext => 'ยืนยัน';

  @override
  String get consentAgreeAll => 'ยินยอมทั้งหมด';

  @override
  String setPinSetPin(int digits) {
    return 'ตั้งรหัส PIN จำนวน $digits หลัก';
  }

  @override
  String get setPinConfirm => 'ใส่รหัส PIN อีกครั้ง';

  @override
  String setPinInstruction(int digits) {
    return 'ระบุ PIN จำนวน $digits หลักเพื่อใช้ในการเข้าสู่ระบบครั้งต่อไป';
  }

  @override
  String get setPinSkipInstruction =>
      'คุณสามารถข้ามขั้นตอนนี้ได้\nโดยจะสามารถเข้าใช้ระบบได้โดยไม่ต้องใส่ PIN';

  @override
  String get setPinSkip => 'ข้าม';

  @override
  String get setPinError => 'กรุณา เริ่มต้น ตั้งรหัส PIN ใหม่อีกครั้ง';

  @override
  String get changeLanguageTitle => 'เปลี่ยนภาษา';

  @override
  String get changeLanguageCurrentLang => 'ภาษาที่ใช้ปัจจุบัน';

  @override
  String get changeLanguageLanguage => 'ภาษา';

  @override
  String get dashboardMainSectionFavourite => 'เมนูโปรด';

  @override
  String get dashboardMainSectionFavouriteMore => 'เมนูทั้งหมด';

  @override
  String get dashboardMainSectionNotification => 'การแจ้งเตือน';

  @override
  String get dashboardMainSectionRecommended => 'โครงการแนะนำ';

  @override
  String get dashboardMainSectionRecommendedDetail =>
      'เรามุ่งมั่นที่จะออกแบบที่อยู่อาศัย เพื่อความสุขของคนอยู่ โดยคำนึงถึงไลฟ์สไตล์ และการใช้ชีวิตของแต่ละคนที่แตกต่างกัน ให้คุณได้ใช้ชีวิตในแบบที่คุณต้องการ';

  @override
  String profileNameFormat(String firstName, String lastName) {
    return '$firstName $lastName';
  }

  @override
  String get profileRegisterBuyer => 'ลงทะเบียนผู้ซื้อ';

  @override
  String get profileDarkMode => 'โหมดสีเข้ม';

  @override
  String get profileMyInfo => 'ข้อมูลของฉัน';

  @override
  String get profilePhoneNumber => 'เบอร์มือถือ';

  @override
  String get profileEmail => 'อีเมล';

  @override
  String get profileMyAsset => 'บ้านของฉัน';

  @override
  String profileMyAssetSum(int count) {
    return '$count หลัง';
  }

  @override
  String get profileLanguage => 'ภาษา';

  @override
  String get profileChangeLanguage => 'เปลี่ยนภาษา';

  @override
  String get profileSettings => 'ตั้งค่าบัญชี';

  @override
  String get profilePersonalInfo => 'จัดการข้อมูลส่วนตัว';

  @override
  String get profilePin => 'รหัส PIN';

  @override
  String get profileDeleteAccount => 'ปิดใช้งานหรือลบบัญชี';

  @override
  String get profileAbout => 'เกี่ยวกับ Assetwise';

  @override
  String get profileAuthen => 'การเข้าสู่ระบบ';

  @override
  String get profileExit => 'ออกจากแอปพลิเคชัน Assetwise';

  @override
  String get profileLogout => 'ออกจากระบบ';

  @override
  String get contractsViewContract => 'รายละเอียดสัญญา';

  @override
  String get overdueDetailAmountLabel => 'ยอดที่ต้องชำระ';

  @override
  String get overdueDetailDueDateLabel => 'ชำระภายใน';

  @override
  String get overdueDetailCreditNumberLabel => 'ตัดผ่านบัญชี';

  @override
  String get overdueDetailDebitDateLabel => 'วันที่ตัดบัญชี';

  @override
  String get overdueDetailPayment => 'ชำระเงิน';

  @override
  String get overdueDetailViewDetail => 'ดูรายละเอียด';

  @override
  String get paymentHistoryTitle => 'ประวัติการชำระ';

  @override
  String get contractDetailTitle => 'รายละเอียดสัญญา';

  @override
  String get contractDetailContractDate => 'วันที่สัญญา';

  @override
  String get contractDetailSigningDate => 'วันที่ลงนาม';

  @override
  String get contractDetailEstimatedTransferDate => 'วันที่ประมาณการโอน';

  @override
  String get contractDetailContractValueTitle => 'มูลค่าสัญญา';

  @override
  String get contractDetailBookingSellingPrice => 'ราคาขาย';

  @override
  String get contractDetailBookingDiscountPrice => 'ส่วนลดเงินสด';

  @override
  String get contractDetailBookingDiscountAtTransferPrice => 'ส่วนลด ณ วันโอน';

  @override
  String get contractDetailBookingNetPrice => 'ราคาสุทธิ';

  @override
  String get contractDetailBookingAmount => 'จอง';

  @override
  String get contractDetailContractAmount => 'สัญญา';

  @override
  String get contractDetailDownAmount => 'ดาวน์';

  @override
  String get contractDetailDownAmountDetails => 'รายละเอียด';

  @override
  String get contractDetailTransferAmount => 'โอน';

  @override
  String get contractDetailPaymentTitle => 'รายละเอียดการชำระ';

  @override
  String get contractDetailPaymentAmount => 'ยอดชำระเงิน';

  @override
  String get contractDetailRemainDownAmount => 'คงเหลือ เงินดาวน์';

  @override
  String get contractDetailRemainHousePayment => 'คงเหลือค่าบ้านทั้งหมด';

  @override
  String get contractDetailFreebiesTitle => 'รายการของแถมและส่วนลด';

  @override
  String get contractDetailDownloadDoc => 'ดาวน์โหลดรายละเอียดสัญญา';

  @override
  String get receiptViewTitle => 'รายละเอียดใบเสร็จ';

  @override
  String get receiptViewSuccess => 'ทำรายการสำเร็จ';

  @override
  String get receiptViewPaymentType => 'ช่องทางการชำระเงิน';

  @override
  String get receiptViewDate => 'วันที่ทำรายการ';

  @override
  String get receiptViewRef1 => 'เลขที่รายการ';

  @override
  String get receiptViewRef2 => 'หมายเลขอ้างอิง';

  @override
  String get receiptViewRemark => 'หมายเหตุ';

  @override
  String get receiptViewDue => 'วันที่ครบกำหนดชำระ';

  @override
  String get receiptViewViewReceipt => 'ดูใบเสร็จ';

  @override
  String get receiptViewFileTitle => 'ใบเสร็จ';

  @override
  String get receiptViewFileDownload => 'ดาวน์โหลดเอกสาร';

  @override
  String get downHistoryViewTitle => 'รายละเอียดงวดดาวน์';

  @override
  String get overduesViewTitle => 'ยอดที่ต้องชำระ';

  @override
  String get overduesViewSumLabel => 'ยอดที่ต้องชำระ';

  @override
  String get overduesViewMakePayment => 'ชำระเงิน';

  @override
  String get paymentChannelViewPaymentTitle => 'ชำระเงิน';

  @override
  String get paymentChannelViewCreditChannel => 'บัตรเครดิต/เดบิต';

  @override
  String get paymentChannelViewQRChannel => 'QR Code';

  @override
  String get paymentChannelViewTotalAmount => 'ยอดที่ต้องชำระ';

  @override
  String get paymentChannelViewDue => 'ชำระภายใน';

  @override
  String get paymentChannelViewPayment => 'ชำระเงิน';

  @override
  String get qrViewTitle => 'QR Code';

  @override
  String get qrViewProject => 'โครงการ';

  @override
  String get qrViewUnit => 'แปลง/ห้อง';

  @override
  String get qrViewTotal => 'ยอดชำระทั้งสิ้น';

  @override
  String get qrViewPromptPayInstruction =>
      'วิธีการชำระเงินด้วย QR Code พร้อมเพย์';

  @override
  String get qrViewPromptPayInstruction1 =>
      '1. เปิดแอปพลิเคชันธนาคาร จากนั้นเลือกเมนู \"Scan\"';

  @override
  String get qrViewPromptPayInstruction2 =>
      '2. สแกน QR Code ร้านค้าที่ต้องการสแกน';

  @override
  String get qrViewPromptPayInstruction3 =>
      '3. เลือกบัญชีและระบุจำนวนเงินที่ต้องการ กด \"ตรวจสอบข้อมูล\"';

  @override
  String get qrViewPromptPayInstruction4 => '4. กดยืนยัน';

  @override
  String get qrViewPromptPayDownload => 'ดาวน์โหลด QR Code';

  @override
  String get qrViewPromptPayDone => 'เสร็จสิ้น';

  @override
  String get qrViewPromptSavedToGallery =>
      'บันทึก QR Code ลงในแกลเลอรี่ของคุณแล้ว';

  @override
  String get pinEntryTitle => 'ใส่รหัส PIN';

  @override
  String pinEntryInstruction(int digits) {
    return 'ระบุรหัส PIN จำนวน $digits หลักเพื่อใช้ในการเข้าสู่ระบบ';
  }

  @override
  String get pinEntryForget => 'ลืมรหัส PIN';

  @override
  String get otpRequestActionResetPin => 'ทำยืนยันตัวตนในการตั้งรหัส PIN';

  @override
  String get otpRequestActionFirstSetPin => 'ใช้ในการเข้าสู่ระบบครั้งต่อไป';

  @override
  String get otpRequestActionReLogin => 'ทำการสมัครสมาชิก';

  @override
  String get otpRequestMobileLabel => 'เบอร์มือถือ';

  @override
  String get otpRequestMobile => 'กรอกเบอร์มือถือ';

  @override
  String otpRequestMobileHint(String action) {
    return 'ระบุเบอร์มือถือของท่าน เพื่อ$action';
  }

  @override
  String get otpRequestEMailLabel => 'Email';

  @override
  String get otpRequestEMail => 'กรอก E-Mail';

  @override
  String otpRequestEMailHint(String action) {
    return 'ระบุ E-mail ของท่าน เพื่อ$action';
  }

  @override
  String get otpRequestLoginByEmail => 'เข้าสู่ระบบผ่าน E-mail';

  @override
  String get otpRequestNext => 'ถัดไป';

  @override
  String get otpRequestInvalidData => 'กรุณากรอกข้อมูลให้ครบถ้วน';

  @override
  String get otpRequestInvalidMobile =>
      'กรุณากรอกเลขบัตรประชาชนให้ตรงกับเบอร์มือถือที่ลงทะเบียน';

  @override
  String get otpRequestInvalidEmail =>
      'กรุณากรอกเลขบัตรประชาชนให้ตรงกับเบอร์มือถือที่ลงทะเบียน';

  @override
  String get otpRequestInvalidUser =>
      'กรุณากรอกเลขบัตรประชาชนให้ตรงกับ เบอร์มือถือ/อีเมล ที่ลงทะเบียน';

  @override
  String get logoutConfirmationTitle => 'ต้องการออกจากระบบใช่หรือไม่';

  @override
  String logoutConfirmationMessage(Object userName) {
    return 'คุณจะออกจากระบบของ $userName';
  }

  @override
  String get logoutConfirmationBottomTitle =>
      'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ';

  @override
  String get logoutConfirmationOKButton => 'ออกจากระบบ';

  @override
  String get closeAppConfirmationTitle =>
      'ต้องการออกจากแอปพลิเคชั่น\nใช่หรือไม่';

  @override
  String get closeAppConfirmationMessage =>
      'คุณสามารถกลับเข้ามาใช้งานได้ใหม่ได้\nโดยยืนยันตัวตนผ่านรหัส PIN';

  @override
  String get closeAppConfirmationOKButton => 'ออกจากแอป';

  @override
  String get emailOldValueTitle => 'แก้ไข E-mail';

  @override
  String get emailOldValueInstructions =>
      'หากคุณแก้ไข E-mail ที่นี่ บัญชีทั้งหมดที่ผูกกับบัญชีผู้ใช้นี้ จะถูกแก้ไขตามไปด้วย';

  @override
  String get emailOldValueTextLabel => 'E-mail';

  @override
  String get emailOldValueAction => 'เปลี่ยน E-mail';

  @override
  String get emailNewValueTitle => 'ระบุ E-mail ใหม่';

  @override
  String get emailNewValueInstructions =>
      'หากต้องการเปลี่ยนแปลง E-mail กรุณากดส่งคำขอเพื่อให้เจ้าหน้าที่ทำการติดต่อคุณในภายหลัง';

  @override
  String get emailNewValueTextLabel => 'ระบุเบอร์ E-mail ใหม่';

  @override
  String get emailNewValueAction => 'ส่งคำขอเปลี่ยนแปลง E-mail';

  @override
  String get emailChangeSuccessTitle => 'ส่งข้อมูลสำเร็จ';

  @override
  String get emailChangeSuccessIntructions =>
      'เจ้าหน้าที่จะติดต่อคุณกลับภายใน 24 ชั่วโมง';

  @override
  String get emailChangeSuccessAction => 'กลับสู่หน้าหลัก';

  @override
  String get phoneOldValueTitle => 'เบอร์มือถือ';

  @override
  String get phoneOldValueInstructions =>
      'หากต้องการเปลี่ยนแปลงเบอร์มือถือ กรุณากดส่งคำขอ เพื่อให้เจ้าหน้าที่ทำการติดต่อคุณในภายหลัง';

  @override
  String get phoneOldValueTextLabel => 'เบอร์มือถือ';

  @override
  String get phoneOldValueAction => 'เปลี่ยนเบอร์';

  @override
  String get phoneNewValueTitle => 'ระบุเบอร์โทรใหม่';

  @override
  String get phoneNewValueInstructions =>
      'หากต้องการเปลี่ยนแปลงเบอร์มือถือ กรุณากดส่งคำขอ เพื่อให้เจ้าหน้าที่ทำการติดต่อคุณในภายหลัง';

  @override
  String get phoneNewValueTextLabel => 'ระบุเบอร์มือถือใหม่';

  @override
  String get phoneNewValueAction => 'ส่งคำขอเปลี่ยนแปลงเบอร์มือถือ';

  @override
  String get phoneChangeSuccessTitle => 'ส่งข้อมูลสำเร็จ';

  @override
  String get phoneChangeSuccessIntructions =>
      '*เจ้าหน้าที่จะติดต่อคุณกลับภายใน 24 ชั่วโมง';

  @override
  String get phoneChangeSuccessAction => 'กลับสู่หน้าหลัก';

  @override
  String get notificationTitle => 'แจ้งเตือนทั้งหมด';

  @override
  String get notificationAll => 'ทั้งหมด';

  @override
  String get notificationPayment => 'ชำระค่างวด';

  @override
  String get notificationPromotion => 'โปรโมชั่น';

  @override
  String get notificationHotDeal => 'Hot Deal';

  @override
  String get notificationNews => 'ข่าวสาร';

  @override
  String get notificationReadAll => 'อ่านทั้งหมด';

  @override
  String get aboutAssetWiseTitle => 'เกี่ยวกับ AssetWise';

  @override
  String aboutAssetWiseVersion(Object build, Object version) {
    return 'เวอร์ชั่น $version ($build)';
  }

  @override
  String get aboutAssetWiseCopyright => 'ⓒ 2025 บริษัท แอสเซทไวส์ จำกัด';

  @override
  String get aboutAssetWiseTermOfService => 'เงื่อนไขการให้บริการ';

  @override
  String get aboutAssetWisePrivacyPolicy => 'นโยบายคุ้มครองข้อมูลส่วนตัว';

  @override
  String get aboutAssetWiseSecurityPolicy => 'นโยบายความปลอดภัย';

  @override
  String get registerBuyerTitle => 'ลงทะเบียนผู้ซื้อ';

  @override
  String get registerBuyerHeader => 'ยืนยันตัวตน';

  @override
  String get registerBuyerInstruction =>
      'กรุณายืนยันตัวตนของคุณด้วยเลขประจำตัวประชาชนหรือหมายเลข Passport เพื่อความปลอดภัย';

  @override
  String get registerBuyerIdentifier => 'เลขประจำตัวประชาชน / Passport No.';

  @override
  String get registerBuyerRegister => 'ลงทะเบียน';

  @override
  String get registerBuyerInvalidId =>
      'กรุณากรอกเลขบัตรประชาชนให้ครบถ้วน 13 หลัก';

  @override
  String get myAssetTitle => 'บ้านของฉัน';

  @override
  String myAssetSum(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count หลัง',
      one: '1 หลัง',
      zero: '',
    );
    return ' $_temp0';
  }

  @override
  String get myAssetAdd => 'เพิ่มบ้าน';

  @override
  String get myAssetViewDetail => 'ดูรายละเอียด';

  @override
  String get myAssetSetDefault => 'ตั้งเป็นค่าเริ่มต้น';

  @override
  String get myAssetDelete => 'ลบบ้าน';

  @override
  String get myAssetDeleteConfirmation => 'ต้องการลบบ้านใช่หรือไม่';

  @override
  String myAssetDeleteDetail(Object unitNumber) {
    return 'หากคุณทำการลบบ้านเลขที่ $unitNumber\nข้อมูลทั้งหมดจะถูกลบออกจากระบบ';
  }

  @override
  String get myAssetDeleteDelete => 'ลบ';

  @override
  String get myAssetDeleteCancel => 'ยกเลิก';

  @override
  String get myAssetDeleteSuccess => 'ลบข้อมูลบ้านสำเร็จ';

  @override
  String get myAssetDefault => 'ค่าเริ่มต้น';

  @override
  String get addAssetTitle => 'เพิ่มบ้าน';

  @override
  String get addAssetInstruction =>
      'ระบุรายละเอียดของคุณสำหรับการเข้าใช้บริการ';

  @override
  String get addAssetProject => 'โครงการ*';

  @override
  String get addAssetUnit => 'บ้านเลขที่*';

  @override
  String get addAssetLast4Id => 'รหัสประจำตัวประชาชน 4 ตัวหลัง*';

  @override
  String get addAssetProjectRequired => 'กรุณาระบุโครงการ';

  @override
  String get addAssetUnitRequired => 'กรุณาระบุบ้านเลขที่';

  @override
  String get addAssetLast4IdRequired => 'กรุณาระบุรหัสบัตรประชาชน 4 ตัวหลัง';

  @override
  String get managePersonalInfoTitle => 'จัดการข้อมูลส่วนตัว';

  @override
  String get managePersonalInfoCollectionPersonalInfo =>
      'การรวมรวบและใช้ข้อมูลส่วนบุคคล';

  @override
  String get managePersonalInfoMarketingPurpose =>
      'ความยินยอมเพื่อวัตถุประสงค์ทางการตลาด';

  @override
  String get managePersonalInfoDisclosureMarketing =>
      'ความยินยอมในการเปิดเผยข้อมูลเพื่อวัตถุประสงค์ทางการตลาด';

  @override
  String get managePersonalInfoGiveConsent => 'ให้ความยินยอม';

  @override
  String lastUpdated(Object date) {
    return 'อัปเดตล่าสุด $date';
  }

  @override
  String get unableToPayHeading => 'ไม่สามารถชำระเงินได้ในขณะนี้';

  @override
  String get unableToPayBack => 'กลับไปหน้าสัญญา';

  @override
  String get mapTitle => 'แผนที่';

  @override
  String get mapSearchHint => 'ค้นหา';

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
  String get mapShowProjectDetail => 'ดูข้อมูลโครงการ';

  @override
  String get mapNavigate => 'นำทาง';

  @override
  String mapDistanceKM(Object distance) {
    return '$distance กม.';
  }

  @override
  String get projectsTitle => 'โครงการ';

  @override
  String get projectsSearchHint => 'ค้นหาชื่อโครงการ';

  @override
  String get projectsSeeOnMap => 'ดูบนแผนที่';

  @override
  String get projectsFilterTitle => 'ตัวกรอง';

  @override
  String get projectsBrands => 'แบรนด์';

  @override
  String get projectsLocations => 'ทำเล';

  @override
  String get projectsClearFilter => 'ล้างตัวกรอง';

  @override
  String get projectsSearch => 'ค้นหา';

  @override
  String get projectsSearchNoResult => 'ไม่พบผลการค้นหา';

  @override
  String get projectsSearchTryAgain => 'กรุณาลองใหม่อีกครั้ง';

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
  String get projectDetailTitle => 'รายละเอียดโครงการ';

  @override
  String get projectDetailSectionDetail => 'รายละเอียด';

  @override
  String get projectDetailSectionMap => 'แผนที่';

  @override
  String get projectDetailSectionPlan => 'แปลน';

  @override
  String get projectDetailSectionGallery => 'แกลเลอรี่';

  @override
  String get projectDetailSectionAdvertisement => 'ใบโฆษณา';

  @override
  String get projectDetailSectionVideo => 'วิดีโอ';

  @override
  String get projectDetailProgressTitle => 'ความคืบหน้า';

  @override
  String projectDetailProgressUpdated(Object date) {
    return 'วันที่อัปเดต : $date';
  }

  @override
  String get projectDetailProgressStructure => 'โครงสร้าง';

  @override
  String get projectDetailProgressFinishing => 'สถาปัตยกรรม';

  @override
  String get projectDetailProgressComplete => 'ติดตั้งระบบ';

  @override
  String get projectDetailProgressConstruction => 'เสาเข็ม';

  @override
  String get projectDetailMapTitle => 'แผนที่';

  @override
  String get projectDetailNearbyTitle => 'สถานที่ใกล้เคียง';

  @override
  String get projectDetailPlanTitle => 'แปลนห้อง';

  @override
  String get projectDetailGalleryTitle => 'แกลเลอรี่';

  @override
  String get projectDetailAdvertisementTitle => 'ใบโฆษณา';

  @override
  String get projectDetailAdvertisementDownload => 'ดาวน์โหลดใบโฆษณา';

  @override
  String get projectDetailVideoTitle => 'วิดีโอ';

  @override
  String get projectRegisterInterest => 'สนใจโครงการนี้';

  @override
  String get projectRegisterNameField => 'ชื่อ*';

  @override
  String get projectRegisterLastNameField => 'นามสกุล*';

  @override
  String get projectRegisterPhoneField => 'เบอร์มือถือ*';

  @override
  String get projectRegisterEmailField => 'อีเมล*';

  @override
  String get projectRegisterPriceRange => 'ช่วงราคาที่สนใจ*';

  @override
  String get projectRegisterPurpose => 'วัตถุประสงค์การซื้อ*';

  @override
  String get projectRegisterRegister => 'ลงทะเบียน';

  @override
  String get projectRegisterRegisterSuccess => 'ส่งข้อมูลสำเร็จ';

  @override
  String get projectRegisterBackToProject => 'กลับสู่หน้าโครงการ';

  @override
  String get myQRTitle => 'QR ของฉัน';

  @override
  String get myQRDescription => 'QR สำหรับใช้ยืนยันตัวตนรับสิทธิต่าง ๆ';

  @override
  String myQRRefCode(Object refCode) {
    return 'รหัสอ้างอิง : $refCode';
  }

  @override
  String get myQRScanQR => 'สแกน QR';

  @override
  String get myQRShare => 'แชร์';

  @override
  String get myQRSave => 'บันทึก';

  @override
  String get myQRSaveCompleted => 'บันทึกสำเร็จ';

  @override
  String get promotionsTitle => 'โปรโมชั่น';

  @override
  String get promotionsSearchHint => 'ค้นหาโปรโมชั่น';

  @override
  String get promotionsInterest => 'สนใจโปรโมชั่นนี้';

  @override
  String get promotionsNameField => 'ชื่อ*';

  @override
  String get promotionsLastNameField => 'นามสกุล*';

  @override
  String get promotionsPhoneField => 'เบอร์มือถือ*';

  @override
  String get promotionsEmailField => 'อีเมล*';

  @override
  String get promotionsProject => 'โครงการ*';

  @override
  String get promotionsPriceRange => 'ช่วงราคาที่สนใจ*';

  @override
  String get promotionsPurpose => 'วัตถุประสงค์การซื้อ*';

  @override
  String get promotionsRegister => 'ลงทะเบียน';

  @override
  String get promotionsRegisterSuccess => 'ส่งข้อมูลสำเร็จ';

  @override
  String get promotionsBackToPromotions => 'กลับสู่หน้าโปรโมชั่น';

  @override
  String get hotMenesConfigTitle => 'เมนูทั้งหมด';

  @override
  String get hotMenesConfigFavourite => 'เมนูโปรด';

  @override
  String get hotMenesConfigOthers => 'เมนูอื่น ๆ';

  @override
  String get hotMenesConfigSetting => 'ตั้งค่า';

  @override
  String get hotMenesConfigDone => 'เสร็จสิ้น';

  @override
  String get favouritesTitle => 'รายการโปรด';

  @override
  String get favouritesSearchHint => 'ค้นหาชื่อโครงการ';

  @override
  String get favouritesSearchNoResult => 'ไม่พบผลการค้นหา';

  @override
  String get favouritesSearchTryAgain => 'กรุณาลองใหม่อีกครั้ง';
}
