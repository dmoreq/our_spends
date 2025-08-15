import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense/expense_provider.dart';
import '../providers/language_provider.dart';
import '../models/chat_message.dart';
import '../models/expense.dart';
import '../l10n/app_localizations.dart';
import '../utils/logger.dart';
import '../services/ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final List<Map<String, String>> _conversationHistory = [];
  final AIService _aiService = AIService();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initializeAIService();
  }

  Future<void> _initializeAIService() async {
    try {
      await _aiService.initialize();
    } catch (e) {
      logger.error('Failed to initialize AI service', e);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    final demoUserId = 'demo-user';

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _conversationHistory.add({
      'role': 'user',
      'content': message,
    });

    _messageController.clear();

    await _processChatMessage(message, demoUserId, expenseProvider);
  }

  Future<void> _processChatMessage(String message, String userId, ExpenseProvider expenseProvider) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final languageCode = languageProvider.currentLocale.languageCode;

    try {
      // Process message using AI service
      final aiResponse = await _aiService.processMessage(
        message, 
        expenseProvider.expenses,
        conversationHistory: _conversationHistory,
        languageCode: languageCode,
      );
      
      _addMessage(aiResponse, isUser: false);
      
      // Try to extract expense information
      final expenseInfo = await _aiService.extractExpenseInfo(message);
      
      if (expenseInfo != null && expenseInfo['hasExpense'] == true) {
        await _saveExpenseToDatabase(expenseInfo, userId);
        final expenseMessage = languageCode == 'vi'
            ? "💡 Tôi đã tự động lưu khoản chi tiêu của bạn vào trình theo dõi chi tiêu!"
            : "💡 I've automatically saved your expense to your expense tracker!";
        _addMessage(expenseMessage, isUser: false);
      }
    } catch (e) {
      final errorMessage = languageCode == 'vi'
          ? "Xin lỗi, tôi gặp lỗi. Vui lòng thử lại."
          : "Sorry, I encountered an error. Please try again.";
      _addMessage(errorMessage, isUser: false);
      logger.error('Error processing message', e);
    }

    setState(() {
      _isTyping = false;
    });
  }

  void _addMessage(String text, {required bool isUser}) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
      ));
    });
    _conversationHistory.add({
      'role': isUser ? 'user' : 'assistant',
      'content': text,
    });
  }

  Future<void> _saveExpenseToDatabase(Map<String, dynamic> expenseInfo, String userId) async {
    try {
      // Get current date if not provided
      final expenseDate = expenseInfo['date'] != null 
          ? DateTime.parse(expenseInfo['date']) 
          : DateTime.now();
      
      // Create expense object
      final expense = Expense(
        id: DateTime.now().toIso8601String(),
        userId: userId,
        item: expenseInfo['item'] ?? 'Unknown Item',
        amount: (expenseInfo['amount'] as num?)?.toDouble() ?? 0.0,
        date: expenseDate,
        notes: expenseInfo['notes'] ?? '',
        location: expenseInfo['location'] ?? '',
        paymentMethod: expenseInfo['payment_method'] ?? '',
        currency: expenseInfo['currency'] ?? 'USD',
      );

      final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
      await expenseProvider.addExpense(expense, []);
    } catch (e) {
      logger.error('Failed to save expense to database', e);
      // We don't want to show an error message to the user if this fails
      // The conversation will continue normally
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.chatTitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyChat(l10n, theme)
                : _buildMessageList(theme),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'OurSpends is thinking...',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          _buildMessageInputField(l10n, theme),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              // TODO: Add an app icon or relevant image
              child: Icon(Icons.chat_bubble_outline, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.chatEmptyTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chatEmptySubtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip('Log a new expense', Icons.add_shopping_cart),
                _buildSuggestionChip('Summarize my spending', Icons.pie_chart_outline),
                _buildSuggestionChip('Show recent transactions', Icons.receipt_long),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: () {
        _messageController.text = label;
        _sendMessage();
      },
    );
  }

  Widget _buildMessageList(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return MessageBubble(
          message: message,
          isUser: message.isUser,
        );
      },
    );
  }

  Widget _buildMessageInputField(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: l10n.chatHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.scaffoldBackgroundColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: _sendMessage,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;

  const MessageBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isUser ? theme.colorScheme.primary : theme.cardColor;
    final textColor = isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            message.text,
            style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            _formatTimestamp(message.timestamp),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    // Simple time formatting (e.g., 10:30 AM)
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}