import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

final supabaseClientProvider = Provider<supabase.SupabaseClient>((ref) {
  try {
    return supabase.Supabase.instance.client;
  } catch (e) {
    throw 'يجب تهيئة Supabase أولاً قبل الوصول للعميل. تأكد من استدعاء Supabase.initialize';
  }
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(client);
});

final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.onAuthStateChanged;
});

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  FutureOr<UserEntity?> build() async {
    // مراقبة الستريم لتحديث الحالة تلقائياً
    final stream = ref.watch(authStateChangesProvider);
    
    return stream.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.login(email: email, password: password);
    state = result.fold(
      (user) => AsyncValue.data(user),
      (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.logout();
    state = result.fold(
      (_) => const AsyncValue.data(null),
      (failure) => AsyncValue.error(failure, StackTrace.current),
    );
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(() {
  return AuthNotifier();
});
