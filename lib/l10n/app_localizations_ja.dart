// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get settingsTitle => '設定';

  @override
  String get changeLanguage => '言語を変更';

  @override
  String get languageName => '日本語';

  @override
  String get homeTitle => 'ホーム';

  @override
  String get profileTitle => 'プロフィール';

  @override
  String get transactionHistory => '取引履歴';

  @override
  String get pocketTitle => 'マイポケット';

  @override
  String get balance => '残高';

  @override
  String get topUp => 'チャージ';

  @override
  String get send => '送金';

  @override
  String get request => '請求';

  @override
  String get withdraw => '引き出し';

  @override
  String get login => 'ログイン';

  @override
  String get logout => 'ログアウト';

  @override
  String get logoutConfirmation => 'ログアウトしてもよろしいですか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get success => '成功';

  @override
  String get failed => '失敗';

  @override
  String get confirm => '確認';

  @override
  String get reset => 'リセット';

  @override
  String get apply => '適用';

  @override
  String get active => 'アクティブ';

  @override
  String get amount => '金額';

  @override
  String get date => '日付';

  @override
  String get search => '検索';

  @override
  String get searchHint => '検索...';

  @override
  String get continueButton => '次へ';

  @override
  String get menuTransfer => '振込';

  @override
  String get menuCreditCard => 'クレジットカード';

  @override
  String get menuBeneficiary => '受取人';

  @override
  String get menuBills => '請求書払い';

  @override
  String get menuTaxesLoan => '税金/ローン';

  @override
  String get menuTaxes => '税金';

  @override
  String get menuTaxesDesc => '税金を納める';

  @override
  String get menuLoan => 'ローン';

  @override
  String get menuLoanDesc => 'ローンの返済管理';

  @override
  String welcomeUser(Object name) {
    return 'ようこそ、$nameさん';
  }

  @override
  String get services => 'サービス';

  @override
  String get financial => '金融';

  @override
  String get utilities => 'ユーティリティ';

  @override
  String get support => 'サポート';

  @override
  String get helpSupport => 'ヘルプとサポート';

  @override
  String get inbox => '受信トレイ';

  @override
  String get mobilePrepaid => 'プリペイド携帯';

  @override
  String get savings => '貯金';

  @override
  String get loginAppTitle => 'CashEase';

  @override
  String get loginSubtitle => 'あなたのデジタルウォレット！';

  @override
  String get loginPrompt => '電話番号でログイン/登録';

  @override
  String get loginSubPrompt => '最高の機能をお楽しみください';

  @override
  String get phoneHint => '81234567890';

  @override
  String get phoneError => '電話番号は12桁である必要があります';

  @override
  String get phoneNotRegistered => '電話番号が登録されていません';

  @override
  String get pinTitle => 'PINを入力';

  @override
  String get newPin => '新しいPIN';

  @override
  String get resetPin => 'PINをリセット';

  @override
  String get resetPinTitle => 'PINをリセットする';

  @override
  String get resetPinSubtitle => '電話番号を確認し、新しいPINを入力してください';

  @override
  String get pinLengthError => 'PINは5桁である必要があります';

  @override
  String get pinChangedSuccess => 'PINが正常に変更されました！';

  @override
  String get forgotPin => 'PINを忘れましたか？';

  @override
  String get transNotif => '取引アクティビティ';

  @override
  String get transactionStatus => '取引ステータス';

  @override
  String get category => 'カテゴリ';

  @override
  String get noTransactions => '取引が見つかりません';

  @override
  String get all => 'すべて';

  @override
  String get cancelled => 'キャンセル済み';

  @override
  String get inProgress => '進行中';

  @override
  String get approved => '承認済み';

  @override
  String get chooseDate => '日付を選択';

  @override
  String get noMessages => 'メッセージなし';

  @override
  String get filterBy => 'フィルター';

  @override
  String get messageDetails => 'メッセージ詳細';

  @override
  String get deleteMessage => 'メッセージを削除';

  @override
  String get deleteConfirmation => '本当に削除しますか';

  @override
  String get noBeneficiary => '受取人がいません';

  @override
  String get addBeneficiary => '受取人を追加';

  @override
  String get editBeneficiary => '受取人を編集';

  @override
  String get chooseOption => 'オプションを選択';

  @override
  String get accountNumber => '口座番号';

  @override
  String get bankName => '銀行名';

  @override
  String get editProfile => 'プロフィール編集';

  @override
  String get firstName => '名';

  @override
  String get lastName => '姓';

  @override
  String get phoneNumber => '電話番号';

  @override
  String get email => 'メールアドレス';

  @override
  String get addSavingGoal => '貯金目標を追加';

  @override
  String get editSavingGoal => '貯金目標を編集';

  @override
  String get savingName => '目標名';

  @override
  String get enterSavingName => '目標名を入力';

  @override
  String get targetAmount => '目標金額';

  @override
  String get enterTargetAmount => '目標金額を入力';

  @override
  String get validAmount => '有効な金額を入力してください';

  @override
  String get initialDeposit => '初回入金';

  @override
  String get enterInitialDeposit => '初回入金額を入力';

  @override
  String get descriptionOptional => '説明（オプション）';

  @override
  String get pickDate => '目標日を選択';

  @override
  String get targetDate => '目標日';

  @override
  String get adminFee => '手数料 ¥2,000';

  @override
  String get cardNumber => 'カード番号';

  @override
  String get pay => '今すぐ支払う';

  @override
  String get successTopUp => 'チャージが完了しました!';

  @override
  String get appName => 'CashEase';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get takPhoto => '写真を撮る (カメラ)';

  @override
  String get chooseGallery => 'ギャラリーから選択';

  @override
  String get profileQr => 'プロフィールQR';

  @override
  String get profileQrDesc => '近くの友人にこのQRコードをスキャンさせて、取引を開始します。';

  @override
  String get close => '閉じる';

  @override
  String get selectBank => '銀行を選択';

  @override
  String get enterAmount => '金額を入力';

  @override
  String get example => '例';

  @override
  String get fromBank => '銀行から';

  @override
  String get topUpAmount => 'チャージ金額';

  @override
  String get pleaseSelectBank => '銀行を選択してください';

  @override
  String get enterValidAmount => '有効な金額を入力してください';

  @override
  String get verifyPinCancelled => 'PIN認証がキャンセルされました';

  @override
  String get topUpSuccess => 'チャージ完了!';

  @override
  String get topUpFailed => 'チャージ処理に失敗しました';

  @override
  String balanceAdded(Object amount) {
    return '残高 ¥$amount が追加されました。';
  }

  @override
  String get transferMoney => '送金先';

  @override
  String get yourBalance => '現在の残高:';

  @override
  String get currencyConversion => '通貨換算';

  @override
  String get insufficientBalance => '残高不足';

  @override
  String get transferFailed => '送金処理に失敗しました';

  @override
  String get failedFetchRate => '為替レート取得に失敗しました';

  @override
  String get requestMoney => 'お金をリクエスト';

  @override
  String get nominal => '金額 (¥)';

  @override
  String get hint => '例: 50000';

  @override
  String get notes => 'メモ (オプション)';

  @override
  String get requestSent => 'リクエストが送信されました (シミュレーション)。';

  @override
  String get enterValidNominal => '有効な金額を入力してください';

  @override
  String get searchPhoneBank => '電話番号 / 銀行口座 / 名前で検索';

  @override
  String get selectFromContact => '連絡先から選択';

  @override
  String get contact => '連絡先';

  @override
  String get otherMethods => 'その他の方法';

  @override
  String get link => 'リンク';

  @override
  String get linkFeatureSimulation => 'リンク機能 (シミュレーション)';

  @override
  String get qrDetected => 'QRコード検出';

  @override
  String get enterCode => 'コードを入力:';

  @override
  String get proceedToPay => '支払いに進む?';

  @override
  String get scanQris => 'QRISをスキャン';

  @override
  String get pointCameraQr => 'カメラをQRコードに向ける';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get myCode => 'マイコード';

  @override
  String get galleryFeatureNotActive => 'ギャラリー機能はまだアクティブではありません';

  @override
  String get securityCodeYours => 'あなたのセキュリティコード';

  @override
  String get code => 'あなたのコード:';

  @override
  String get ok => 'OK';

  @override
  String get securityCode => 'セキュリティコード';

  @override
  String get enterSecurityCode => 'ポップアップに表示されるセキュリティコードを入力';

  @override
  String get enter6Digit => '以前に表示された6桁のコードを入力';

  @override
  String get enterCodeFirst => 'まずコードを入力してください';

  @override
  String get code6Digit => 'コードは6桁である必要があります';

  @override
  String get submit => '送信';

  @override
  String get showCodeAgain => 'コードを再表示';

  @override
  String get wrongCode => '入力したコードが間違っています';

  @override
  String get sessionSavedFor => 'Session saved for:';

  @override
  String get accountSuccessCreated => 'アカウントが正常に作成されました! ようこそ。';

  @override
  String get accountCreationFailed => 'アカウント作成に失敗しました。この番号は既に登録されている可能性があります。';

  @override
  String get loginSuccess => 'ログインしました!';

  @override
  String get wrongPinOrAccount => 'PINが間違っているか、アカウントが見つかりません。';

  @override
  String get networkError => 'ネットワークエラーが発生しました。もう一度お試しください。';

  @override
  String get pocketCards => 'ポケットカード';

  @override
  String get searchCard => 'カードを検索';

  @override
  String get saveYourCards => '銀行カードを保存してください!';

  @override
  String get addCard => 'カードを追加';

  @override
  String get cardNumberLast => 'カード番号 (最後の12桁)';

  @override
  String get enterLast12Digits => '最後の12桁を入力してください';

  @override
  String get enterExactly12Digits => '正確に12桁を入力してください';

  @override
  String get previewCard => 'カードをプレビュー';

  @override
  String get cardPreview => 'カードプレビュー';

  @override
  String get progressColon => '進捗:';

  @override
  String get descriptionColon => '説明:';

  @override
  String get photoSelectedLocally => '写真が正常に選択されました (ローカル)';

  @override
  String get errorPickingImage => '画像選択エラー';

  @override
  String get profileUpdatedSuccess => 'プロフィールが正常に更新されました!';

  @override
  String get taxPayment => '税金支払い';

  @override
  String get payTax => '税金を支払う';

  @override
  String get taxHistory => '税金履歴';

  @override
  String get pph21 => '所得税';

  @override
  String get completed => '完了';

  @override
  String get ppn => '付加価値税';

  @override
  String get pph25 => '月間税';

  @override
  String get pbb => '固定資産税';

  @override
  String get annual => '年間';

  @override
  String get availableBalance => '利用可能残高';

  @override
  String get sufficientBalance => '税金支払い用の残高は十分です';

  @override
  String get taxPaymentDetails => '税金支払いの詳細';

  @override
  String get pph23 => 'サービス税';

  @override
  String get bphtb => '不動産譲渡税';

  @override
  String get withdrawMethod => '出金方法';

  @override
  String get adminFeeRp => '管理手数料 ¥2,000';

  @override
  String get withdrawalSuccess => '出金完了';

  @override
  String get withdrawalTo => '出金先';

  @override
  String get allMessages => 'すべてのメッセージ';

  @override
  String get lessThan10Days => '10日未満';

  @override
  String get lessThan20Days => '20日未満';

  @override
  String get lessThan30Days => '30日未満';

  @override
  String get moreThan30Days => '30日以上';

  @override
  String get cashEaseTeam => 'CashEaseチーム';

  @override
  String get welcomeCashEase => 'CashEaseへようこそ!';

  @override
  String get thankYou => 'あなたの金銭的ニーズのためにCashEaseを選んでいただきありがとうございます。';

  @override
  String get today => '今日';

  @override
  String get editProfileDesc => '名前、メール、電話番号を変更';

  @override
  String get accountSecurityDesc => 'PIN変更、セキュリティ質問設定';

  @override
  String get savedCardsDesc => '銀行口座とクレジットカード設定';

  @override
  String get biometricLogin => '生体認証ログイン';

  @override
  String get biometricDesc => '指紋または顔を使ってログイン';

  @override
  String get connectedDevices => '接続されたデバイス';

  @override
  String get connectedDevicesDesc => 'アクティブなログインセッションを表示・管理';

  @override
  String get promotionOffers => 'プロモーション&オファー';

  @override
  String get promotionOffersDesc => '最新プロモ情報を取得';

  @override
  String get transactionActivity => '取引活動';

  @override
  String get transactionActivityDesc => '各取引の通知';

  @override
  String get helpCenter => 'ヘルプセンター';

  @override
  String get aboutApp => 'このアプリケーションについて';

  @override
  String get version => 'バージョン 1.0.0';

  @override
  String get biometricEnabled => '生体認証ログイン有効';

  @override
  String get biometricDisabled => '生体認証ログイン無効';

  @override
  String get logoutSuccess => 'ログアウトしました!';

  @override
  String get general => '一般';

  @override
  String get account => 'アカウント';

  @override
  String get security => 'セキュリティ';

  @override
  String get notifications => '通知';

  @override
  String get info => '情報';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get chinese => '中文';

  @override
  String get loadingBalance => '残高を読み込み中...';

  @override
  String get salary => '給料';

  @override
  String get freelance => 'フリーランス';

  @override
  String get business => 'ビジネス';

  @override
  String get investment => '投資';

  @override
  String get other => 'その他';

  @override
  String get sendToGroup => 'グループに送信';

  @override
  String get sendToFriend => '友人に送信';

  @override
  String get sendToBank => '銀行に送信';

  @override
  String get sendToWallet => '電子ウォレットに送信';

  @override
  String get sendCashCode => '現金コードを送信';

  @override
  String get cashPull => '現金引き出し';

  @override
  String get sendToEmail => 'メールで送信';

  @override
  String get scanQrCode => 'QRコードをスキャン';

  @override
  String get sendToChat => 'チャットで送信';

  @override
  String get searchPhoneReceipt => '電話番号 / 銀行口座を検索';

  @override
  String get withdrawalMethod => '出金方法';

  @override
  String get requestActive => 'アクティブなリクエスト';

  @override
  String get noRequests => 'アクティブなリクエストはありません';

  @override
  String get personal => '個人';

  @override
  String get balanceYours => 'あなたのバランス';

  @override
  String get income => '収入';

  @override
  String get expense => '支出';

  @override
  String get savingYours => 'あなたの貯金';

  @override
  String get addNewSaving => '新しい貯金を追加';

  @override
  String get noSavings => '貯金はまだありません';

  @override
  String get emergencySaving => '緊急貯金';

  @override
  String get taxType => '税の種類';

  @override
  String get npwpNumber => 'NPWP番号';

  @override
  String get enterNpwp => 'NPWP番号を入力してください';

  @override
  String get enterNpwpFirst => 'NPWP番号を入力してください';

  @override
  String get npwpDigits => 'NPWPは15桁である必要があります';

  @override
  String get taxYear => '税務年度';

  @override
  String get taxPeriod => '税務期間';

  @override
  String get enterTaxAmount => '支払う税額を入力してください';

  @override
  String get addPaymentDescription => '支払い説明を追加';

  @override
  String get payTaxButton => '今すぐ税金を支払う';

  @override
  String get confirmPayment => '支払いを確認';

  @override
  String get taxTypeLabel => '税の種類:';

  @override
  String get npwpLabel => 'NPWP:';

  @override
  String get periodLabel => '期間:';

  @override
  String get amountLabel => '金額:';

  @override
  String get paymentSuccessful => '支払いが成功しました！';

  @override
  String paymentSuccessMessage(Object amount) {
    return 'Rp $amountの税金支払いが正常に処理されました。';
  }

  @override
  String get viewHistory => '履歴を表示';

  @override
  String get makeAnotherPayment => '別の支払いを行う';

  @override
  String get recentTaxPayments => '最近の税金支払い';

  @override
  String get thisMonth => '今月';

  @override
  String get thisYear => '今年';

  @override
  String get noTaxPayments => '税金の支払いはまだありません';
}
