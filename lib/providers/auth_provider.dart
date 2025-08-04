import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDemoAuthenticated = false;
  Map<String, dynamic>? _demoUser;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null || _isDemoAuthenticated;
  Map<String, dynamic>? get demoUser => _demoUser;

  AuthProvider() {
    // Initialize GoogleSignIn - for demo purposes, we'll skip the client ID
    // to avoid popup blocking issues and go straight to demo mode
    if (kIsWeb) {
      _googleSignIn = GoogleSignIn();
    } else {
      _googleSignIn = GoogleSignIn();
    }
    
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      // Since we're using demo configuration, go directly to demo authentication
      // This prevents popup blocking issues and provides a smooth demo experience
      print('Demo mode: Skipping Google Sign-In popup to prevent browser blocking');
      await _simulateDemoAuthentication();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to sign in: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> _simulateDemoAuthentication() async {
    // For demo purposes, we'll create a mock user object
    print('Demo authentication: Simulating successful sign-in');
    _isDemoAuthenticated = true;
    _demoUser = {
      'uid': 'demo-user-123',
      'email': 'demo@example.com',
      'displayName': 'Demo User',
      'photoURL': null,
    };
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
      _isDemoAuthenticated = false;
      _demoUser = null;
      
      _setLoading(false);
    } catch (e) {
      _setError('Failed to sign out: ${e.toString()}');
      _setLoading(false);
    }
  }

  Future<void> _createOrUpdateUserDocument(User user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Create new user document
        await userDoc.set({
          'email': user.email,
          'display_name': user.displayName,
          'preferred_currency': 'VND',
          'created_at': FieldValue.serverTimestamp(),
          'last_login': FieldValue.serverTimestamp(),
        });
      } else {
        // Update last login
        await userDoc.update({
          'last_login': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error creating/updating user document: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}