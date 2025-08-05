import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  String _selectedProvider = ApiConfig.defaultProvider;
  final Map<String, TextEditingController> _apiKeyControllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadSettings();
  }

  void _initializeControllers() {
    for (String provider in ApiConfig.supportedProviders) {
      _apiKeyControllers[provider] = TextEditingController();
    }
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load selected provider
      _selectedProvider = prefs.getString('ai_provider') ?? ApiConfig.defaultProvider;
      
      // Load API keys
      for (String provider in ApiConfig.supportedProviders) {
        final apiKey = prefs.getString('${provider}_api_key') ?? '';
        _apiKeyControllers[provider]?.text = apiKey;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading settings: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save selected provider
      await prefs.setString('ai_provider', _selectedProvider);
      
      // Save API keys
      for (String provider in ApiConfig.supportedProviders) {
        final apiKey = _apiKeyControllers[provider]?.text ?? '';
        await prefs.setString('${provider}_api_key', apiKey);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    for (var controller in _apiKeyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveSettings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Provider',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select which AI service to use for expense analysis and insights.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          ...ApiConfig.supportedProviders.map((provider) {
                            return RadioListTile<String>(
                              title: Text(_getProviderDisplayName(provider)),
                              subtitle: Text(_getProviderDescription(provider)),
                              value: provider,
                              groupValue: _selectedProvider,
                              onChanged: (value) {
                                setState(() {
                                  _selectedProvider = value!;
                                });
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'API Keys',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your API keys for the AI services you want to use.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          ...ApiConfig.supportedProviders.map((provider) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_getProviderDisplayName(provider)} API Key',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _apiKeyControllers[provider],
                                    decoration: InputDecoration(
                                      hintText: 'Enter your ${_getProviderDisplayName(provider)} API key',
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.info_outline),
                                        onPressed: () => _showApiKeyInfo(provider),
                                      ),
                                    ),
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Security Notice',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'API keys are stored locally on your device and are only used to communicate with the selected AI service. They are not shared with any third parties.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _getProviderDisplayName(String provider) {
    switch (provider) {
      case 'openai':
        return 'ChatGPT (OpenAI)';
      case 'claude':
        return 'Claude (Anthropic)';
      case 'deepseek':
        return 'DeepSeek';
      case 'gemini':
        return 'Gemini (Google)';
      default:
        return provider.toUpperCase();
    }
  }

  String _getProviderDescription(String provider) {
    switch (provider) {
      case 'openai':
        return 'Advanced language model with excellent reasoning capabilities';
      case 'claude':
        return 'Anthropic\'s AI assistant known for helpful and harmless responses';
      case 'deepseek':
        return 'Efficient AI model with competitive performance';
      case 'gemini':
        return 'Google\'s multimodal AI with strong analytical capabilities';
      default:
        return 'AI provider';
    }
  }

  void _showApiKeyInfo(String provider) {
    String url;
    String instructions;
    
    switch (provider) {
      case 'openai':
        url = 'https://platform.openai.com/api-keys';
        instructions = '1. Sign up at OpenAI\n2. Go to API Keys section\n3. Create a new secret key\n4. Copy and paste it here';
        break;
      case 'claude':
        url = 'https://console.anthropic.com/';
        instructions = '1. Sign up at Anthropic\n2. Go to API Keys section\n3. Create a new API key\n4. Copy and paste it here';
        break;
      case 'deepseek':
        url = 'https://platform.deepseek.com/';
        instructions = '1. Sign up at DeepSeek\n2. Go to API Keys section\n3. Create a new API key\n4. Copy and paste it here';
        break;
      case 'gemini':
        url = 'https://makersuite.google.com/app/apikey';
        instructions = '1. Sign up at Google AI Studio\n2. Create a new API key\n3. Copy and paste it here';
        break;
      default:
        url = '';
        instructions = 'Please check the provider\'s documentation for API key instructions.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_getProviderDisplayName(provider)} API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How to get your API key:'),
            const SizedBox(height: 8),
            Text(instructions),
            if (url.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Visit: $url'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}