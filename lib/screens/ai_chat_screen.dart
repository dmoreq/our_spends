import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../providers/language_provider.dart';
import '../models/expense.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_option_button.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/facility_card.dart';
import '../theme/chat_theme.dart';

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
      
      setState(() {
        _isInitialized = true;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize AI provider: ${e.toString()}';
      });
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

    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
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
      // Use fixed demo user ID
      String userId = 'demo-user';

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
          text: languageCode == 'vi' 
              ? 'Đã xảy ra lỗi: ${e.toString()}'
              : 'An error occurred: ${e.toString()}',
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
                languageCode == 'vi' 
                    ? 'Đang khởi tạo trò chuyện AI...'
                    : 'Initializing AI chat...',
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
      final systemPrompt = _buildSystemPrompt(expenseProvider.expenses, languageCode);
      
      // Add suggested options only (no welcome message)
      _addSuggestedOptions();
    }

    return Scaffold(
      backgroundColor: ChatTheme.backgroundColor,
      appBar: ChatAppBar(
        onBackPressed: () => Navigator.of(context).pop(),
        onMenuPressed: () => _showMenuOptions(context, expenseProvider, languageCode),
        botName: languageCode == 'vi' ? 'Trợ lý AI' : 'AI Assistant',
        statusText: languageCode == 'vi' ? 'Luôn hoạt động' : 'Always active',
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
            hintText: languageCode == 'vi' ? 'Nhập tin nhắn...' : 'Type a message...',
          ),
        ],
      ),
    );
  }
  
  void _addSuggestedOptions() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final languageCode = languageProvider.currentLocale.languageCode;
    
    // Add suggested options as special messages
    _messages.add(ChatMessage(
      text: languageCode == 'vi' ? 'Tạo báo cáo chi tiêu' : 'Generate expense report',
      isUser: false,
      timestamp: DateTime.now(),
      isOption: true,
    ));
    
    _messages.add(ChatMessage(
      text: languageCode == 'vi' ? 'Thêm khoản chi tiêu mới' : 'Add a new expense',
      isUser: false,
      timestamp: DateTime.now(),
      isOption: true,
    ));
  }
  
  void _showMenuOptions(BuildContext context, ExpenseProvider expenseProvider, String languageCode) {
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
              title: Text(languageCode == 'vi' ? 'Tạo phân tích' : 'Generate Insights'),
              onTap: () {
                Navigator.pop(context);
                _generateInsights(context, expenseProvider, languageCode);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: ChatTheme.primaryColor),
              title: Text(languageCode == 'vi' ? 'Xóa cuộc trò chuyện' : 'Clear conversation'),
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
  
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final languageCode = languageProvider.currentLocale.languageCode;
    
    // If this is an option message, render it as a button
    if (message.isOption) {
      return ChatOptionButton(
        text: message.text,
        onTap: () {
          _messageController.text = message.text;
          _sendMessage();
        },
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[  
            // AI avatar
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.smart_toy, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          
          // Message bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isUser 
                    ? Theme.of(context).colorScheme.primary 
                    : (message.isError ? Colors.red[100] : Theme.of(context).colorScheme.surfaceVariant),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser 
                      ? Theme.of(context).colorScheme.onPrimary 
                      : (message.isError ? Colors.red[900] : Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
          
          if (isUser) ...[  
            // User avatar
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  // Build a system prompt that includes context about the user's expenses
  String _buildSystemPrompt(List<dynamic> expenses, String languageCode) {
    final isVietnamese = languageCode == 'vi';
  
    // Base system prompt
    String prompt = isVietnamese
        ? 'Bạn là trợ lý AI cho ứng dụng theo dõi chi tiêu gia đình. Giúp người dùng theo dõi chi tiêu, trả lời câu hỏi về chi tiêu của họ và cung cấp thông tin tài chính.'
        : 'You are a helpful AI assistant for a family expense tracking app. Help users track expenses, answer questions about their spending, and provide financial insights.';
  
    // Add expense context if available
    if (expenses.isNotEmpty) {
      final contextIntro = isVietnamese
          ? '\n\nĐây là thông tin về các khoản chi tiêu gần đây của người dùng:'
          : '\n\nHere is information about the user\'s recent expenses:';
  
      prompt += contextIntro;
  
      // Add up to 10 most recent expenses
      final recentExpenses = expenses.take(10).toList();
      for (var i = 0; i < recentExpenses.length; i++) {
        final expense = recentExpenses[i];
        final expenseInfo = isVietnamese
            ? '\n${i + 1}. Khoản chi: ${expense.item}, Số tiền: ${expense.amount} ${expense.currency}, Danh mục: ${expense.category}, Ngày: ${expense.date.toString().split(' ')[0]}'
            : '\n${i + 1}. Item: ${expense.item}, Amount: ${expense.amount} ${expense.currency}, Category: ${expense.category}, Date: ${expense.date.toString().split(' ')[0]}';
  
        prompt += expenseInfo;
      }
    }
  
    // Add instructions for expense extraction
    final extractionInstructions = isVietnamese
        ? '\n\nKhi người dùng đề cập đến một khoản chi tiêu mới, hãy trích xuất thông tin chi tiêu và thông báo cho họ rằng bạn có thể lưu nó vào ứng dụng theo dõi chi tiêu.'
        : '\n\nWhen the user mentions a new expense, extract the expense information and let them know you can save it to their expense tracker.';
  
    prompt += extractionInstructions;
  
    return prompt;
  }

  // Process messages to extract expense information
  Future<void> _processMessageForExpenses(String message, String response, ExpenseProvider expenseProvider, String languageCode) async {
    try {
      // Use fixed demo user ID
      String userId = 'demo-user';
      
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
              content: Text(
                languageCode == 'vi'
                    ? '💡 Đã lưu khoản chi tiêu của bạn!'
                    : '💡 Expense saved to your tracker!',
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('Error processing message for expenses: $e');
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
        category: expenseInfo['category'] ?? 'Miscellaneous',
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
      print('Error saving expense to database: $e');
      rethrow;
    }
  }

  // Generate insights using the existing provider
  Future<void> _generateInsights(BuildContext context, ExpenseProvider expenseProvider, String languageCode) async {
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
              Text(
                languageCode == 'vi'
                    ? 'Đang tạo phân tích chi tiêu...'
                    : 'Generating spending insights...',
              ),
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
            title: Text(
              languageCode == 'vi' ? 'Phân tích chi tiêu' : 'Spending Insights',
            ),
            content: SingleChildScrollView(
              child: Text(response['data'] ?? (languageCode == 'vi'
                  ? 'Không thể tạo phân tích vào lúc này.'
                  : 'Unable to generate insights at the moment.')),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(languageCode == 'vi' ? 'Đóng' : 'Close'),
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
            title: Text(languageCode == 'vi' ? 'Lỗi' : 'Error'),
            content: Text(
              languageCode == 'vi'
                  ? 'Không thể tạo phân tích: ${e.toString()}'
                  : 'Failed to generate insights: ${e.toString()}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(languageCode == 'vi' ? 'Đóng' : 'Close'),
              ),
            ],
          ),
        );
      }
    }
  }
}