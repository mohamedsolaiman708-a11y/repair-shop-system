import '../../../../core/errors/failures.dart';
import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<Result<List<CustomerEntity>, Failure>> searchCustomers(String query);

  Future<Result<CustomerEntity?, Failure>> findCustomerByPhone(String phone);

  Future<Result<CustomerEntity, Failure>> createCustomer(CustomerEntity customer);

  Future<Result<CustomerEntity, Failure>> updateCustomer(CustomerEntity customer);
}
