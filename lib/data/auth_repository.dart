import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class AuthRepository{
  final _client = SupabaseManager.client;

  Future<AuthResponse> signUp(String email, String password) async{
    return await _client.auth.signUp(
        email: email,
        password: password,
    );
  }

  Future<AuthResponse> signIn(String email, String password) async{
    return await _client.auth.signInWithPassword(
        email: email,
        password: password,
    );
  }

  Future<void> signOut() async{
    await _client.auth.signOut();
  }

  Session? get currentSession => _client.auth.currentSession;
}