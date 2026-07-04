import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return CustomerRepositoryImpl(client);
});

final customerSearchProvider = FutureProvider.family.autoDispose<List<CustomerEntity>, String>((ref, query) async {
  if (query.trim().isEmpty) return const [];
  
  final repo = ref.watch(customerRepositoryProvider);
  
  // Wait a brief period to debounce keystrokes
  await Future.delayed(const Duration(milliseconds: 300));
  
  final result = await repo.searchCustomers(query);
  return result.fold(
    (list) => list,
    (failure) => throw Exception(failure.message),
  );
});

class CustomerNotifier extends AutoDisposeAsyncNotifier<CustomerEntity?> {
  late final CustomerRepository _repository;

  @override
  FutureOr<CustomerEntity?> build() {
    _repository = ref.watch(customerRepositoryProvider);
    return null;
  }

  Future<CustomerEntity?> findByPhone(String phone) async {
    state = const AsyncValue.loading();
    final result = await _repository.findCustomerByPhone(phone);
    return result.fold(
      (customer) {
        state = AsyncValue.data(customer);
        return customer;
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }

  Future<CustomerEntity?> create(CustomerEntity customer) async {
    state = const AsyncValue.loading();
    final result = await _repository.createCustomer(customer);
    return result.fold(
      (newCustomer) {
        state = AsyncValue.data(newCustomer);
        return newCustomer;
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }
}

final customerNotifierProvider = AutoDisposeAsyncNotifierProvider<CustomerNotifier, CustomerEntity?>(() {
  return CustomerNotifier();
});
