import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  final TextEditingController _geminiApiKeyController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load Gemini API key
      final apiKey = prefs.getString('gemini_api_key') ?? '';
      _geminiApiKeyController.text = apiKey;
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
      
      // Save Gemini API key
      final apiKey = _geminiApiKeyController.text;
      await prefs.setString('gemini_api_key', apiKey);
      
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
    _geminiApiKeyController.dispose();
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
                            'This app uses Google Gemini for expense analysis and insights.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            title: const Text('Gemini (Google)'),
                            subtitle: const Text('Google\'s multimodal AI with strong analytical capabilities'),
                            leading: const Icon(Icons.check_circle, color: Colors.green),
                          ),
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gemini (Google) API Key',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _geminiApiKeyController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your Gemini API key',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.info_outline),
                                      onPressed: () => _showGeminiApiKeyInfo(),
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                              ],
                            ),
                          ),
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

  void _showGeminiApiKeyInfo() {
    const String url = 'https://makersuite.google.com/app/apikey';
    const String instructions = '1. Sign up at Google AI Studio\n2. Create a new API key\n3. Copy and paste it here';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gemini (Google) API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How to get your API key:'),
            const SizedBox(height: 8),
            const Text(instructions),
            const SizedBox(height: 16),
            Text('Visit: $url'),
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