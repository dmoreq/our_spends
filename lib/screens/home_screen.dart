import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../l10n/app_localizations.dart';
import 'expenses_screen.dart';
import 'add_expense_screen.dart';
import 'analytics_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ExpensesScreen(),
          AddExpenseScreen(),
          AnalyticsScreen(),
          ChatScreen(),
          SettingsScreen(),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.list_alt_outlined),
            selectedIcon: const Icon(Icons.list_alt),
            label: l10n.expenses,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            selectedIcon: const Icon(Icons.add_circle),
            label: l10n.addExpense,
          ),
          NavigationDestination(
            icon: const Icon(Icons.analytics_outlined),
            selectedIcon: const Icon(Icons.analytics),
            label: l10n.analytics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_outlined),
            selectedIcon: const Icon(Icons.chat),
            label: l10n.chat,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 1; // Switch to Add Expense tab
                  _pageController.jumpToPage(1);
                });
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}