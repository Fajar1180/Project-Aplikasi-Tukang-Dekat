class AuthState {
  final bool isLoading;
  final String? token;
  final int? userId;
  final String? userRole;
  final String? userEmail;
<<<<<<< HEAD
  final String? errorMessage;
=======
  final String? userFullName;
  final String? userPhoneNumber;
  final String? userProfilePhotoPath;
  final String? providerStatus;
  final String? errorMessage;
  final Map<String, String?> fieldErrors;
>>>>>>> repo-b/main

  const AuthState({
    this.isLoading = false,
    this.token,
    this.userId,
    this.userRole,
    this.userEmail,
<<<<<<< HEAD
    this.errorMessage,
=======
    this.userFullName,
    this.userPhoneNumber,
    this.userProfilePhotoPath,
    this.providerStatus,
    this.errorMessage,
    this.fieldErrors = const {},
>>>>>>> repo-b/main
  });

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  AuthState copyWith({
    bool? isLoading,
    String? token,
    int? userId,
    String? userRole,
    String? userEmail,
<<<<<<< HEAD
    String? errorMessage,
=======
    String? userFullName,
    String? userPhoneNumber,
    String? userProfilePhotoPath,
    String? providerStatus,
    String? errorMessage,
    Map<String, String?>? fieldErrors,
>>>>>>> repo-b/main
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      userEmail: userEmail ?? this.userEmail,
<<<<<<< HEAD
      errorMessage: errorMessage,
    );
  }
}
=======
      userFullName: userFullName ?? this.userFullName,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      userProfilePhotoPath: userProfilePhotoPath ?? this.userProfilePhotoPath,
      providerStatus: providerStatus ?? this.providerStatus,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }
}
>>>>>>> repo-b/main
