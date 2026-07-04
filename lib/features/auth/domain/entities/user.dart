enum UserRole {
  admin('Administrator'),
  operator('Branch Operator');

  final String label;
  const UserRole(this.label);

  static UserRole fromString(String value) {
    if (value.toLowerCase() == 'administrator' || value.toLowerCase() == 'admin') {
      return UserRole.admin;
    }
    return UserRole.operator;
  }
}

class UserEntity {
  final String id;
  final String? branchId;
  final String fullName;
  final String email;
  final String? phone;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    this.branchId,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isOperator => role == UserRole.operator;
}
