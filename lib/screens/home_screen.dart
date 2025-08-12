import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'expenses_screen.dart';
import 'add_expense_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isDrawerVisible = false;
  Timer? _hideTimer;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    // Ensure drawer is hidden at start
    _isDrawerVisible = false;
  }
  
  Widget _buildNavItem(int index, IconData icon, IconData selectedIcon, String label) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
          if (_isDrawerVisible) {
            _keepDrawerOpen();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }
  
  // This method is now only used to keep the drawer open when interacting with it
  void _keepDrawerOpen() {
    // Cancel any existing timer
    _hideTimer?.cancel();
    
    // No timer is set - drawer will only close when user clicks outside
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Scaffold(
      body: MouseRegion(
        onHover: (_) => _isDrawerVisible ? _keepDrawerOpen() : null,
        child: GestureDetector(
          onTap: () => _isDrawerVisible ? _keepDrawerOpen() : null,
          child: Stack(
            children: [
              // Main content
              Positioned.fill(
                child: Stack(
                  children: [
                    // Content
                    PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        ExpensesScreen(),
                        ChatScreen(),
                        SettingsScreen(),
                      ],
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                        if (_isDrawerVisible) {
                          _keepDrawerOpen();
                        }
                      },
                    ),
                    // Semi-transparent overlay when drawer is open
                    if (_isDrawerVisible)
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isDrawerVisible = false;
                                });
                                _animationController.reverse();
                              },
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.3 * _animation.value),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              
              // Top-left menu icon to toggle drawer
              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  icon: Icon(
                    _isDrawerVisible ? Icons.menu_open : Icons.menu,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      _isDrawerVisible = !_isDrawerVisible;
                    });
                    if (_isDrawerVisible) {
                      _animationController.forward();
                      _keepDrawerOpen();
                    } else {
                      _animationController.reverse();
                    }
                  },
                ),
              ),
              
              // Drawer - overlay on left side
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5 * _animation.value,
                      child: Opacity(
                        opacity: _animation.value,
                        child: child,
                      ),
                    );
                  },
                child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(2, 0),
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  child: Column(
                      children: [
                        const SizedBox(height: 80),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            l10n.appTitle,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildNavItem(0, Icons.home_outlined, Icons.home, l10n.expenses),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildNavItem(1, Icons.chat_bubble_outline, Icons.chat_bubble, l10n.chat),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildNavItem(2, Icons.person_outline, Icons.person, l10n.settings),
                        ),
                        const Spacer(),
                        if (_currentIndex == 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30, left: 16, right: 16),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: Text(l10n.addExpense),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}