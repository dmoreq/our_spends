import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../models/chat_message.dart';
import '../l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final List<Map<String, String>> _conversationHistory = [];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    
    // Debug logging
    print('DEBUG: Sending message: $message');
    print('DEBUG: User authenticated: ${authProvider.user != null}');
    print('DEBUG: ExpenseProvider loading: ${expenseProvider.isLoading}');
    
    // Allow demo mode when Gemini API key is configured
    if (authProvider.user == null) {
      print('DEBUG: User not authenticated, checking for demo mode');
      // Create a demo user ID for testing
      final demoUserId = 'demo_user_${DateTime.now().millisecondsSinceEpoch}';
      print('DEBUG: Using demo mode with user ID: $demoUserId');
      
      // Continue with demo user ID instead of returning
      await _processChatMessage(message, demoUserId, expenseProvider);
      return;
    }
    
    // Normal authenticated flow
    await _processChatMessage(message, authProvider.user!.uid, expenseProvider);
  }

  Future<void> _processChatMessage(String message, String userId, ExpenseProvider expenseProvider) async {
    // Add user message to chat and conversation history
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    // Add user message to conversation history
    _conversationHistory.add({
      'role': 'user',
      'content': message,
    });

    _messageController.clear();
    _scrollToBottom();

    // Send message to Gemini AI with conversation history
    try {
      print('DEBUG: Calling expenseProvider.sendMessage with userId: $userId');
      print('DEBUG: Conversation history length: ${_conversationHistory.length}');
      final response = await expenseProvider.sendMessage(message, userId, conversationHistory: _conversationHistory);
      print('DEBUG: Received response: $response');
      
      if (response['status'] == 'success') {
        final aiResponse = response['data'] ?? "I received your message!";
        
        // Add AI response to chat
        setState(() {
          _messages.add(ChatMessage(
            text: aiResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });

        // Add AI response to conversation history
        _conversationHistory.add({
          'role': 'assistant',
          'content': aiResponse,
        });

        // Check if expense information was extracted
        if (response['expense_info'] != null && response['expense_info']['hasExpense'] == true) {
          final expenseMessage = "💡 I detected an expense in your message! Would you like me to help you add it to your expense tracker?";
          
          setState(() {
            _messages.add(ChatMessage(
              text: expenseMessage,
              isUser: false,
              timestamp: DateTime.now(),
            ));
          });

          // Add expense detection message to conversation history
          _conversationHistory.add({
            'role': 'assistant',
            'content': expenseMessage,
          });
        }
      } else {
        final errorMessage = response['data'] ?? "Sorry, I couldn't process your message. Please try again.";
        
        setState(() {
          _messages.add(ChatMessage(
            text: errorMessage,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });

        // Add error response to conversation history
        _conversationHistory.add({
          'role': 'assistant',
          'content': errorMessage,
        });
      }
    } catch (e) {
      print('DEBUG: Error in sendMessage: $e');
      final errorMessage = "Sorry, I encountered an error. Please try again.";
      
      setState(() {
        _messages.add(ChatMessage(
          text: errorMessage,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });

      // Add error message to conversation history
      _conversationHistory.add({
        'role': 'assistant',
        'content': errorMessage,
      });
    }

    _scrollToBottom();
  }

  void _generateInsights() async {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    
    try {
      final response = await expenseProvider.generateInsights();
      
      setState(() {
        _messages.add(ChatMessage(
          text: "📊 Here are your spending insights:",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        
        _messages.add(ChatMessage(
          text: response['data'] ?? "Unable to generate insights at the moment.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Sorry, I couldn't generate insights right now. Please try again.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatTitle),
        centerTitle: true,
        actions: [
          Consumer<ExpenseProvider>(
            builder: (context, expenseProvider, child) {
              return IconButton(
                onPressed: expenseProvider.isLoading ? null : _generateInsights,
                icon: const Icon(Icons.insights),
                tooltip: 'Generate Spending Insights',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start tracking your expenses',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tell me about your purchases and I\'ll help you track them',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: l10n.chatHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    textInputAction: TextInputAction.send,
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<ExpenseProvider>(
                  builder: (context, expenseProvider, child) {
                    return Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: IconButton(
                        onPressed: expenseProvider.isLoading ? null : _sendMessage,
                        icon: expenseProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: message.isUser ? const Radius.circular(4) : null,
            bottomLeft: !message.isUser ? const Radius.circular(4) : null,
          ),
          border: message.isUser ? null : Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Text(
          message.text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: message.isUser
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}