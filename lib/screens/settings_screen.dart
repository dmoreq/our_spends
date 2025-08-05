import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/auth_provider.dart';
import '../l10n/app_localizations.dart';
import 'ai_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Profile Section
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final user = authProvider.user;
              final demoUser = authProvider.demoUser;
              
              // Show user info if either real user or demo user is available
              if (user == null && demoUser == null) return const SizedBox.shrink();
              
              final displayName = user?.displayName ?? demoUser?['displayName'] ?? 'User';
              final email = user?.email ?? demoUser?['email'] ?? '';
              final isDemo = demoUser != null;
              
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text(
                              displayName.substring(0, 1).toUpperCase(),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  email,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isDemo) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Demo Mode',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Settings Options
          _buildSettingsSection(
            context,
            title: 'Preferences',
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.smart_toy,
                title: 'AI Settings',
                subtitle: 'Configure AI providers and API keys',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AISettingsScreen(),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.attach_money,
                title: l10n.currency,
                subtitle: 'VND',
                onTap: () {
                  // TODO: Implement currency selection
                },
              ),
              Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) {
                  return ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.language),
                    subtitle: Text(languageProvider.getLanguageName(languageProvider.currentLocale.languageCode)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showLanguageSelectionDialog(context),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSettingsSection(
            context,
            title: 'Data',
            children: [
              _buildSettingsTile(
                context,
                icon: Icons.bar_chart,
                title: l10n.reports,
                subtitle: 'View expense reports',
                onTap: () {
                  // TODO: Navigate to reports screen
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSettingsSection(
            context,
            title: 'Account',
            children: [
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return _buildSettingsTile(
                    context,
                    icon: Icons.logout,
                    title: l10n.logout,
                    subtitle: 'Sign out of your account',
                    onTap: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(l10n.logout),
                          content: const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(l10n.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(l10n.logout),
                            ),
                          ],
                        ),
                      );

                      if (shouldLogout == true) {
                        await authProvider.signOut();
                      }
                    },
                    isDestructive: true,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive 
            ? Theme.of(context).colorScheme.error 
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: isDestructive ? Theme.of(context).colorScheme.error : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return AlertDialog(
              title: Text(l10n.selectLanguage),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text(l10n.english),
                    value: 'en',
                    groupValue: languageProvider.currentLocale.languageCode,
                    onChanged: (String? value) {
                      if (value != null) {
                        languageProvider.changeLanguage(value);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(l10n.vietnamese),
                    value: 'vi',
                    groupValue: languageProvider.currentLocale.languageCode,
                    onChanged: (String? value) {
                      if (value != null) {
                        languageProvider.changeLanguage(value);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}