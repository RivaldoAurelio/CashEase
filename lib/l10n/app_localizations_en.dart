// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get languageName => 'English';

  @override
  String get homeTitle => 'Home';

  @override
  String get profileTitle => 'Profile';

  @override
  String get transactionHistory => 'History';

  @override
  String get pocketTitle => 'My Pocket';

  @override
  String get balance => 'Balance';

  @override
  String get topUp => 'Top Up';

  @override
  String get send => 'Send';

  @override
  String get request => 'Request';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get success => 'Success';

  @override
  String get failed => 'Failed';

  @override
  String get confirm => 'Confirm';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String get active => 'Active';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search...';

  @override
  String get continueButton => 'Continue';

  @override
  String get menuTransfer => 'Transfer';

  @override
  String get menuCreditCard => 'Credit Card';

  @override
  String get menuBeneficiary => 'Beneficiary';

  @override
  String get menuBills => 'Bills';

  @override
  String get menuTaxesLoan => 'Taxes/Loan';

  @override
  String get menuTaxes => 'Taxes';

  @override
  String get menuTaxesDesc => 'Pay your tax obligations';

  @override
  String get menuLoan => 'Loan';

  @override
  String get menuLoanDesc => 'Manage your loan payments';

  @override
  String welcomeUser(Object name) {
    return 'Hi, $name';
  }

  @override
  String get services => 'Services';

  @override
  String get financial => 'Financial';

  @override
  String get utilities => 'Utilities';

  @override
  String get support => 'Support';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get inbox => 'Inbox';

  @override
  String get mobilePrepaid => 'Mobile Prepaid';

  @override
  String get savings => 'Savings';

  @override
  String get loginAppTitle => 'CashEase';

  @override
  String get loginSubtitle => 'Digital Wallet for You!';

  @override
  String get loginPrompt => 'Login/Register with number';

  @override
  String get loginSubPrompt => 'and enjoy the best features';

  @override
  String get phoneHint => '81234567890';

  @override
  String get phoneError => 'Phone number must be 12 digits';

  @override
  String get phoneNotRegistered => 'Phone number not registered';

  @override
  String get pinTitle => 'Enter PIN';

  @override
  String get newPin => 'New PIN';

  @override
  String get resetPin => 'Reset PIN';

  @override
  String get resetPinTitle => 'Reset Your PIN';

  @override
  String get resetPinSubtitle => 'Confirm phone number and enter new PIN';

  @override
  String get pinLengthError => 'PIN must be 5 digits';

  @override
  String get pinChangedSuccess => 'PIN changed successfully!';

  @override
  String get forgotPin => 'Forgot PIN?';

  @override
  String get transNotif => 'Transaction Activity';

  @override
  String get transactionStatus => 'Transaction Status';

  @override
  String get category => 'Category';

  @override
  String get noTransactions => 'No transactions found';

  @override
  String get all => 'All';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get inProgress => 'In Progress';

  @override
  String get approved => 'Approved';

  @override
  String get chooseDate => 'Choose Date';

  @override
  String get noMessages => 'No Messages';

  @override
  String get filterBy => 'Filter by';

  @override
  String get messageDetails => 'Message Details';

  @override
  String get deleteMessage => 'Delete Message';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete';

  @override
  String get noBeneficiary => 'No Beneficiaries';

  @override
  String get addBeneficiary => 'Add Beneficiary';

  @override
  String get editBeneficiary => 'Edit Beneficiary';

  @override
  String get chooseOption => 'Choose Option';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get bankName => 'Bank Name';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get email => 'Email';

  @override
  String get addSavingGoal => 'Add Saving Goal';

  @override
  String get editSavingGoal => 'Edit Saving Goal';

  @override
  String get savingName => 'Goal Name';

  @override
  String get enterSavingName => 'Enter goal name';

  @override
  String get targetAmount => 'Target Amount';

  @override
  String get enterTargetAmount => 'Enter target amount';

  @override
  String get validAmount => 'Enter a valid amount';

  @override
  String get initialDeposit => 'Initial Deposit';

  @override
  String get enterInitialDeposit => 'Enter initial deposit';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get pickDate => 'Pick a target date';

  @override
  String get targetDate => 'Target Date';

  @override
  String get adminFee => 'Admin Fee Rp2.000';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get pay => 'Pay Now';

  @override
  String get successTopUp => 'Balance added successfully!';

  @override
  String get appName => 'CashEase';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get takPhoto => 'Take Photo (Camera)';

  @override
  String get chooseGallery => 'Choose from Gallery';

  @override
  String get profileQr => 'Profile QR';

  @override
  String get profileQrDesc =>
      'Ask your nearby friend to scan this QR code to start a transaction.';

  @override
  String get close => 'Close';

  @override
  String get selectBank => 'Select Bank';

  @override
  String get enterAmount => 'Enter Amount';

  @override
  String get example => 'Example';

  @override
  String get fromBank => 'From Bank';

  @override
  String get topUpAmount => 'Top Up Amount';

  @override
  String get pleaseSelectBank => 'Please select a bank';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get verifyPinCancelled => 'PIN verification cancelled';

  @override
  String get topUpSuccess => 'Top Up Successful!';

  @override
  String get topUpFailed => 'Failed to process Top Up';

  @override
  String balanceAdded(Object amount) {
    return 'Balance Rp $amount has been added.';
  }

  @override
  String get transferMoney => 'Send Money To';

  @override
  String get yourBalance => 'Your Balance:';

  @override
  String get currencyConversion => 'Currency Conversion';

  @override
  String get insufficientBalance => 'Insufficient balance';

  @override
  String get transferFailed => 'Failed to process transfer';

  @override
  String get failedFetchRate => 'Failed to fetch exchange rate';

  @override
  String get requestMoney => 'Request Money From';

  @override
  String get nominal => 'Nominal (Rp)';

  @override
  String get hint => 'eg: 50000';

  @override
  String get notes => 'Notes (Optional)';

  @override
  String get requestSent => 'Request sent (simulation).';

  @override
  String get enterValidNominal => 'Enter a valid nominal';

  @override
  String get searchPhoneBank => 'Search phone number / bank account / name';

  @override
  String get selectFromContact => 'Select from Contact';

  @override
  String get contact => 'Contact';

  @override
  String get otherMethods => 'Other Methods';

  @override
  String get link => 'Link';

  @override
  String get linkFeatureSimulation => 'Link Feature (simulation)';

  @override
  String get qrDetected => 'QR Detected';

  @override
  String get enterCode => 'Enter Code:';

  @override
  String get proceedToPay => 'Proceed to payment?';

  @override
  String get scanQris => 'Scan QRIS';

  @override
  String get pointCameraQr => 'Point camera at QR code';

  @override
  String get gallery => 'Gallery';

  @override
  String get myCode => 'My Code';

  @override
  String get galleryFeatureNotActive => 'Gallery feature not yet active';

  @override
  String get securityCodeYours => 'Your Security Code';

  @override
  String get code => 'Your Code:';

  @override
  String get ok => 'OK';

  @override
  String get securityCode => 'Security Code';

  @override
  String get enterSecurityCode =>
      'Enter the security code displayed in the popup';

  @override
  String get enter6Digit => 'Enter the 6-digit code displayed earlier';

  @override
  String get enterCodeFirst => 'Enter the code first';

  @override
  String get code6Digit => 'Code must be 6 digits';

  @override
  String get submit => 'Submit';

  @override
  String get showCodeAgain => 'Show Code Again';

  @override
  String get wrongCode => 'The code you entered is wrong';

  @override
  String get sessionSavedFor => 'Session saved for:';

  @override
  String get accountSuccessCreated => 'Account successfully created! Welcome.';

  @override
  String get accountCreationFailed =>
      'Failed to create account. This number may already be registered.';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get wrongPinOrAccount => 'Wrong PIN or account not found.';

  @override
  String get networkError => 'Network error occurred. Please try again.';

  @override
  String get pocketCards => 'Pocket Cards';

  @override
  String get searchCard => 'Search Card';

  @override
  String get saveYourCards => 'Save your bank cards!';

  @override
  String get addCard => 'Add Card';

  @override
  String get cardNumberLast => 'Card Number (last 12 digits)';

  @override
  String get enterLast12Digits => 'Please enter the last 12 digits';

  @override
  String get enterExactly12Digits => 'Please enter exactly 12 digits';

  @override
  String get previewCard => 'Preview Card';

  @override
  String get cardPreview => 'Card Preview';

  @override
  String get progressColon => 'Progress:';

  @override
  String get descriptionColon => 'Description:';

  @override
  String get photoSelectedLocally => 'Photo successfully selected (Locally)';

  @override
  String get errorPickingImage => 'Error picking image';

  @override
  String get profileUpdatedSuccess => 'Profile successfully updated!';

  @override
  String get taxPayment => 'Tax Payment';

  @override
  String get payTax => 'Pay Tax';

  @override
  String get taxHistory => 'Tax History';

  @override
  String get pph21 => 'PPh 21 (Income Tax)';

  @override
  String get completed => 'Completed';

  @override
  String get ppn => 'PPN (Value Added Tax)';

  @override
  String get pph25 => 'PPh 25 (Monthly Tax)';

  @override
  String get pbb => 'PBB (Property Tax)';

  @override
  String get annual => 'Annual';

  @override
  String get availableBalance => 'Available Balance';

  @override
  String get sufficientBalance => 'Sufficient balance for tax payment';

  @override
  String get taxPaymentDetails => 'Tax Payment Details';

  @override
  String get pph23 => 'PPh 23 (Tax on Services)';

  @override
  String get bphtb => 'BPHTB (Property Transfer Tax)';

  @override
  String get withdrawMethod => 'Withdrawal Method';

  @override
  String get adminFeeRp => 'Admin Fee Rp2.000';

  @override
  String get withdrawalSuccess => 'Withdrawal Successful';

  @override
  String get withdrawalTo => 'Withdrawal to';

  @override
  String get allMessages => 'All Messages';

  @override
  String get lessThan10Days => 'Less than 10 days';

  @override
  String get lessThan20Days => 'Less than 20 days';

  @override
  String get lessThan30Days => 'Less than 30 days';

  @override
  String get moreThan30Days => 'More than 30 days';

  @override
  String get cashEaseTeam => 'CashEase Team';

  @override
  String get welcomeCashEase => 'Welcome to CashEase!';

  @override
  String get thankYou =>
      'Thank you for choosing CashEase for your financial needs.';

  @override
  String get today => 'Today';

  @override
  String get editProfileDesc => 'Change name, email, and phone number';

  @override
  String get accountSecurityDesc => 'Change PIN, set security questions';

  @override
  String get savedCardsDesc => 'Set up bank accounts & credit cards';

  @override
  String get biometricLogin => 'Biometric Login';

  @override
  String get biometricDesc => 'Use fingerprint or face to login';

  @override
  String get connectedDevices => 'Connected Devices';

  @override
  String get connectedDevicesDesc => 'View and manage active login sessions';

  @override
  String get promotionOffers => 'Promo & Offers';

  @override
  String get promotionOffersDesc => 'Get the latest promo info';

  @override
  String get transactionActivity => 'Transaction Activity';

  @override
  String get transactionActivityDesc => 'Notifications for every transaction';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get aboutApp => 'About Application';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get biometricEnabled => 'Biometric Login enabled';

  @override
  String get biometricDisabled => 'Biometric Login disabled';

  @override
  String get logoutSuccess => 'Successfully logged out!';

  @override
  String get general => 'General';

  @override
  String get account => 'Account';

  @override
  String get security => 'Security';

  @override
  String get notifications => 'Notifications';

  @override
  String get info => 'Info';

  @override
  String get selectLanguage => 'Choose Language';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get japanese => '日本語 (Japanese)';

  @override
  String get korean => '한국어 (Korean)';

  @override
  String get chinese => '中文 (Chinese)';

  @override
  String get loadingBalance => 'Loading balance...';

  @override
  String get salary => 'Salary';

  @override
  String get freelance => 'Freelance';

  @override
  String get business => 'Business';

  @override
  String get investment => 'Investment';

  @override
  String get other => 'Other';

  @override
  String get sendToGroup => 'Send to Group';

  @override
  String get sendToFriend => 'Send to Friend';

  @override
  String get sendToBank => 'Send to Bank';

  @override
  String get sendToWallet => 'Send to E-Wallet';

  @override
  String get sendCashCode => 'Send Cash Code';

  @override
  String get cashPull => 'Cash Pull';

  @override
  String get sendToEmail => 'Send to Email';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get sendToChat => 'Send to Chat';

  @override
  String get searchPhoneReceipt => 'Search phone no / bank account';

  @override
  String get withdrawalMethod => 'Withdrawal Method';

  @override
  String get requestActive => 'Active Requests';

  @override
  String get noRequests => 'No active requests';

  @override
  String get personal => 'Personal';

  @override
  String get balanceYours => 'Your Balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get savingYours => 'Your Savings';

  @override
  String get addNewSaving => 'Add New Saving';

  @override
  String get noSavings => 'No savings yet';

  @override
  String get emergencySaving => 'Emergency Saving';

  @override
  String get taxType => 'Tax Type';

  @override
  String get npwpNumber => 'NPWP Number';

  @override
  String get enterNpwp => 'Enter your NPWP number';

  @override
  String get enterNpwpFirst => 'Please enter NPWP number';

  @override
  String get npwpDigits => 'NPWP must be 15 digits';

  @override
  String get taxYear => 'Tax Year';

  @override
  String get taxPeriod => 'Tax Period';

  @override
  String get enterTaxAmount => 'Enter tax amount to pay';

  @override
  String get addPaymentDescription => 'Add payment description';

  @override
  String get payTaxButton => 'Pay Tax Now';

  @override
  String get confirmPayment => 'Confirm Payment';

  @override
  String get taxTypeLabel => 'Tax Type:';

  @override
  String get npwpLabel => 'NPWP:';

  @override
  String get periodLabel => 'Period:';

  @override
  String get amountLabel => 'Amount:';

  @override
  String get paymentSuccessful => 'Payment Successful!';

  @override
  String paymentSuccessMessage(Object amount) {
    return 'Your tax payment of Rp $amount has been processed successfully.';
  }

  @override
  String get viewHistory => 'View History';

  @override
  String get makeAnotherPayment => 'Make Another Payment';

  @override
  String get recentTaxPayments => 'Recent Tax Payments';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get noTaxPayments => 'No tax payments yet';
}
