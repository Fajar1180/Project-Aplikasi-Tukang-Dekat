class AuthResponse {
  final String message;
  final String? token;
  final UserData? user;

<<<<<<< HEAD
  AuthResponse({
    required this.message,
    this.token,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      token: json['token'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
=======
  AuthResponse({required this.message, this.token, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Extract data object - the actual response data
    final data = json['data'] as Map<String, dynamic>?;
    
    if (data == null) {
      return AuthResponse(
        message: json['message'] ?? 'Unknown error',
        token: null,
        user: null,
      );
    }

    return AuthResponse(
      message: json['message'] ?? data['message'] ?? '',
      token: data['token'],
      user: (data['user'] is Map<String, dynamic>)
          ? UserData.fromJson(data['user'] as Map<String, dynamic>)
          : null,
>>>>>>> repo-b/main
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String role;
<<<<<<< HEAD
=======
  final String? fullName;
  final String? phoneNumber;
  final String? providerStatus;
  final String? profilePhotoPath;
>>>>>>> repo-b/main

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
<<<<<<< HEAD
=======
    this.fullName,
    this.phoneNumber,
    this.providerStatus,
    this.profilePhotoPath,
>>>>>>> repo-b/main
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'CUSTOMER',
<<<<<<< HEAD
=======
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      providerStatus: json['provider_status'],
      profilePhotoPath: json['profile_photo_path'],
>>>>>>> repo-b/main
    );
  }
}
