import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient? _client;

  SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  // Auth helpers
  User? get currentUser => _client?.auth.currentUser;
  String? get currentUserId => _client?.auth.currentUser?.id;
  bool get isAuthenticated => _client?.auth.currentUser != null;

  // Stream for auth state changes
  Stream<AuthState> get authStateChanges => _client!.auth.onAuthStateChange;
}
