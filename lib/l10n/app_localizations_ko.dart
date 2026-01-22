// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get settingsTitle => '설정';

  @override
  String get changeLanguage => '언어 변경';

  @override
  String get languageName => '한국어';

  @override
  String get homeTitle => '홈';

  @override
  String get profileTitle => '프로필';

  @override
  String get transactionHistory => '거래 내역';

  @override
  String get pocketTitle => '내 포켓';

  @override
  String get balance => '잔액';

  @override
  String get topUp => '충전';

  @override
  String get send => '송금';

  @override
  String get request => '요청';

  @override
  String get withdraw => '출금';

  @override
  String get login => '로그인';

  @override
  String get logout => '로그아웃';

  @override
  String get logoutConfirmation => '로그아웃 하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get edit => '편집';

  @override
  String get success => '성공';

  @override
  String get failed => '실패';

  @override
  String get confirm => '확인';

  @override
  String get reset => '초기화';

  @override
  String get apply => '적용';

  @override
  String get active => '활성';

  @override
  String get amount => '금액';

  @override
  String get date => '날짜';

  @override
  String get search => '검색';

  @override
  String get searchHint => '검색...';

  @override
  String get continueButton => '계속';

  @override
  String get menuTransfer => '이체';

  @override
  String get menuCreditCard => '신용카드';

  @override
  String get menuBeneficiary => '수취인';

  @override
  String get menuBills => '요금 납부';

  @override
  String get menuTaxesLoan => '세금/대출';

  @override
  String get menuTaxes => '세금';

  @override
  String get menuTaxesDesc => '세금 납부';

  @override
  String get menuLoan => '대출';

  @override
  String get menuLoanDesc => '대출 상환 관리';

  @override
  String welcomeUser(Object name) {
    return '안녕하세요, $name님';
  }

  @override
  String get services => '서비스';

  @override
  String get financial => '금융';

  @override
  String get utilities => '공과금';

  @override
  String get support => '지원';

  @override
  String get helpSupport => '고객센터';

  @override
  String get inbox => '받은 편지함';

  @override
  String get mobilePrepaid => '선불 요금';

  @override
  String get savings => '저축';

  @override
  String get loginAppTitle => 'CashEase';

  @override
  String get loginSubtitle => '당신을 위한 디지털 지갑!';

  @override
  String get loginPrompt => '전화번호로 로그인/가입';

  @override
  String get loginSubPrompt => '최고의 기능을 즐겨보세요';

  @override
  String get phoneHint => '81234567890';

  @override
  String get phoneError => '전화번호는 12자리여야 합니다';

  @override
  String get phoneNotRegistered => '등록되지 않은 번호입니다';

  @override
  String get pinTitle => 'PIN 입력';

  @override
  String get newPin => '새 PIN';

  @override
  String get resetPin => 'PIN 재설정';

  @override
  String get resetPinTitle => 'PIN 재설정';

  @override
  String get resetPinSubtitle => '전화번호 확인 및 새 PIN 입력';

  @override
  String get pinLengthError => 'PIN은 5자리여야 합니다';

  @override
  String get pinChangedSuccess => 'PIN이 성공적으로 변경되었습니다!';

  @override
  String get forgotPin => 'PIN을 잊으셨나요?';

  @override
  String get transNotif => '거래 활동';

  @override
  String get transactionStatus => '거래 상태';

  @override
  String get category => '카테고리';

  @override
  String get noTransactions => '거래 없음';

  @override
  String get all => '전체';

  @override
  String get cancelled => '취소됨';

  @override
  String get inProgress => '진행 중';

  @override
  String get approved => '승인됨';

  @override
  String get chooseDate => '날짜 선택';

  @override
  String get noMessages => '메시지 없음';

  @override
  String get filterBy => '필터';

  @override
  String get messageDetails => '메시지 상세';

  @override
  String get deleteMessage => '메시지 삭제';

  @override
  String get deleteConfirmation => '정말 삭제하시겠습니까';

  @override
  String get noBeneficiary => '수취인 없음';

  @override
  String get addBeneficiary => '수취인 추가';

  @override
  String get editBeneficiary => '수취인 편집';

  @override
  String get chooseOption => '옵션 선택';

  @override
  String get accountNumber => '계좌 번호';

  @override
  String get bankName => '은행명';

  @override
  String get editProfile => '프로필 수정';

  @override
  String get firstName => '이름';

  @override
  String get lastName => '성';

  @override
  String get phoneNumber => '전화번호';

  @override
  String get email => '이메일';

  @override
  String get addSavingGoal => '저축 목표 추가';

  @override
  String get editSavingGoal => '저축 목표 수정';

  @override
  String get savingName => '목표 이름';

  @override
  String get enterSavingName => '목표 이름 입력';

  @override
  String get targetAmount => '목표 금액';

  @override
  String get enterTargetAmount => '목표 금액 입력';

  @override
  String get validAmount => '유효한 금액을 입력하세요';

  @override
  String get initialDeposit => '초기 입금';

  @override
  String get enterInitialDeposit => '초기 입금액 입력';

  @override
  String get descriptionOptional => '설명 (선택사항)';

  @override
  String get pickDate => '목표 날짜 선택';

  @override
  String get targetDate => '목표 날짜';

  @override
  String get adminFee => '수수료 ₩2,000';

  @override
  String get cardNumber => '카드 번호';

  @override
  String get pay => '지금 결제';

  @override
  String get successTopUp => '충전이 완료되었습니다!';

  @override
  String get appName => 'CashEase';

  @override
  String get male => '남성';

  @override
  String get female => '여성';

  @override
  String get takPhoto => '사진 촬영 (카메라)';

  @override
  String get chooseGallery => '갤러리에서 선택';

  @override
  String get profileQr => '프로필 QR';

  @override
  String get profileQrDesc => '근처의 친구에게 이 QR 코드를 스캔하도록 요청하여 거래를 시작하세요.';

  @override
  String get close => '닫기';

  @override
  String get selectBank => '은행 선택';

  @override
  String get enterAmount => '금액 입력';

  @override
  String get example => '예시';

  @override
  String get fromBank => '은행에서';

  @override
  String get topUpAmount => '충전 금액';

  @override
  String get pleaseSelectBank => '은행을 선택해주세요';

  @override
  String get enterValidAmount => '유효한 금액을 입력하세요';

  @override
  String get verifyPinCancelled => 'PIN 인증이 취소되었습니다';

  @override
  String get topUpSuccess => '충전 완료!';

  @override
  String get topUpFailed => '충전 처리에 실패했습니다';

  @override
  String balanceAdded(Object amount) {
    return '잔액 ₩$amount가 추가되었습니다.';
  }

  @override
  String get transferMoney => '송금 대상';

  @override
  String get yourBalance => '현재 잔액:';

  @override
  String get currencyConversion => '통화 환산';

  @override
  String get insufficientBalance => '잔액이 부족합니다';

  @override
  String get transferFailed => '송금 처리에 실패했습니다';

  @override
  String get failedFetchRate => '환율 조회에 실패했습니다';

  @override
  String get requestMoney => '돈 요청';

  @override
  String get nominal => '금액 (₩)';

  @override
  String get hint => '예: 50000';

  @override
  String get notes => '메모 (선택사항)';

  @override
  String get requestSent => '요청이 전송되었습니다 (시뮬레이션).';

  @override
  String get enterValidNominal => '유효한 금액을 입력하세요';

  @override
  String get searchPhoneBank => '전화번호 / 계좌 / 이름으로 검색';

  @override
  String get selectFromContact => '연락처에서 선택';

  @override
  String get contact => '연락처';

  @override
  String get otherMethods => '기타 방법';

  @override
  String get link => '링크';

  @override
  String get linkFeatureSimulation => '링크 기능 (시뮬레이션)';

  @override
  String get qrDetected => 'QR 감지됨';

  @override
  String get enterCode => '코드 입력:';

  @override
  String get proceedToPay => '결제 진행하시겠습니까?';

  @override
  String get scanQris => 'QRIS 스캔';

  @override
  String get pointCameraQr => '카메라를 QR 코드로 향하기';

  @override
  String get gallery => '갤러리';

  @override
  String get myCode => '내 코드';

  @override
  String get galleryFeatureNotActive => '갤러리 기능이 아직 활성화되지 않았습니다';

  @override
  String get securityCodeYours => '귀하의 보안 코드';

  @override
  String get code => '귀하의 코드:';

  @override
  String get ok => '확인';

  @override
  String get securityCode => '보안 코드';

  @override
  String get enterSecurityCode => '팝업에 표시되는 보안 코드를 입력하세요';

  @override
  String get enter6Digit => '이전에 표시된 6자리 코드를 입력하세요';

  @override
  String get enterCodeFirst => '먼저 코드를 입력하세요';

  @override
  String get code6Digit => '코드는 6자리여야 합니다';

  @override
  String get submit => '제출';

  @override
  String get showCodeAgain => '코드 다시 표시';

  @override
  String get wrongCode => '입력한 코드가 잘못되었습니다';

  @override
  String get sessionSavedFor => 'Session saved for:';

  @override
  String get accountSuccessCreated => '계정이 성공적으로 생성되었습니다! 환영합니다.';

  @override
  String get accountCreationFailed => '계정 생성에 실패했습니다. 이 번호는 이미 등록되어 있을 수 있습니다.';

  @override
  String get loginSuccess => '로그인되었습니다!';

  @override
  String get wrongPinOrAccount => 'PIN이 잘못되었거나 계정을 찾을 수 없습니다.';

  @override
  String get networkError => '네트워크 오류가 발생했습니다. 다시 시도해주세요.';

  @override
  String get pocketCards => '포켓 카드';

  @override
  String get searchCard => '카드 검색';

  @override
  String get saveYourCards => '은행 카드를 저장하세요!';

  @override
  String get addCard => '카드 추가';

  @override
  String get cardNumberLast => '카드 번호 (마지막 12자리)';

  @override
  String get enterLast12Digits => '마지막 12자리를 입력해주세요';

  @override
  String get enterExactly12Digits => '정확히 12자리를 입력해주세요';

  @override
  String get previewCard => '카드 미리보기';

  @override
  String get cardPreview => '카드 미리보기';

  @override
  String get progressColon => '진행:';

  @override
  String get descriptionColon => '설명:';

  @override
  String get photoSelectedLocally => '사진이 성공적으로 선택되었습니다 (로컬)';

  @override
  String get errorPickingImage => '이미지 선택 오류';

  @override
  String get profileUpdatedSuccess => '프로필이 성공적으로 업데이트되었습니다!';

  @override
  String get taxPayment => '세금 납부';

  @override
  String get payTax => '세금 납부';

  @override
  String get taxHistory => '세금 내역';

  @override
  String get pph21 => '소득세';

  @override
  String get completed => '완료됨';

  @override
  String get ppn => '부가가치세';

  @override
  String get pph25 => '월간 세금';

  @override
  String get pbb => '재산세';

  @override
  String get annual => '연간';

  @override
  String get availableBalance => '사용 가능한 잔액';

  @override
  String get sufficientBalance => '세금 납부에 충분한 잔액입니다';

  @override
  String get taxPaymentDetails => '세금 납부 세부사항';

  @override
  String get pph23 => '용역세';

  @override
  String get bphtb => '부동산 양도세';

  @override
  String get withdrawMethod => '출금 방법';

  @override
  String get adminFeeRp => '관리 수수료 ₩2,000';

  @override
  String get withdrawalSuccess => '출금 완료';

  @override
  String get withdrawalTo => '출금 대상';

  @override
  String get allMessages => '모든 메시지';

  @override
  String get lessThan10Days => '10일 미만';

  @override
  String get lessThan20Days => '20일 미만';

  @override
  String get lessThan30Days => '30일 미만';

  @override
  String get moreThan30Days => '30일 이상';

  @override
  String get cashEaseTeam => 'CashEase 팀';

  @override
  String get welcomeCashEase => 'CashEase에 환영합니다!';

  @override
  String get thankYou => '재정적 필요를 위해 CashEase를 선택해주셔서 감사합니다.';

  @override
  String get today => '오늘';

  @override
  String get editProfileDesc => '이름, 이메일 및 전화번호 변경';

  @override
  String get accountSecurityDesc => 'PIN 변경, 보안 질문 설정';

  @override
  String get savedCardsDesc => '은행 계좌 및 신용카드 설정';

  @override
  String get biometricLogin => '생체 인식 로그인';

  @override
  String get biometricDesc => '지문 또는 얼굴을 사용하여 로그인';

  @override
  String get connectedDevices => '연결된 기기';

  @override
  String get connectedDevicesDesc => '활성 로그인 세션 보기 및 관리';

  @override
  String get promotionOffers => '프로모션&오퍼';

  @override
  String get promotionOffersDesc => '최신 프로모 정보 받기';

  @override
  String get transactionActivity => '거래 활동';

  @override
  String get transactionActivityDesc => '모든 거래 알림';

  @override
  String get helpCenter => '도움말 센터';

  @override
  String get aboutApp => '이 애플리케이션 정보';

  @override
  String get version => '버전 1.0.0';

  @override
  String get biometricEnabled => '생체 인식 로그인 활성화';

  @override
  String get biometricDisabled => '생체 인식 로그인 비활성화';

  @override
  String get logoutSuccess => '로그아웃되었습니다!';

  @override
  String get general => '일반';

  @override
  String get account => '계정';

  @override
  String get security => '보안';

  @override
  String get notifications => '알림';

  @override
  String get info => '정보';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get chinese => '中文';

  @override
  String get loadingBalance => '잔액 로드 중...';

  @override
  String get salary => '급여';

  @override
  String get freelance => '프리랜서';

  @override
  String get business => '사업';

  @override
  String get investment => '투자';

  @override
  String get other => '기타';

  @override
  String get sendToGroup => '그룹에 전송';

  @override
  String get sendToFriend => '친구에게 전송';

  @override
  String get sendToBank => '은행에 전송';

  @override
  String get sendToWallet => '전자지갑에 전송';

  @override
  String get sendCashCode => '현금 코드 전송';

  @override
  String get cashPull => '현금 출금';

  @override
  String get sendToEmail => '이메일로 전송';

  @override
  String get scanQrCode => 'QR 코드 스캔';

  @override
  String get sendToChat => '채팅으로 전송';

  @override
  String get searchPhoneReceipt => '전화번호 / 은행계좌 검색';

  @override
  String get withdrawalMethod => '출금 방법';

  @override
  String get requestActive => '활성 요청';

  @override
  String get noRequests => '활성 요청이 없습니다';

  @override
  String get personal => '개인';

  @override
  String get balanceYours => '당신의 잔액';

  @override
  String get income => '수입';

  @override
  String get expense => '지출';

  @override
  String get savingYours => '당신의 저축';

  @override
  String get addNewSaving => '새로운 저축 추가';

  @override
  String get noSavings => '아직 저축이 없습니다';

  @override
  String get emergencySaving => '긴급 저축';

  @override
  String get taxType => '세금 유형';

  @override
  String get npwpNumber => 'NPWP 번호';

  @override
  String get enterNpwp => 'NPWP 번호를 입력하세요';

  @override
  String get enterNpwpFirst => 'NPWP 번호를 입력해주세요';

  @override
  String get npwpDigits => 'NPWP는 15자리여야 합니다';

  @override
  String get taxYear => '세금 연도';

  @override
  String get taxPeriod => '세금 기간';

  @override
  String get enterTaxAmount => '납부할 세금 금액을 입력하세요';

  @override
  String get addPaymentDescription => '결제 설명을 추가하세요';

  @override
  String get payTaxButton => '지금 세금 납부';

  @override
  String get confirmPayment => '결제 확인';

  @override
  String get taxTypeLabel => '세금 유형:';

  @override
  String get npwpLabel => 'NPWP:';

  @override
  String get periodLabel => '기간:';

  @override
  String get amountLabel => '금액:';

  @override
  String get paymentSuccessful => '결제 성공!';

  @override
  String paymentSuccessMessage(Object amount) {
    return 'Rp $amount의 세금 납부가 성공적으로 처리되었습니다.';
  }

  @override
  String get viewHistory => '거래 내역 보기';

  @override
  String get makeAnotherPayment => '다른 결제 하기';

  @override
  String get recentTaxPayments => '최근 세금 납부';

  @override
  String get thisMonth => '이번 달';

  @override
  String get thisYear => '올해';

  @override
  String get noTaxPayments => '아직 세금 납부가 없습니다';
}
