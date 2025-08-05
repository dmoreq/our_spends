// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Quản Lý Chi Tiêu Gia Đình';

  @override
  String get loginTitle => 'Chào Mừng';

  @override
  String get loginSubtitle => 'Theo dõi chi tiêu gia đình với AI';

  @override
  String get signInWithGoogle => 'Đăng nhập với Google';

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
  String get settings => 'Cài Đặt';

  @override
  String get logout => 'Đăng Xuất';

  @override
  String get currency => 'Tiền Tệ';

  @override
  String get language => 'Ngôn Ngữ';

  @override
  String get selectLanguage => 'Chọn Ngôn Ngữ';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get reports => 'Báo Cáo';

  @override
  String get weekly => 'Hàng Tuần';

  @override
  String get monthly => 'Hàng Tháng';

  @override
  String get yearly => 'Hàng Năm';

  @override
  String get total => 'Tổng Cộng';

  @override
  String get category => 'Danh Mục';

  @override
  String get amount => 'Số Tiền';

  @override
  String get noExpenses => 'Không tìm thấy chi tiêu nào';

  @override
  String get loading => 'Đang tải...';

  @override
  String get error => 'Lỗi';

  @override
  String get retry => 'Thử Lại';

  @override
  String get cancel => 'Hủy';

  @override
  String get ok => 'OK';

  @override
  String get expenseLogged => 'Đã ghi nhận chi tiêu thành công';

  @override
  String get networkError => 'Lỗi mạng. Vui lòng kiểm tra kết nối.';

  @override
  String get authError => 'Xác thực thất bại. Vui lòng thử lại.';

  @override
  String get unknownError => 'Đã xảy ra lỗi không xác định.';
}
