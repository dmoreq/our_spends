import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

import '../providers/expense_provider.dart';
import '../providers/language_provider.dart';
import '../models/expense.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_option_button.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_input_field.dart';
import '../theme/chat_theme.dart';
import '../utils/logger.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final AIService _aiService = AIService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final List<Map<String, String>> _conversationHistory = [];
  
  bool _isInitialized = false;
  String? _errorMessage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeProvider();
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeProvider() async {
    try {
      // Initialize the AI service
      await _aiService.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.failedToInitializeAiProvider(e.toString());
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isProcessing) return;

    // Capture context values before async operations
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final languageCode = languageProvider.currentLocale.languageCode;
    
    // Add user message to chat
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isProcessing = true;
    });

    // Add to conversation history
    _conversationHistory.add({
      'role': 'user',
      'content': message,
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Process message using AI service
      final aiResponse = await _aiService.processMessage(
        message, 
        expenseProvider.expenses,
        conversationHistory: _conversationHistory,
        languageCode: languageCode,
      );

      // Add AI response to chat
      setState(() {
        _messages.add(ChatMessage(
          text: aiResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isProcessing = false;
      });

      // Add to conversation history
      _conversationHistory.add({
        'role': 'assistant',
        'content': aiResponse,
      });

      _scrollToBottom();

      // Process message for expense extraction
      await _processMessageForExpenses(message, aiResponse, expenseProvider, languageCode);
    } catch (e) {
      // Handle error
      setState(() {
        _messages.add(ChatMessage(
          text: l10n.anErrorOccurred(e.toString()),
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
        _isProcessing = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final languageCode = languageProvider.currentLocale.languageCode;
    final l10n = AppLocalizations.of(context)!;
    
    // Show loading indicator while initializing
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ChatTheme.primaryColor),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.initializingAiChat,
                style: const TextStyle(color: ChatTheme.textPrimary),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // Initialize system prompt for AI context
    if (_messages.isEmpty) {
      // Create a custom system prompt that includes user's expense context
      // Add suggested options only (no welcome message)
      _addSuggestedOptions();
    }

    return Scaffold(
      backgroundColor: ChatTheme.backgroundColor,
      appBar: ChatAppBar(
        onBackPressed: () => Navigator.of(context).pop(),
        onMenuPressed: () => _showMenuOptions(context, expenseProvider, l10n),
        botName: l10n.aiAssistant,
        statusText: l10n.alwaysActive,
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatMessageBubble(message: message);
              },
            ),
          ),
          
          // Input area
          ChatInputField(
            controller: _messageController,
            onSend: _sendMessage,
            isProcessing: _isProcessing,
            hintText: l10n.typeAMessage,
          ),
        ],
      ),
    );
  }
  
  void _addSuggestedOptions() {
    final l10n = AppLocalizations.of(context)!;
    
    // Add suggested options as special messages
    _messages.add(ChatMessage(
      text: l10n.generateExpenseReport,
      isUser: false,
      timestamp: DateTime.now(),
      isOption: true,
    ));
    
    _messages.add(ChatMessage(
      text: l10n.addNewExpense,
      isUser: false,
      timestamp: DateTime.now(),
      isOption: true,
    ));
  }
  
  void _showMenuOptions(BuildContext context, ExpenseProvider expenseProvider, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.insights, color: ChatTheme.primaryColor),
              title: Text(l10n.generateInsights),
              onTap: () {
                Navigator.pop(context);
                _generateInsights(context, expenseProvider, l10n);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: ChatTheme.primaryColor),
              title: Text(l10n.clearConversation),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _messages.clear();
                  _conversationHistory.clear();
                  // Add suggested options only (no welcome message)
                  _addSuggestedOptions();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build a system prompt that includes context about the user's expenses
  String _buildSystemPrompt(List<dynamic> expenses, AppLocalizations l10n) {
    // Base system prompt
    String prompt = l10n.systemPrompt;
  
    // Add expense context if available
    if (expenses.isNotEmpty) {
      prompt += l10n.systemPromptWithContext;
  
      // Add up to 10 most recent expenses
      final recentExpenses = expenses.take(10).toList();
      for (var i = 0; i < recentExpenses.length; i++) {
        final expense = recentExpenses[i];
        prompt += l10n.expenseInfo(
          (i + 1).toString(),
          expense.item,
          expense.amount.toString(),
          expense.currency,
          expense.category,
          expense.date.toString().split(' ')[0],
        );
      }
    }
  
    // Add instructions for expense extraction
    prompt += l10n.extractionInstruction;
  
    return prompt;
  }

  // Process messages to extract expense information
  Future<void> _processMessageForExpenses(String message, String response, ExpenseProvider expenseProvider, String languageCode) async {
    try {
      // Use fixed demo user ID
      String userId = 'demo-user';
      final l10n = AppLocalizations.of(context)!;
      
      // Use the existing API service to extract expense information
      final apiResponse = await expenseProvider.sendMessage(message, userId, languageCode: languageCode);
      
      // Check if expense information was extracted
      if (apiResponse['expense_info'] != null && apiResponse['expense_info']['hasExpense'] == true) {
        // Extract expense information
        final expenseInfo = apiResponse['expense_info'];
        
        // Save expense to database using the existing method
        await _saveExpenseToDatabase(expenseInfo, userId, expenseProvider);
        
        // Show a snackbar to notify the user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.expenseSavedToYourTracker),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      logger.error('Error processing message for expenses', e);
    }
  }

  // Save expense to database
  Future<void> _saveExpenseToDatabase(Map<String, dynamic> expenseInfo, String userId, ExpenseProvider expenseProvider) async {
    try {
      // Create a new expense object
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        date: DateTime.now(),
        amount: expenseInfo['amount'] ?? 0.0,
        currency: expenseInfo['currency'] ?? 'USD',

        subcategory: expenseInfo['subcategory'],
        item: expenseInfo['description'] ?? expenseInfo['item'] ?? 'Expense',
        description: expenseInfo['description'],
        location: expenseInfo['location'],
        paymentMethod: expenseInfo['payment_method'],
        receiptUrl: expenseInfo['receipt_url'],
        isRecurring: expenseInfo['is_recurring'] ?? false,
        recurringFrequency: expenseInfo['recurring_frequency'],
        notes: expenseInfo['notes'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: 0,
      );
      
      // Add the expense to the database
      await expenseProvider.addExpense(expense);
    } catch (e) {
      logger.error('Error saving expense to database', e);
      rethrow;
    }
  }

  // Generate insights using the existing provider
  Future<void> _generateInsights(BuildContext context, ExpenseProvider expenseProvider, AppLocalizations l10n) async {
    try {
      // Use fixed demo user ID
      String userId = 'demo-user';
      
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.generatingSpendingInsights),
            ],
          ),
        ),
      );
      
      // Generate insights
      final response = await expenseProvider.generateInsights(userId);
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show insights dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.spendingInsights),
            content: SingleChildScrollView(
              child: Text(response['data'] ?? l10n.couldNotGenerateInsights),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(Provider.of<LanguageProvider>(context).currentLocale.languageCode == 'vi' ? 'Đóng' : 'Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(Provider.of<LanguageProvider>(context).currentLocale.languageCode == 'vi' ? 'Lỗi' : 'Error'),
            content: Text(
              Provider.of<LanguageProvider>(context).currentLocale.languageCode == 'vi'
                  ? 'Không thể tạo phân tích: ${e.toString()}'
                  : 'Failed to generate insights: ${e.toString()}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(Provider.of<LanguageProvider>(context).currentLocale.languageCode == 'vi' ? 'Đóng' : 'Close'),
              ),
            ],
          ),
        );
      }
    }
  }
}