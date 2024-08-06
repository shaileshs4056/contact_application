import 'package:form_field_validator/form_field_validator.dart';

class LYDPhoneValidator extends TextFieldValidator {
  // pass the error text to the super constructor

  String mobileInvalid;
  String emailInvalid;

  LYDPhoneValidator({
    String errorText = 'enter a valid LYD phone number',
    this.mobileInvalid = 'enter a valid phone number',
    this.emailInvalid = 'enter a valid email',
  }) : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.

  RegExp mobileRegex = RegExp(r"^(?:[+0]9)?[0-9]{10,12}$");
  RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  String mobilePattern = r"^(?:[+0]9)?[0-9]{10,12}$";

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    if (value!.contains("@")) {
      return hasMatch(emailPattern, value);
    } else {
      return hasMatch(mobilePattern, value);
    }
  }

  @override
  String call(String? value) {
    if (value!.isEmpty) return errorText;
    if (value.contains("@")) {
      return emailInvalid;
    } else {
      return mobileInvalid;
    }
  }
}
