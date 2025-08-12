// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Our Spends';

  @override
  String get chatTitle => 'Chat Chi Tiêu';

  @override
  String get chatHint => 'Hãy nói cho tôi về khoản chi tiêu của bạn...';

  @override
  String get chatEmptyTitle => 'Bắt đầu theo dõi chi tiêu của bạn';

  @override
  String get chatEmptySubtitle =>
      'Hãy nói cho tôi về các giao dịch mua hàng và tôi sẽ giúp bạn theo dõi chúng';

  @override
  String get send => 'Gửi';

  @override
  String get settings => 'Cài đặt';

  @override
  String get expenses => 'Chi tiêu';

  @override
  String get error => 'Lỗi';

  @override
  String get noExpenses => 'Không có chi tiêu';

  @override
  String get addExpense => 'Thêm chi tiêu';

  @override
  String get category => 'Danh mục';

  @override
  String get date => 'Ngày';

  @override
  String get location => 'Vị trí';

  @override
  String get paymentMethod => 'Phương thức thanh toán';

  @override
  String get notes => 'Ghi chú';

  @override
  String get chat => 'Trò chuyện';

  @override
  String get save => 'Lưu';

  @override
  String get expenseTitleLabel => 'Tiêu đề';

  @override
  String get expenseTitlePlaceholder => 'ví dụ: Ăn trưa với đồng nghiệp';

  @override
  String get fieldRequired => 'Trường này là bắt buộc';

  @override
  String get expenseAmountLabel => 'Số tiền';

  @override
  String get expenseAmountPlaceholder => 'ví dụ: 15.50';

  @override
  String get invalidNumber => 'Vui lòng nhập một số hợp lệ';

  @override
  String get currency => 'Tiền tệ';

  @override
  String get expenseDateLabel => 'Ngày';

  @override
  String get expenseCategoryLabel => 'Danh mục';

  @override
  String get locationPlaceholder => 'ví dụ: Cafe Central';

  @override
  String get expenseNotesLabel => 'Ghi chú';

  @override
  String get expenseNotesPlaceholder =>
      'ví dụ: Đã thảo luận về các mốc quan trọng của dự án';

  @override
  String get expenseCategoryFood => 'Đồ ăn';

  @override
  String get expenseCategoryTransport => 'Đi lại';

  @override
  String get expenseCategoryShopping => 'Mua sắm';

  @override
  String get expenseCategoryEntertainment => 'Giải trí';

  @override
  String get expenseCategoryUtilities => 'Tiện ích';

  @override
  String get expenseCategoryHealth => 'Sức khỏe';

  @override
  String get expenseCategoryTravel => 'Du lịch';

  @override
  String get expenseCategoryEducation => 'Giáo dục';

  @override
  String get expenseCategoryOther => 'Khác';

  @override
  String get expenseAddedSuccess => 'Thêm chi phí thành công';

  @override
  String get expenseAddedError => 'Lỗi khi thêm chi phí';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get theme => 'Giao diện';

  @override
  String get selectTheme => 'Chọn giao diện';

  @override
  String get systemTheme => 'Mặc định hệ thống';

  @override
  String get lightTheme => 'Sáng';

  @override
  String get darkTheme => 'Tối';

  @override
  String get reports => 'Báo cáo';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get support => 'Hỗ trợ';

  @override
  String get helpAndFaq => 'Trợ giúp & FAQ';

  @override
  String get helpAndFaqSubtitle => 'Nhận trợ giúp và tìm câu trả lời';

  @override
  String get sendFeedback => 'Gửi phản hồi';

  @override
  String get sendFeedbackSubtitle => 'Chia sẻ suy nghĩ của bạn với chúng tôi';

  @override
  String get userProfile => 'Hồ sơ người dùng';

  @override
  String get manageAccount => 'Quản lý cài đặt tài khoản của bạn';

  @override
  String get preferences => 'Tùy chọn';

  @override
  String get aiSettings => 'Cài đặt AI';

  @override
  String get aiSettingsSubtitle => 'Định cấu hình nhà cung cấp AI và khóa API';

  @override
  String get dataAndAnalytics => 'Dữ liệu & Phân tích';

  @override
  String get reportsSubtitle => 'Xem báo cáo chi phí và thông tin chi tiết';

  @override
  String get dataSync => 'Đồng bộ hóa dữ liệu';

  @override
  String get dataSyncSubtitle => 'Sao lưu và đồng bộ hoá dữ liệu của bạn';

  @override
  String get aiChat => 'Trò chuyện AI';

  @override
  String get initializingAiChat => 'Đang khởi tạo trò chuyện AI...';

  @override
  String failedToInitializeAiProvider(Object error) {
    return 'Không thể khởi tạo nhà cung cấp AI: $error';
  }

  @override
  String anErrorOccurred(Object error) {
    return 'Đã xảy ra lỗi: $error';
  }

  @override
  String get aiAssistant => 'Trợ lý AI';

  @override
  String get alwaysActive => 'Luôn hoạt động';

  @override
  String get typeAMessage => 'Nhập tin nhắn...';

  @override
  String get generateExpenseReport => 'Tạo báo cáo chi tiêu';

  @override
  String get addNewExpense => 'Thêm khoản chi tiêu mới';

  @override
  String get generateInsights => 'Tạo phân tích';

  @override
  String get clearConversation => 'Xóa cuộc trò chuyện';

  @override
  String get expenseSavedToYourTracker => '💡 Đã lưu khoản chi tiêu của bạn!';

  @override
  String get generatingSpendingInsights => 'Đang tạo phân tích chi tiêu...';

  @override
  String get spendingInsights => 'Phân tích chi tiêu';

  @override
  String get couldNotGenerateInsights => 'Không thể tạo phân tích vào lúc này.';

  @override
  String errorLoadingSettings(Object error) {
    return 'Lỗi tải cài đặt: $error';
  }

  @override
  String get settingsSavedSuccessfully => 'Đã lưu cài đặt thành công!';

  @override
  String errorSavingSettings(Object error) {
    return 'Lỗi lưu cài đặt: $error';
  }

  @override
  String get aiProvider => 'Nhà cung cấp AI';

  @override
  String get aiProviderDescription =>
      'Ứng dụng này sử dụng Google Gemini để phân tích chi tiêu và thông tin chi tiết.';

  @override
  String get geminiGoogle => 'Gemini (Google)';

  @override
  String get apiKey => 'Khóa API';

  @override
  String get enterYourApiKey => 'Nhập khóa API của bạn';

  @override
  String get getYourApiKey => 'Lấy khóa API của bạn từ Google AI Studio';

  @override
  String get apiTermsOfService =>
      'Bằng cách sử dụng tính năng này, bạn đồng ý với các điều khoản dịch vụ của API.';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get dataUsage => 'Sử dụng dữ liệu';

  @override
  String get dataUsageDescription =>
      'Dữ liệu chi tiêu của bạn sẽ được gửi đến nhà cung cấp AI để phân tích. Chúng tôi không lưu trữ dữ liệu của bạn.';

  @override
  String get learnMore => 'Tìm hiểu thêm';

  @override
  String get systemPrompt =>
      'Bạn là một trợ lý AI hữu ích cho một ứng dụng theo dõi chi tiêu gia đình. Giúp người dùng theo dõi chi tiêu, trả lời các câu hỏi về chi tiêu của họ và cung cấp thông tin chi tiết về tài chính.';

  @override
  String get systemPromptWithContext =>
      'Bạn là một trợ lý AI hữu ích cho một ứng dụng theo dõi chi tiêu gia đình. Giúp người dùng theo dõi chi tiêu, trả lời các câu hỏi về chi tiêu của họ và cung cấp thông tin chi tiết về tài chính.\n\nĐây là thông tin về các khoản chi tiêu gần đây của người dùng:';

  @override
  String expenseInfo(
    Object amount,
    Object category,
    Object currency,
    Object date,
    Object index,
    Object item,
  ) {
    return '\n$index. Khoản chi: $item, Số tiền: $amount $currency, Danh mục: $category, Ngày: $date';
  }

  @override
  String get extractionInstruction =>
      '\n\nKhi người dùng đề cập đến một khoản chi tiêu mới, hãy trích xuất thông tin chi tiêu và cho họ biết bạn có thể lưu nó vào trình theo dõi chi tiêu của họ.';
}
