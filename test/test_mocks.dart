import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:our_spends/providers/expense_provider.dart';

// Generate mock for ExpenseProvider
@GenerateMocks([ExpenseProvider])
part 'test_mocks.mocks.dart';

void main() {
  test('Simple test', () {
    expect(true, isTrue);
  });
}