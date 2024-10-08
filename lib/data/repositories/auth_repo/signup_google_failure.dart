class SignupGoogleFailure{
  final String message;

  const SignupGoogleFailure([this.message = 'An unknown error occurred']);

  factory SignupGoogleFailure.code(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignupGoogleFailure('Email address is invalid.');
      case 'user-disabled':
        return const SignupGoogleFailure('This user has been disabled.');
      case 'user-not-found':
        return const SignupGoogleFailure('No user found for this email.');
      case 'wrong-password':
        return const SignupGoogleFailure('Incorrect password.');
      case 'account-exists-with-different-credential':
        return const SignupGoogleFailure(
            'An account already exists with the same email but different sign-in credentials.');
      case 'invalid-credential':
        return const SignupGoogleFailure('The credential provided is malformed or expired.');
      case 'operation-not-allowed':
        return const SignupGoogleFailure('Operation not allowed. Please contact support.');
      case 'network-request-failed':
        return const SignupGoogleFailure('Network error occurred. Please try again.');
      default:
        return const SignupGoogleFailure('An unknown error occurred.');
    }
  }
}
