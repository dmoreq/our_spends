import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/auth_wrapper.dart';
import 'providers/auth_provider.dart';
import 'providers/expense_provider.dart';
import 'theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase with demo configuration for web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'demo-api-key',
        appId: '1:123456789:web:demo-app-id',
        messagingSenderId: '123456789',
        projectId: 'demo-project-id',
        authDomain: 'demo-project-id.firebaseapp.com',
        storageBucket: 'demo-project-id.appspot.com',
        measurementId: 'G-DEMO123456',
      ),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue without Firebase for demo purposes
  }
  
  runApp(const FamilyExpenseTrackerApp());
}

class FamilyExpenseTrackerApp extends StatelessWidget {
  const FamilyExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        title: 'Family Expense Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('vi', ''),
        ],
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
