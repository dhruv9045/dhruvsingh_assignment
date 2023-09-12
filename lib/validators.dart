class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'\S+@\S+\.\S+',
  );

  static String? emailValidator(String? email) {
    if (email!.isEmpty) {
      return 'Enter email';
    } else if (!_emailRegExp.hasMatch(email)) {
      return 'Invalid email. Please try again';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password!.isEmpty) {
      return 'Enter password';
    } else if (password.length <= 8) {
      return 'Password is to short';
    } else {
      return null;
    }
  }

  static String? phoneValidator(String? phone) {
    if (phone!.isEmpty) {
      return 'Enter mobile number';
    } else if (phone.length <= 9 || phone.length >= 12) {
      return 'Number is not valid';
    } else {
      return null;
    }
  }

  static String? nameValidator(String? name) {
    if (name!.isEmpty) {
      return '''Enter your full name''';
    } else {
      return null;
    }
  }

  static String? notEmpty(String? name) {
    if (name!.isEmpty) {
      return '''Field can't be empty''';
    }
    return null;
  }
}
