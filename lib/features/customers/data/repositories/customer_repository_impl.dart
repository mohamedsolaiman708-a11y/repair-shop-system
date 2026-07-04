import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final supabase.SupabaseClient _client;

  CustomerRepositoryImpl(this._client);

  @override
  Future<Result<List<CustomerEntity>, Failure>> searchCustomers(String query) async {
    try {
      final response = await _client
          .from('customers')
          .select()
          .or('name.ilike.%$query%,phone.ilike.%$query%');

      final list = (response as List)
          .map((json) => CustomerModel.fromJson(json).toEntity())
          .toList();
      return Result.success(list);
    } catch (e, stack) {
      Log.e('Search customers failure for query: $query', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<CustomerEntity?, Failure>> findCustomerByPhone(String phone) async {
    try {
      final response = await _client
          .from('customers')
          .select()
          .eq('phone', phone)
          .maybeSingle();

      if (response == null) {
        return const Result.success(null);
      }
      return Result.success(CustomerModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Find customer by phone failure: $phone', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<CustomerEntity, Failure>> createCustomer(CustomerEntity customer) async {
    try {
      final model = CustomerModel.fromEntity(customer);
      final response = await _client.from('customers').insert(model.toJson()).select().single();
      return Result.success(CustomerModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Create customer failure', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<CustomerEntity, Failure>> updateCustomer(CustomerEntity customer) async {
    try {
      final model = CustomerModel.fromEntity(customer);
      final response = await _client
          .from('customers')
          .update(model.toJson())
          .eq('id', customer.id)
          .select()
          .single();
      return Result.success(CustomerModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Update customer failure for ID: ${customer.id}', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }
}
