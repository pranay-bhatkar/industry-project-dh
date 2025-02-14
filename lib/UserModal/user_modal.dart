class UserModel {
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String role;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.role,
  });

  // Convert a UserModel into a Map. The keys should match the fields in your database.
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }

  // Extract a UserModel from a Map.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
