import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';

class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return AlertDialog(
      title: Text(l10n.language),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: LanguageProvider.supportedLanguages.map((language) {
          final isSelected = languageProvider.currentLocale.languageCode == language['code'];
          
          return ListTile(
            leading: Radio<String>(
              value: language['code']!,
              groupValue: languageProvider.currentLocale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  languageProvider.changeLanguage(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            title: Text(language['nativeName']!),
            subtitle: Text(language['name']!),
            onTap: () {
              languageProvider.changeLanguage(language['code']!);
              Navigator.of(context).pop();
            },
            selected: isSelected,
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}

// Helper function to show the language selection dialog
void showLanguageSelectionDialog(BuildContext context) {
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