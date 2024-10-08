class LoginWithEmailAndPasswordFailure {
  final String message;

  const LoginWithEmailAndPasswordFailure(
      [this.message = "An unknown error occurred."]);

  factory LoginWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'user-not-found':
        return const LoginWithEmailAndPasswordFailure(
            'No user found for that email.');
      case 'wrong-password':
        return const LoginWithEmailAndPasswordFailure(
            'Incorrect password. Please try again.');
      case 'invalid-email':
        return const LoginWithEmailAndPasswordFailure(
            'Email is not valid or badly formatted.');
      case 'user-disabled':
        return const LoginWithEmailAndPasswordFailure(
            'This user has been disabled. Please contact support for help.');
      case 'operation-not-allowed':
        return const LoginWithEmailAndPasswordFailure(
            'Operation is not allowed. Please contact support.');
      default:
        return const LoginWithEmailAndPasswordFailure();
    }
  }
}
