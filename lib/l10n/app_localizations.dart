import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTitle;

  /// No description provided for @changeLanguage.
  ///
  /// In id, this message translates to:
  /// **'Ganti Bahasa'**
  String get changeLanguage;

  /// No description provided for @languageName.
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get languageName;

  /// No description provided for @homeTitle.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get homeTitle;

  /// No description provided for @profileTitle.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @transactionHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get transactionHistory;

  /// No description provided for @pocketTitle.
  ///
  /// In id, this message translates to:
  /// **'Saku Saya'**
  String get pocketTitle;

  /// No description provided for @balance.
  ///
  /// In id, this message translates to:
  /// **'Saldo'**
  String get balance;

  /// No description provided for @topUp.
  ///
  /// In id, this message translates to:
  /// **'Isi Saldo'**
  String get topUp;

  /// No description provided for @send.
  ///
  /// In id, this message translates to:
  /// **'Kirim'**
  String get send;

  /// No description provided for @request.
  ///
  /// In id, this message translates to:
  /// **'Minta'**
  String get request;

  /// No description provided for @withdraw.
  ///
  /// In id, this message translates to:
  /// **'Tarik'**
  String get withdraw;

  /// No description provided for @login.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In id, this message translates to:
  /// **'Anda yakin ingin keluar?'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get edit;

  /// No description provided for @success.
  ///
  /// In id, this message translates to:
  /// **'Berhasil'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In id, this message translates to:
  /// **'Gagal'**
  String get failed;

  /// No description provided for @confirm.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi'**
  String get confirm;

  /// No description provided for @reset.
  ///
  /// In id, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In id, this message translates to:
  /// **'Terapkan'**
  String get apply;

  /// No description provided for @active.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get active;

  /// No description provided for @amount.
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get date;

  /// No description provided for @search.
  ///
  /// In id, this message translates to:
  /// **'Cari'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari...'**
  String get searchHint;

  /// No description provided for @continueButton.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan'**
  String get continueButton;

  /// No description provided for @menuTransfer.
  ///
  /// In id, this message translates to:
  /// **'Transfer'**
  String get menuTransfer;

  /// No description provided for @menuCreditCard.
  ///
  /// In id, this message translates to:
  /// **'Kartu Kredit'**
  String get menuCreditCard;

  /// No description provided for @menuBeneficiary.
  ///
  /// In id, this message translates to:
  /// **'Penerima'**
  String get menuBeneficiary;

  /// No description provided for @menuBills.
  ///
  /// In id, this message translates to:
  /// **'Tagihan'**
  String get menuBills;

  /// No description provided for @menuTaxesLoan.
  ///
  /// In id, this message translates to:
  /// **'Pajak/Pinjaman'**
  String get menuTaxesLoan;

  /// No description provided for @menuTaxes.
  ///
  /// In id, this message translates to:
  /// **'Pajak'**
  String get menuTaxes;

  /// No description provided for @menuTaxesDesc.
  ///
  /// In id, this message translates to:
  /// **'Bayar kewajiban pajak Anda'**
  String get menuTaxesDesc;

  /// No description provided for @menuLoan.
  ///
  /// In id, this message translates to:
  /// **'Pinjaman'**
  String get menuLoan;

  /// No description provided for @menuLoanDesc.
  ///
  /// In id, this message translates to:
  /// **'Kelola pembayaran pinjaman'**
  String get menuLoanDesc;

  /// No description provided for @welcomeUser.
  ///
  /// In id, this message translates to:
  /// **'Hai, {name}'**
  String welcomeUser(Object name);

  /// No description provided for @services.
  ///
  /// In id, this message translates to:
  /// **'Layanan'**
  String get services;

  /// No description provided for @financial.
  ///
  /// In id, this message translates to:
  /// **'Keuangan'**
  String get financial;

  /// No description provided for @utilities.
  ///
  /// In id, this message translates to:
  /// **'Utilitas'**
  String get utilities;

  /// No description provided for @support.
  ///
  /// In id, this message translates to:
  /// **'Bantuan'**
  String get support;

  /// No description provided for @helpSupport.
  ///
  /// In id, this message translates to:
  /// **'Pusat Bantuan'**
  String get helpSupport;

  /// No description provided for @inbox.
  ///
  /// In id, this message translates to:
  /// **'Kotak Masuk'**
  String get inbox;

  /// No description provided for @mobilePrepaid.
  ///
  /// In id, this message translates to:
  /// **'Pulsa & Data'**
  String get mobilePrepaid;

  /// No description provided for @savings.
  ///
  /// In id, this message translates to:
  /// **'Tabungan'**
  String get savings;

  /// No description provided for @loginAppTitle.
  ///
  /// In id, this message translates to:
  /// **'CashEase'**
  String get loginAppTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Dompet Digital untuk Anda!'**
  String get loginSubtitle;

  /// No description provided for @loginPrompt.
  ///
  /// In id, this message translates to:
  /// **'Masuk/daftar dengan nomor'**
  String get loginPrompt;

  /// No description provided for @loginSubPrompt.
  ///
  /// In id, this message translates to:
  /// **'dan mulai nikmati semua yang terbaik'**
  String get loginSubPrompt;

  /// No description provided for @phoneHint.
  ///
  /// In id, this message translates to:
  /// **'81234567890'**
  String get phoneHint;

  /// No description provided for @phoneError.
  ///
  /// In id, this message translates to:
  /// **'Nomor HP harus 12 digit angka'**
  String get phoneError;

  /// No description provided for @phoneNotRegistered.
  ///
  /// In id, this message translates to:
  /// **'Nomor tidak terdaftar'**
  String get phoneNotRegistered;

  /// No description provided for @pinTitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan PIN'**
  String get pinTitle;

  /// No description provided for @newPin.
  ///
  /// In id, this message translates to:
  /// **'PIN Baru'**
  String get newPin;

  /// No description provided for @resetPin.
  ///
  /// In id, this message translates to:
  /// **'Reset PIN'**
  String get resetPin;

  /// No description provided for @resetPinTitle.
  ///
  /// In id, this message translates to:
  /// **'Reset PIN Anda'**
  String get resetPinTitle;

  /// No description provided for @resetPinSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi nomor dan masukkan PIN baru'**
  String get resetPinSubtitle;

  /// No description provided for @pinLengthError.
  ///
  /// In id, this message translates to:
  /// **'PIN harus 5 digit'**
  String get pinLengthError;

  /// No description provided for @pinChangedSuccess.
  ///
  /// In id, this message translates to:
  /// **'PIN berhasil diubah!'**
  String get pinChangedSuccess;

  /// No description provided for @forgotPin.
  ///
  /// In id, this message translates to:
  /// **'Lupa PIN?'**
  String get forgotPin;

  /// No description provided for @transNotif.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas Transaksi'**
  String get transNotif;

  /// No description provided for @transactionStatus.
  ///
  /// In id, this message translates to:
  /// **'Status Transaksi'**
  String get transactionStatus;

  /// No description provided for @category.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get category;

  /// No description provided for @noTransactions.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada transaksi'**
  String get noTransactions;

  /// No description provided for @all.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get all;

  /// No description provided for @cancelled.
  ///
  /// In id, this message translates to:
  /// **'Dibatalkan'**
  String get cancelled;

  /// No description provided for @inProgress.
  ///
  /// In id, this message translates to:
  /// **'Diproses'**
  String get inProgress;

  /// No description provided for @approved.
  ///
  /// In id, this message translates to:
  /// **'Disetujui'**
  String get approved;

  /// No description provided for @chooseDate.
  ///
  /// In id, this message translates to:
  /// **'Pilih Tanggal'**
  String get chooseDate;

  /// No description provided for @noMessages.
  ///
  /// In id, this message translates to:
  /// **'Tidak Ada Pesan'**
  String get noMessages;

  /// No description provided for @filterBy.
  ///
  /// In id, this message translates to:
  /// **'Filter berdasar'**
  String get filterBy;

  /// No description provided for @messageDetails.
  ///
  /// In id, this message translates to:
  /// **'Detail Pesan'**
  String get messageDetails;

  /// No description provided for @deleteMessage.
  ///
  /// In id, this message translates to:
  /// **'Hapus Pesan'**
  String get deleteMessage;

  /// No description provided for @deleteConfirmation.
  ///
  /// In id, this message translates to:
  /// **'Anda yakin ingin menghapus'**
  String get deleteConfirmation;

  /// No description provided for @noBeneficiary.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Penerima'**
  String get noBeneficiary;

  /// No description provided for @addBeneficiary.
  ///
  /// In id, this message translates to:
  /// **'Tambah Penerima'**
  String get addBeneficiary;

  /// No description provided for @editBeneficiary.
  ///
  /// In id, this message translates to:
  /// **'Edit Penerima'**
  String get editBeneficiary;

  /// No description provided for @chooseOption.
  ///
  /// In id, this message translates to:
  /// **'Pilih Opsi'**
  String get chooseOption;

  /// No description provided for @accountNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor Rekening'**
  String get accountNumber;

  /// No description provided for @bankName.
  ///
  /// In id, this message translates to:
  /// **'Nama Bank'**
  String get bankName;

  /// No description provided for @editProfile.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get editProfile;

  /// No description provided for @firstName.
  ///
  /// In id, this message translates to:
  /// **'Nama Depan'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In id, this message translates to:
  /// **'Nama Belakang'**
  String get lastName;

  /// No description provided for @phoneNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor Telepon'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @addSavingGoal.
  ///
  /// In id, this message translates to:
  /// **'Tambah Tabungan'**
  String get addSavingGoal;

  /// No description provided for @editSavingGoal.
  ///
  /// In id, this message translates to:
  /// **'Edit Tabungan'**
  String get editSavingGoal;

  /// No description provided for @savingName.
  ///
  /// In id, this message translates to:
  /// **'Nama Tabungan'**
  String get savingName;

  /// No description provided for @enterSavingName.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nama tabungan'**
  String get enterSavingName;

  /// No description provided for @targetAmount.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Target'**
  String get targetAmount;

  /// No description provided for @enterTargetAmount.
  ///
  /// In id, this message translates to:
  /// **'Masukkan target'**
  String get enterTargetAmount;

  /// No description provided for @validAmount.
  ///
  /// In id, this message translates to:
  /// **'Masukkan jumlah yang valid'**
  String get validAmount;

  /// No description provided for @initialDeposit.
  ///
  /// In id, this message translates to:
  /// **'Setoran Awal'**
  String get initialDeposit;

  /// No description provided for @enterInitialDeposit.
  ///
  /// In id, this message translates to:
  /// **'Masukkan setoran awal'**
  String get enterInitialDeposit;

  /// No description provided for @descriptionOptional.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi (Opsional)'**
  String get descriptionOptional;

  /// No description provided for @pickDate.
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal target'**
  String get pickDate;

  /// No description provided for @targetDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Target'**
  String get targetDate;

  /// No description provided for @adminFee.
  ///
  /// In id, this message translates to:
  /// **'Biaya admin Rp2.000'**
  String get adminFee;

  /// No description provided for @cardNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor Kartu'**
  String get cardNumber;

  /// No description provided for @pay.
  ///
  /// In id, this message translates to:
  /// **'Bayar Sekarang'**
  String get pay;

  /// No description provided for @successTopUp.
  ///
  /// In id, this message translates to:
  /// **'Saldo berhasil ditambahkan!'**
  String get successTopUp;

  /// No description provided for @appName.
  ///
  /// In id, this message translates to:
  /// **'CashEase'**
  String get appName;

  /// No description provided for @male.
  ///
  /// In id, this message translates to:
  /// **'Pria'**
  String get male;

  /// No description provided for @female.
  ///
  /// In id, this message translates to:
  /// **'Wanita'**
  String get female;

  /// No description provided for @takPhoto.
  ///
  /// In id, this message translates to:
  /// **'Ambil Foto (Kamera)'**
  String get takPhoto;

  /// No description provided for @chooseGallery.
  ///
  /// In id, this message translates to:
  /// **'Pilih dari Galeri'**
  String get chooseGallery;

  /// No description provided for @profileQr.
  ///
  /// In id, this message translates to:
  /// **'QR Profil'**
  String get profileQr;

  /// No description provided for @profileQrDesc.
  ///
  /// In id, this message translates to:
  /// **'Ajak teman yang ada didekat kamu memindai\nkode QR ini untuk memulai transaksi.'**
  String get profileQrDesc;

  /// No description provided for @close.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get close;

  /// No description provided for @selectBank.
  ///
  /// In id, this message translates to:
  /// **'Pilih Bank'**
  String get selectBank;

  /// No description provided for @enterAmount.
  ///
  /// In id, this message translates to:
  /// **'Masukkan Jumlah'**
  String get enterAmount;

  /// No description provided for @example.
  ///
  /// In id, this message translates to:
  /// **'Contoh'**
  String get example;

  /// No description provided for @fromBank.
  ///
  /// In id, this message translates to:
  /// **'Dari Bank'**
  String get fromBank;

  /// No description provided for @topUpAmount.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Top Up'**
  String get topUpAmount;

  /// No description provided for @pleaseSelectBank.
  ///
  /// In id, this message translates to:
  /// **'Silakan pilih bank'**
  String get pleaseSelectBank;

  /// No description provided for @enterValidAmount.
  ///
  /// In id, this message translates to:
  /// **'Masukkan jumlah yang valid'**
  String get enterValidAmount;

  /// No description provided for @verifyPinCancelled.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi PIN dibatalkan'**
  String get verifyPinCancelled;

  /// No description provided for @topUpSuccess.
  ///
  /// In id, this message translates to:
  /// **'Top Up Berhasil!'**
  String get topUpSuccess;

  /// No description provided for @topUpFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memproses Top Up'**
  String get topUpFailed;

  /// No description provided for @balanceAdded.
  ///
  /// In id, this message translates to:
  /// **'Saldo Rp {amount} telah ditambahkan.'**
  String balanceAdded(Object amount);

  /// No description provided for @transferMoney.
  ///
  /// In id, this message translates to:
  /// **'Kirim Uang ke'**
  String get transferMoney;

  /// No description provided for @yourBalance.
  ///
  /// In id, this message translates to:
  /// **'Saldo Anda:'**
  String get yourBalance;

  /// No description provided for @currencyConversion.
  ///
  /// In id, this message translates to:
  /// **'Konversi Mata Uang'**
  String get currencyConversion;

  /// No description provided for @insufficientBalance.
  ///
  /// In id, this message translates to:
  /// **'Saldo tidak cukup'**
  String get insufficientBalance;

  /// No description provided for @transferFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memproses transfer'**
  String get transferFailed;

  /// No description provided for @failedFetchRate.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengambil nilai tukar'**
  String get failedFetchRate;

  /// No description provided for @requestMoney.
  ///
  /// In id, this message translates to:
  /// **'Minta Uang ke'**
  String get requestMoney;

  /// No description provided for @nominal.
  ///
  /// In id, this message translates to:
  /// **'Nominal (Rp)'**
  String get nominal;

  /// No description provided for @hint.
  ///
  /// In id, this message translates to:
  /// **'contoh: 50000'**
  String get hint;

  /// No description provided for @notes.
  ///
  /// In id, this message translates to:
  /// **'Catatan (Opsional)'**
  String get notes;

  /// No description provided for @requestSent.
  ///
  /// In id, this message translates to:
  /// **'Permintaan terkirim (simulasi).'**
  String get requestSent;

  /// No description provided for @enterValidNominal.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nominal yang valid'**
  String get enterValidNominal;

  /// No description provided for @searchPhoneBank.
  ///
  /// In id, this message translates to:
  /// **'Cari no hp / rekening bank / nama'**
  String get searchPhoneBank;

  /// No description provided for @selectFromContact.
  ///
  /// In id, this message translates to:
  /// **'Pilih dari Kontak'**
  String get selectFromContact;

  /// No description provided for @contact.
  ///
  /// In id, this message translates to:
  /// **'Kontak'**
  String get contact;

  /// No description provided for @otherMethods.
  ///
  /// In id, this message translates to:
  /// **'Metode Lainnya'**
  String get otherMethods;

  /// No description provided for @link.
  ///
  /// In id, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @linkFeatureSimulation.
  ///
  /// In id, this message translates to:
  /// **'Fitur Link (simulasi)'**
  String get linkFeatureSimulation;

  /// No description provided for @qrDetected.
  ///
  /// In id, this message translates to:
  /// **'QR Terdeteksi'**
  String get qrDetected;

  /// No description provided for @enterCode.
  ///
  /// In id, this message translates to:
  /// **'Isi Kode:'**
  String get enterCode;

  /// No description provided for @proceedToPay.
  ///
  /// In id, this message translates to:
  /// **'Lanjut ke pembayaran?'**
  String get proceedToPay;

  /// No description provided for @scanQris.
  ///
  /// In id, this message translates to:
  /// **'Scan QRIS'**
  String get scanQris;

  /// No description provided for @pointCameraQr.
  ///
  /// In id, this message translates to:
  /// **'Arahkan kamera ke kode QR'**
  String get pointCameraQr;

  /// No description provided for @gallery.
  ///
  /// In id, this message translates to:
  /// **'Galeri'**
  String get gallery;

  /// No description provided for @myCode.
  ///
  /// In id, this message translates to:
  /// **'Kode Saya'**
  String get myCode;

  /// No description provided for @galleryFeatureNotActive.
  ///
  /// In id, this message translates to:
  /// **'Fitur Galeri belum aktif'**
  String get galleryFeatureNotActive;

  /// No description provided for @securityCodeYours.
  ///
  /// In id, this message translates to:
  /// **'Security Code Anda'**
  String get securityCodeYours;

  /// No description provided for @code.
  ///
  /// In id, this message translates to:
  /// **'Kode Anda:'**
  String get code;

  /// No description provided for @ok.
  ///
  /// In id, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @securityCode.
  ///
  /// In id, this message translates to:
  /// **'Security Code'**
  String get securityCode;

  /// No description provided for @enterSecurityCode.
  ///
  /// In id, this message translates to:
  /// **'Masukkan Security Code yang tampil di popup'**
  String get enterSecurityCode;

  /// No description provided for @enter6Digit.
  ///
  /// In id, this message translates to:
  /// **'Masukkan 6 digit angka yang ditampilkan sebelumnya'**
  String get enter6Digit;

  /// No description provided for @enterCodeFirst.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kode terlebih dahulu'**
  String get enterCodeFirst;

  /// No description provided for @code6Digit.
  ///
  /// In id, this message translates to:
  /// **'Kode harus 6 digit'**
  String get code6Digit;

  /// No description provided for @submit.
  ///
  /// In id, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @showCodeAgain.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan Ulang Kode'**
  String get showCodeAgain;

  /// No description provided for @wrongCode.
  ///
  /// In id, this message translates to:
  /// **'Kode yang Anda masukkan salah'**
  String get wrongCode;

  /// No description provided for @sessionSavedFor.
  ///
  /// In id, this message translates to:
  /// **'Session saved for:'**
  String get sessionSavedFor;

  /// No description provided for @accountSuccessCreated.
  ///
  /// In id, this message translates to:
  /// **'Akun berhasil dibuat! Selamat datang.'**
  String get accountSuccessCreated;

  /// No description provided for @accountCreationFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal membuat akun. Nomor mungkin sudah terdaftar.'**
  String get accountCreationFailed;

  /// No description provided for @loginSuccess.
  ///
  /// In id, this message translates to:
  /// **'Login berhasil!'**
  String get loginSuccess;

  /// No description provided for @wrongPinOrAccount.
  ///
  /// In id, this message translates to:
  /// **'PIN salah atau akun tidak ditemukan.'**
  String get wrongPinOrAccount;

  /// No description provided for @networkError.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan jaringan. Coba lagi.'**
  String get networkError;

  /// No description provided for @pocketCards.
  ///
  /// In id, this message translates to:
  /// **'Kartu Pocket'**
  String get pocketCards;

  /// No description provided for @searchCard.
  ///
  /// In id, this message translates to:
  /// **'Cari Kartu'**
  String get searchCard;

  /// No description provided for @saveYourCards.
  ///
  /// In id, this message translates to:
  /// **'Simpan kartu bank Anda!'**
  String get saveYourCards;

  /// No description provided for @addCard.
  ///
  /// In id, this message translates to:
  /// **'Tambah Kartu'**
  String get addCard;

  /// No description provided for @cardNumberLast.
  ///
  /// In id, this message translates to:
  /// **'Nomor Kartu (4 digit terakhir)'**
  String get cardNumberLast;

  /// No description provided for @enterLast12Digits.
  ///
  /// In id, this message translates to:
  /// **'Silakan masukkan 4 digit terakhir'**
  String get enterLast12Digits;

  /// No description provided for @enterExactly12Digits.
  ///
  /// In id, this message translates to:
  /// **'Silakan masukkan tepat 4 digit'**
  String get enterExactly12Digits;

  /// No description provided for @previewCard.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau Kartu'**
  String get previewCard;

  /// No description provided for @cardPreview.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau Kartu'**
  String get cardPreview;

  /// No description provided for @progressColon.
  ///
  /// In id, this message translates to:
  /// **'Progress:'**
  String get progressColon;

  /// No description provided for @descriptionColon.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi:'**
  String get descriptionColon;

  /// No description provided for @photoSelectedLocally.
  ///
  /// In id, this message translates to:
  /// **'Foto profil berhasil dipilih (Lokal)'**
  String get photoSelectedLocally;

  /// No description provided for @errorPickingImage.
  ///
  /// In id, this message translates to:
  /// **'Error memilih gambar'**
  String get errorPickingImage;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In id, this message translates to:
  /// **'Profil berhasil diperbarui!'**
  String get profileUpdatedSuccess;

  /// No description provided for @taxPayment.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran Pajak'**
  String get taxPayment;

  /// No description provided for @payTax.
  ///
  /// In id, this message translates to:
  /// **'Bayar Pajak'**
  String get payTax;

  /// No description provided for @taxHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Pajak'**
  String get taxHistory;

  /// No description provided for @pph21.
  ///
  /// In id, this message translates to:
  /// **'PPh 21 (Pajak Penghasilan)'**
  String get pph21;

  /// No description provided for @completed.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get completed;

  /// No description provided for @ppn.
  ///
  /// In id, this message translates to:
  /// **'PPN (Pajak Pertambahan Nilai)'**
  String get ppn;

  /// No description provided for @pph25.
  ///
  /// In id, this message translates to:
  /// **'PPh 25 (Pajak Bulanan)'**
  String get pph25;

  /// No description provided for @pbb.
  ///
  /// In id, this message translates to:
  /// **'PBB (Pajak Bumi Bangunan)'**
  String get pbb;

  /// No description provided for @annual.
  ///
  /// In id, this message translates to:
  /// **'Tahunan'**
  String get annual;

  /// No description provided for @availableBalance.
  ///
  /// In id, this message translates to:
  /// **'Saldo Tersedia'**
  String get availableBalance;

  /// No description provided for @sufficientBalance.
  ///
  /// In id, this message translates to:
  /// **'Saldo cukup untuk pembayaran pajak'**
  String get sufficientBalance;

  /// No description provided for @taxPaymentDetails.
  ///
  /// In id, this message translates to:
  /// **'Detail Pembayaran Pajak'**
  String get taxPaymentDetails;

  /// No description provided for @pph23.
  ///
  /// In id, this message translates to:
  /// **'PPh 23 (Pajak atas Jasa)'**
  String get pph23;

  /// No description provided for @bphtb.
  ///
  /// In id, this message translates to:
  /// **'BPHTB (Pajak Alih Hak)'**
  String get bphtb;

  /// No description provided for @withdrawMethod.
  ///
  /// In id, this message translates to:
  /// **'Metode penarikan'**
  String get withdrawMethod;

  /// No description provided for @adminFeeRp.
  ///
  /// In id, this message translates to:
  /// **'Biaya admin Rp2.000'**
  String get adminFeeRp;

  /// No description provided for @withdrawalSuccess.
  ///
  /// In id, this message translates to:
  /// **'Penarikan Berhasil'**
  String get withdrawalSuccess;

  /// No description provided for @withdrawalTo.
  ///
  /// In id, this message translates to:
  /// **'Penarikan ke'**
  String get withdrawalTo;

  /// No description provided for @allMessages.
  ///
  /// In id, this message translates to:
  /// **'Semua Pesan'**
  String get allMessages;

  /// No description provided for @lessThan10Days.
  ///
  /// In id, this message translates to:
  /// **'Kurang dari 10 hari'**
  String get lessThan10Days;

  /// No description provided for @lessThan20Days.
  ///
  /// In id, this message translates to:
  /// **'Kurang dari 20 hari'**
  String get lessThan20Days;

  /// No description provided for @lessThan30Days.
  ///
  /// In id, this message translates to:
  /// **'Kurang dari 30 hari'**
  String get lessThan30Days;

  /// No description provided for @moreThan30Days.
  ///
  /// In id, this message translates to:
  /// **'Lebih dari 30 hari'**
  String get moreThan30Days;

  /// No description provided for @cashEaseTeam.
  ///
  /// In id, this message translates to:
  /// **'Tim CashEase'**
  String get cashEaseTeam;

  /// No description provided for @welcomeCashEase.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang di CashEase!'**
  String get welcomeCashEase;

  /// No description provided for @thankYou.
  ///
  /// In id, this message translates to:
  /// **'Terima kasih telah memilih CashEase untuk kebutuhan keuangan Anda.'**
  String get thankYou;

  /// No description provided for @today.
  ///
  /// In id, this message translates to:
  /// **'Hari Ini'**
  String get today;

  /// No description provided for @editProfileDesc.
  ///
  /// In id, this message translates to:
  /// **'Ubah nama, email, dan nomor telepon'**
  String get editProfileDesc;

  /// No description provided for @accountSecurityDesc.
  ///
  /// In id, this message translates to:
  /// **'Ubah PIN, atur pertanyaan keamanan'**
  String get accountSecurityDesc;

  /// No description provided for @savedCardsDesc.
  ///
  /// In id, this message translates to:
  /// **'Atur rekening bank & kartu kredit'**
  String get savedCardsDesc;

  /// No description provided for @biometricLogin.
  ///
  /// In id, this message translates to:
  /// **'Login dengan Biometrik'**
  String get biometricLogin;

  /// No description provided for @biometricDesc.
  ///
  /// In id, this message translates to:
  /// **'Gunakan sidik jari atau wajah untuk masuk'**
  String get biometricDesc;

  /// No description provided for @connectedDevices.
  ///
  /// In id, this message translates to:
  /// **'Perangkat Terhubung'**
  String get connectedDevices;

  /// No description provided for @connectedDevicesDesc.
  ///
  /// In id, this message translates to:
  /// **'Lihat dan kelola sesi login aktif'**
  String get connectedDevicesDesc;

  /// No description provided for @promotionOffers.
  ///
  /// In id, this message translates to:
  /// **'Promo & Penawaran'**
  String get promotionOffers;

  /// No description provided for @promotionOffersDesc.
  ///
  /// In id, this message translates to:
  /// **'Dapatkan info promo terbaru'**
  String get promotionOffersDesc;

  /// No description provided for @transactionActivity.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas Transaksi'**
  String get transactionActivity;

  /// No description provided for @transactionActivityDesc.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi untuk setiap transaksi'**
  String get transactionActivityDesc;

  /// No description provided for @helpCenter.
  ///
  /// In id, this message translates to:
  /// **'Pusat Bantuan'**
  String get helpCenter;

  /// No description provided for @aboutApp.
  ///
  /// In id, this message translates to:
  /// **'Tentang Aplikasi'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In id, this message translates to:
  /// **'Versi 1.0.0'**
  String get version;

  /// No description provided for @biometricEnabled.
  ///
  /// In id, this message translates to:
  /// **'Login Biometrik diaktifkan'**
  String get biometricEnabled;

  /// No description provided for @biometricDisabled.
  ///
  /// In id, this message translates to:
  /// **'Login Biometrik dinonaktifkan'**
  String get biometricDisabled;

  /// No description provided for @logoutSuccess.
  ///
  /// In id, this message translates to:
  /// **'Berhasil keluar!'**
  String get logoutSuccess;

  /// No description provided for @general.
  ///
  /// In id, this message translates to:
  /// **'Umum'**
  String get general;

  /// No description provided for @account.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get account;

  /// No description provided for @security.
  ///
  /// In id, this message translates to:
  /// **'Keamanan'**
  String get security;

  /// No description provided for @notifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get notifications;

  /// No description provided for @info.
  ///
  /// In id, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @selectLanguage.
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa'**
  String get selectLanguage;

  /// No description provided for @indonesian.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get indonesian;

  /// No description provided for @japanese.
  ///
  /// In id, this message translates to:
  /// **'日本語 (Japanese)'**
  String get japanese;

  /// No description provided for @korean.
  ///
  /// In id, this message translates to:
  /// **'한국어 (Korean)'**
  String get korean;

  /// No description provided for @chinese.
  ///
  /// In id, this message translates to:
  /// **'中文 (Chinese)'**
  String get chinese;

  /// No description provided for @loadingBalance.
  ///
  /// In id, this message translates to:
  /// **'Memuat saldo...'**
  String get loadingBalance;

  /// No description provided for @salary.
  ///
  /// In id, this message translates to:
  /// **'Gaji'**
  String get salary;

  /// No description provided for @freelance.
  ///
  /// In id, this message translates to:
  /// **'Freelance'**
  String get freelance;

  /// No description provided for @business.
  ///
  /// In id, this message translates to:
  /// **'Bisnis'**
  String get business;

  /// No description provided for @investment.
  ///
  /// In id, this message translates to:
  /// **'Investasi'**
  String get investment;

  /// No description provided for @other.
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get other;

  /// No description provided for @sendToGroup.
  ///
  /// In id, this message translates to:
  /// **'Kirim ke Grup'**
  String get sendToGroup;

  /// No description provided for @sendToFriend.
  ///
  /// In id, this message translates to:
  /// **'Kirim ke Teman'**
  String get sendToFriend;

  /// No description provided for @sendToBank.
  ///
  /// In id, this message translates to:
  /// **'Kirim ke Bank'**
  String get sendToBank;

  /// No description provided for @sendToWallet.
  ///
  /// In id, this message translates to:
  /// **'Kirim ke E-Wallet'**
  String get sendToWallet;

  /// No description provided for @sendCashCode.
  ///
  /// In id, this message translates to:
  /// **'Kirim Kode Uang'**
  String get sendCashCode;

  /// No description provided for @cashPull.
  ///
  /// In id, this message translates to:
  /// **'Tarik Tunai'**
  String get cashPull;

  /// No description provided for @sendToEmail.
  ///
  /// In id, this message translates to:
  /// **'Kirim ke Email'**
  String get sendToEmail;

  /// No description provided for @scanQrCode.
  ///
  /// In id, this message translates to:
  /// **'Pindai Kode QR'**
  String get scanQrCode;

  /// No description provided for @sendToChat.
  ///
  /// In id, this message translates to:
  /// **'Kirim via Chat'**
  String get sendToChat;

  /// No description provided for @searchPhoneReceipt.
  ///
  /// In id, this message translates to:
  /// **'Cari no hp / rekening bank'**
  String get searchPhoneReceipt;

  /// No description provided for @withdrawalMethod.
  ///
  /// In id, this message translates to:
  /// **'Metode Penarikan'**
  String get withdrawalMethod;

  /// No description provided for @requestActive.
  ///
  /// In id, this message translates to:
  /// **'Permintaan Aktif'**
  String get requestActive;

  /// No description provided for @noRequests.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada permintaan aktif'**
  String get noRequests;

  /// No description provided for @personal.
  ///
  /// In id, this message translates to:
  /// **'Pribadi'**
  String get personal;

  /// No description provided for @balanceYours.
  ///
  /// In id, this message translates to:
  /// **'Saldo Anda'**
  String get balanceYours;

  /// No description provided for @income.
  ///
  /// In id, this message translates to:
  /// **'Pemasukan'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In id, this message translates to:
  /// **'Pengeluaran'**
  String get expense;

  /// No description provided for @savingYours.
  ///
  /// In id, this message translates to:
  /// **'Tabungan Anda'**
  String get savingYours;

  /// No description provided for @addNewSaving.
  ///
  /// In id, this message translates to:
  /// **'Tambah Tabungan Baru'**
  String get addNewSaving;

  /// No description provided for @noSavings.
  ///
  /// In id, this message translates to:
  /// **'Belum ada tabungan'**
  String get noSavings;

  /// No description provided for @emergencySaving.
  ///
  /// In id, this message translates to:
  /// **'Tabungan Darurat'**
  String get emergencySaving;

  /// No description provided for @taxType.
  ///
  /// In id, this message translates to:
  /// **'Jenis Pajak'**
  String get taxType;

  /// No description provided for @npwpNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor NPWP'**
  String get npwpNumber;

  /// No description provided for @enterNpwp.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nomor NPWP Anda'**
  String get enterNpwp;

  /// No description provided for @enterNpwpFirst.
  ///
  /// In id, this message translates to:
  /// **'Silakan masukkan nomor NPWP'**
  String get enterNpwpFirst;

  /// No description provided for @npwpDigits.
  ///
  /// In id, this message translates to:
  /// **'NPWP harus 15 digit'**
  String get npwpDigits;

  /// No description provided for @taxYear.
  ///
  /// In id, this message translates to:
  /// **'Tahun Pajak'**
  String get taxYear;

  /// No description provided for @taxPeriod.
  ///
  /// In id, this message translates to:
  /// **'Periode Pajak'**
  String get taxPeriod;

  /// No description provided for @enterTaxAmount.
  ///
  /// In id, this message translates to:
  /// **'Masukkan jumlah pajak yang akan dibayar'**
  String get enterTaxAmount;

  /// No description provided for @addPaymentDescription.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan deskripsi pembayaran'**
  String get addPaymentDescription;

  /// No description provided for @payTaxButton.
  ///
  /// In id, this message translates to:
  /// **'Bayar Pajak Sekarang'**
  String get payTaxButton;

  /// No description provided for @confirmPayment.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Pembayaran'**
  String get confirmPayment;

  /// No description provided for @taxTypeLabel.
  ///
  /// In id, this message translates to:
  /// **'Jenis Pajak:'**
  String get taxTypeLabel;

  /// No description provided for @npwpLabel.
  ///
  /// In id, this message translates to:
  /// **'NPWP:'**
  String get npwpLabel;

  /// No description provided for @periodLabel.
  ///
  /// In id, this message translates to:
  /// **'Periode:'**
  String get periodLabel;

  /// No description provided for @amountLabel.
  ///
  /// In id, this message translates to:
  /// **'Jumlah:'**
  String get amountLabel;

  /// No description provided for @paymentSuccessful.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran Berhasil!'**
  String get paymentSuccessful;

  /// No description provided for @paymentSuccessMessage.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran pajak Anda sebesar Rp {amount} telah diproses dengan sukses.'**
  String paymentSuccessMessage(Object amount);

  /// No description provided for @viewHistory.
  ///
  /// In id, this message translates to:
  /// **'Lihat Riwayat'**
  String get viewHistory;

  /// No description provided for @makeAnotherPayment.
  ///
  /// In id, this message translates to:
  /// **'Lakukan Pembayaran Lain'**
  String get makeAnotherPayment;

  /// No description provided for @recentTaxPayments.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran Pajak Terakhir'**
  String get recentTaxPayments;

  /// No description provided for @thisMonth.
  ///
  /// In id, this message translates to:
  /// **'Bulan Ini'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In id, this message translates to:
  /// **'Tahun Ini'**
  String get thisYear;

  /// No description provided for @noTaxPayments.
  ///
  /// In id, this message translates to:
  /// **'Belum ada pembayaran pajak'**
  String get noTaxPayments;
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
      <String>['en', 'id', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
