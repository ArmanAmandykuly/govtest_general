class GovTestRegisterUiState {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const GovTestRegisterUiState({
    this.email = "",
    this.password = "",
    this.firstName = "",
    this.lastName = "",
  });

  GovTestRegisterUiState copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
  }) {
    return GovTestRegisterUiState(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}
