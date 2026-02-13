import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/supabase_service.dart';
import '../../../services/secure_storage_service.dart';
import '../../../models/user_profile.dart';

class AuthService {
  final SupabaseService _supabaseService = SupabaseService();
  final SecureStorageService _secureStorage = SecureStorageService();

  SupabaseClient get _client => _supabaseService.client;

  // Get current user
  User? get currentUser => _supabaseService.currentUser;
  bool get isAuthenticated => _supabaseService.isAuthenticated;

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      // Create user profile
      if (response.user != null) {
        await _createUserProfile(response.user!);
      }

      // Save auth session to secure storage
      if (response.session != null) {
        await _saveSession(response.session!);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Save auth session to secure storage
      if (response.session != null) {
        await _saveSession(response.session!);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      final response = await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.budgetpadmanaban://login-callback/',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      // Clear secure storage
      await _secureStorage.clearAuthData();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  Future<UserProfile?> getUserProfile() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) return null;

      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _client
          .from('users')
          .update(profile.toJson())
          .eq('id', profile.id);
    } catch (e) {
      rethrow;
    }
  }

  // Create user profile (called after signup)
  Future<void> _createUserProfile(User user) async {
    try {
      final profile = UserProfile(
        id: user.id,
        email: user.email!,
        name: user.userMetadata?['name'] as String?,
        createdAt: DateTime.now(),
      );

      await _client.from('users').insert(profile.toJson());
    } catch (e) {
      // Profile might already exist - silently ignore
      // In production, use proper logging service
    }
  }

  // Save session to secure storage
  Future<void> _saveSession(Session session) async {
    await _secureStorage.saveAuthSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
      userId: session.user.id,
      email: session.user.email ?? '',
    );
  }

  // Check if has saved session
  Future<bool> hasAuthData() async {
    return await _secureStorage.hasAuthData();
  }

  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabaseService.authStateChanges;
}
