import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final supabase.SupabaseClient _client;

  AuthRepositoryImpl(this._client);

  @override
  Future<Result<UserEntity, Failure>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Result.failure(AuthFailure('Invalid credentials or user not found'));
      }

      // Fetch additional user profile information from 'users' table
      final profileResponse = await _client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      final userModel = UserModel.fromJson(profileResponse);
      return Result.success(userModel.toEntity());
    } on supabase.AuthException catch (e) {
      Log.e('Supabase auth exception: ${e.message}');
      return Result.failure(AuthFailure(e.message));
    } catch (e, stack) {
      Log.e('Unexpected login failure', e, stack);
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> logout() async {
    try {
      await _client.auth.signOut();
      return const Result.success(null);
    } catch (e, stack) {
      Log.e('Logout failure', e, stack);
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity?, Failure>> getCurrentUser() async {
    try {
      final session = _client.auth.currentSession;
      if (session == null || session.user == null) {
        return const Result.success(null);
      }

      final profileResponse = await _client
          .from('users')
          .select()
          .eq('id', session.user!.id)
          .single();

      final userModel = UserModel.fromJson(profileResponse);
      return Result.success(userModel.toEntity());
    } catch (e, stack) {
      Log.e('Get current user profile failure', e, stack);
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get onAuthStateChanged {
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      final session = event.session;
      if (session == null || session.user == null) {
        return null;
      }
      try {
        final profileResponse = await _client
            .from('users')
            .select()
            .eq('id', session.user!.id)
            .single();

        return UserModel.fromJson(profileResponse).toEntity();
      } catch (e, stack) {
        Log.e('Auth state stream profile fetch failed', e, stack);
        return null;
      }
    });
  }
}
