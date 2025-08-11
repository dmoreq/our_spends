import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../l10n/app_localizations.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 0; // 0: Week, 1: Month, 2: Year
  final List<String> _periods = ['Week', 'Month', 'Year'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenses = expenseProvider.expenses;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analytics),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.overview),
            Tab(text: l10n.categories),
          ],
        ),
      ),
      body: Column(
        children: [
          // Period selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<int>(
              segments: _periods.map((period) {
                return ButtonSegment<int>(
                  value: _periods.indexOf(period),
                  label: Text(_getPeriodTranslation(period, l10n)),
                );
              }).toList(),
              selected: {_selectedPeriod},
              onSelectionChanged: (Set<int> selection) {
                setState(() {
                  _selectedPeriod = selection.first;
                });
              },
            ),
          ),
          
          // Main content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Overview tab
                _buildOverviewTab(context, expenses),
                
                // Categories tab
                _buildCategoriesTab(context, expenses),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getPeriodTranslation(String period, AppLocalizations l10n) {
    switch (period) {
      case 'Week':
        return l10n.week;
      case 'Month':
        return l10n.month;
      case 'Year':
        return l10n.year;
      default:
        return period;
    }
  }
  
  Widget _buildOverviewTab(BuildContext context, List<Expense> expenses) {
    final l10n = AppLocalizations.of(context)!;
    final filteredExpenses = _getFilteredExpenses(expenses);
    
    if (filteredExpenses.isEmpty) {
      return Center(child: Text(l10n.noExpensesForPeriod));
    }
    
    // Calculate total spending
    final totalSpending = filteredExpenses.fold<double>(
      0, 
      (sum, expense) => sum + _convertToDefaultCurrency(expense.amount, expense.currency)
    );
    
    // Get daily spending data for the chart
    final dailyData = _getDailySpendingData(filteredExpenses);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total spending card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.totalSpending,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatCurrency(totalSpending, 'VND'),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Spending trend chart
          Text(
            l10n.spendingTrend,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= dailyData.length || value.toInt() < 0) {
                          return const SizedBox.shrink();
                        }
                        // Only show some labels to avoid overcrowding
                        if (dailyData.length > 7 && value.toInt() % 3 != 0) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            dailyData[value.toInt()].day.toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(dailyData.length, (index) {
                      return FlSpot(index.toDouble(), dailyData[index].amount);
                    }),
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Recent transactions
          Text(
            l10n.recentTransactions,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...filteredExpenses.take(5).map((expense) => _buildExpenseListItem(context, expense)),
        ],
      ),
    );
  }
  
  Widget _buildCategoriesTab(BuildContext context, List<Expense> expenses) {
    final l10n = AppLocalizations.of(context)!;
    final filteredExpenses = _getFilteredExpenses(expenses);
    
    if (filteredExpenses.isEmpty) {
      return Center(child: Text(l10n.noExpensesForPeriod));
    }
    
    // Calculate spending by category
    final Map<String, double> categorySpending = {};
    for (final expense in filteredExpenses) {
      final amount = _convertToDefaultCurrency(expense.amount, expense.currency);
      categorySpending.update(
        expense.category,
        (value) => value + amount,
        ifAbsent: () => amount,
      );
    }
    
    // Sort categories by spending amount (descending)
    final sortedCategories = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Calculate total for percentage
    final totalSpending = categorySpending.values.fold<double>(0, (sum, amount) => sum + amount);
    
    // Prepare data for pie chart
    final pieChartSections = <PieChartSectionData>[];
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
    ];
    
    for (int i = 0; i < sortedCategories.length; i++) {
      final category = sortedCategories[i];
      final percentage = (category.value / totalSpending) * 100;
      
      pieChartSections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: category.value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pie chart
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: pieChartSections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Category breakdown
          Text(
            l10n.categoryBreakdown,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ...List.generate(sortedCategories.length, (index) {
            final category = sortedCategories[index];
            final percentage = (category.value / totalSpending) * 100;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_getCategoryTranslation(category.key, l10n)),
                  ),
                  Text(
                    _formatCurrency(category.value, 'VND'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  String _getCategoryTranslation(String category, AppLocalizations l10n) {
    switch (category) {
      case 'Food & Drinks':
        return l10n.expenseCategoryFood;
      case 'Transportation':
        return l10n.expenseCategoryTransport;
      case 'Shopping':
        return l10n.expenseCategoryShopping;
      case 'Entertainment':
        return l10n.expenseCategoryEntertainment;
      case 'Utilities':
        return l10n.expenseCategoryUtilities;
      case 'Health':
        return l10n.expenseCategoryHealth;
      case 'Travel':
        return l10n.expenseCategoryTravel;
      case 'Education':
        return l10n.expenseCategoryEducation;
      case 'Other':
        return l10n.expenseCategoryOther;
      default:
        return category;
    }
  }
  
  List<Expense> _getFilteredExpenses(List<Expense> expenses) {
    final now = DateTime.now();
    DateTime startDate;
    
    // Filter based on selected period
    switch (_selectedPeriod) {
      case 0: // Week
        startDate = DateTime(now.year, now.month, now.day - 7);
        break;
      case 1: // Month
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 2: // Year
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = DateTime(now.year, now.month, now.day - 7);
    }
    
    return expenses.where((expense) => expense.date.isAfter(startDate)).toList();
  }
  
  List<DailySpending> _getDailySpendingData(List<Expense> expenses) {
    final Map<int, double> dailySpending = {};
    final now = DateTime.now();
    int daysToShow;
    
    // Determine number of days to show based on selected period
    switch (_selectedPeriod) {
      case 0: // Week
        daysToShow = 7;
        break;
      case 1: // Month
        daysToShow = 30;
        break;
      case 2: // Year
        daysToShow = 12; // Show months instead of days for year view
        break;
      default:
        daysToShow = 7;
    }
    
    // Initialize all days with zero spending
    for (int i = 0; i < daysToShow; i++) {
      dailySpending[i] = 0;
    }
    
    // Aggregate spending by day/month
    for (final expense in expenses) {
      final amount = _convertToDefaultCurrency(expense.amount, expense.currency);
      int index;
      
      if (_selectedPeriod == 2) { // Year view - group by month
        index = (now.month - expense.date.month) % 12;
        if (index < 0) index += 12;
        if (index >= daysToShow) continue;
      } else { // Week/Month view - group by day
        final difference = now.difference(expense.date).inDays;
        if (difference >= daysToShow) continue;
        index = difference;
      }
      
      dailySpending.update(index, (value) => value + amount);
    }
    
    // Convert to list of DailySpending objects
    final result = <DailySpending>[];
    for (int i = daysToShow - 1; i >= 0; i--) {
      final day = _selectedPeriod == 2 
          ? (now.month - i) % 12 + 1 // Month number for year view
          : now.day - i; // Day number for week/month view
      
      result.add(DailySpending(day, dailySpending[i] ?? 0));
    }
    
    return result;
  }
  
  double _convertToDefaultCurrency(double amount, String currency) {
    // In a real app, this would use exchange rates
    // For simplicity, we'll use fixed conversion rates
    switch (currency) {
      case 'USD':
        return amount * 23000; // 1 USD = 23,000 VND
      case 'EUR':
        return amount * 25000; // 1 EUR = 25,000 VND
      case 'GBP':
        return amount * 29000; // 1 GBP = 29,000 VND
      case 'JPY':
        return amount * 150; // 1 JPY = 150 VND
      default:
        return amount; // VND or other currencies
    }
  }
  
  String _formatCurrency(double amount, String currency) {
    final locale = Localizations.localeOf(context).languageCode;
    
    if (locale == 'vi') {
      return '${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )} $currency';
    }
    
    return '${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )} $currency';
  }
  
  Widget _buildExpenseListItem(BuildContext context, Expense expense) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(expense.item),
        subtitle: Text(_getCategoryTranslation(expense.category, l10n)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${expense.amount.toStringAsFixed(0)} ${expense.currency}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              _formatDate(expense.date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'vi') {
      return '${date.day}/${date.month}/${date.year}';
    }
    return '${date.month}/${date.day}/${date.year}';
  }
}

class DailySpending {
  final int day;
  final double amount;
  
  DailySpending(this.day, this.amount);
}