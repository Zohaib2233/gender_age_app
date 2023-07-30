
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email address.';
  }
  if (!value.contains('@') || !value.contains('.com')) {
    return 'Please enter a valid email address.';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password.';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters long.';
  }
  return null;
}

