import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/providers/auth_provider.dart';

void main() {
  group('AuthProvider Tests', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider();
    });

    test('should initialize with default values', () {
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.isLoading, false);
      expect(authProvider.errorMessage, null);
      expect(authProvider.user, null);
    });

    test('should authenticate with demo mode', () async {
      // Sign in with Google (which uses demo authentication)
      final result = await authProvider.signInWithGoogle();
      
      // Verify authentication was successful
      expect(result, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.isLoading, false);
      expect(authProvider.errorMessage, null);
      
      // Verify demo user was created
      final user = authProvider.user;
      expect(user, isNotNull);
      expect(user?['uid'], 'demo-user-123');
      expect(user?['email'], 'demo@example.com');
      expect(user?['displayName'], 'Demo User');
    });

    test('should sign out successfully', () async {
      // First sign in
      await authProvider.signInWithGoogle();
      expect(authProvider.isAuthenticated, true);
      
      // Then sign out
      await authProvider.signOut();
      
      // Verify signed out state
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.isLoading, false);
      expect(authProvider.user, null);
    });

    test('should handle error states', () async {
      // Set an error message
      authProvider.setError('Test error message');
      
      // Verify error state
      expect(authProvider.errorMessage, 'Test error message');
      
      // Clear error
      authProvider.clearError();
      
      // Verify error was cleared
      expect(authProvider.errorMessage, null);
    });

    test('should handle loading states', () async {
      // Set loading state
      authProvider.setLoading(true);
      
      // Verify loading state
      expect(authProvider.isLoading, true);
      
      // Set loading state to false
      authProvider.setLoading(false);
      
      // Verify loading state was updated
      expect(authProvider.isLoading, false);
    });
  });
}