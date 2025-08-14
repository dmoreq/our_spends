class Currency {
  final String code;
  final String symbol;
  final String name;
  final int decimalPlaces;
  final bool symbolOnLeft;
  final bool spaceBetweenAmountAndSymbol;
  final double? exchangeRate; // Rate relative to base currency (VND)

  Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.decimalPlaces,
    required this.symbolOnLeft,
    required this.spaceBetweenAmountAndSymbol,
    this.exchangeRate,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      decimalPlaces: json['decimal_places'] ?? 0,
      symbolOnLeft: json['symbol_on_left'] ?? true,
      spaceBetweenAmountAndSymbol: json['space_between_amount_and_symbol'] ?? false,
      exchangeRate: json['exchange_rate']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'symbol': symbol,
      'name': name,
      'decimal_places': decimalPlaces,
      'symbol_on_left': symbolOnLeft,
      'space_between_amount_and_symbol': spaceBetweenAmountAndSymbol,
      'exchange_rate': exchangeRate,
    };
  }

  String formatAmount(double amount) {
    final formattedAmount = amount.toStringAsFixed(decimalPlaces);
    final parts = symbolOnLeft ? [symbol, formattedAmount] : [formattedAmount, symbol];
    return parts.join(spaceBetweenAmountAndSymbol ? ' ' : '');
  }

  double convertTo(double amount, Currency targetCurrency) {
    if (exchangeRate == null || targetCurrency.exchangeRate == null) {
      throw Exception('Exchange rates not available');
    }
    
    // Convert to VND first (base currency), then to target currency
    final amountInVND = amount * (exchangeRate ?? 1.0);
    return amountInVND / (targetCurrency.exchangeRate ?? 1.0);
  }

  static Currency get vnd => Currency(
    code: 'VND',
    symbol: '₫',
    name: 'Vietnamese Dong',
    decimalPlaces: 0,
    symbolOnLeft: false,
    spaceBetweenAmountAndSymbol: true,
    exchangeRate: 1.0, // Base currency
  );

  static Currency get usd => Currency(
    code: 'USD',
    symbol: '\$',
    name: 'US Dollar',
    decimalPlaces: 2,
    symbolOnLeft: true,
    spaceBetweenAmountAndSymbol: false,
    exchangeRate: null, // Should be updated with current rate
  );
}