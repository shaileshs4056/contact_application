import 'package:contact_number_demo/generated/l10n.dart';
import 'package:form_field_validator/form_field_validator.dart';

final MultiValidator nameValidator = MultiValidator([
  RequiredValidator(errorText: S.current.kEnterFirstName),
  MinLengthValidator(1, errorText: S.current.kEnterValidFirstName),
]);
final MultiValidator emailValidator = MultiValidator([
  RequiredValidator(errorText: S.current.kEnterEmailAddress),
  EmailValidator(errorText: S.current.kEnterValidEmailAddress),
]);
final MultiValidator mobileValidator = MultiValidator([
  RequiredValidator(errorText: S.current.kEnterMobileNumber),
  MinLengthValidator(10, errorText: S.current.kEnterValidMobileNumber),
]);
final MultiValidator mobileCodeValidator = MultiValidator([
  RequiredValidator(errorText: S.current.kEnterCountryCode),
]);
final MultiValidator passwordValidator = MultiValidator([
  RequiredValidator(errorText: S.current.kEnterPassword),
  MinLengthValidator(8, errorText: S.current.kEnterValidPassword),
]);
final MultiValidator confPasswordValidator = MultiValidator([
  RequiredValidator(errorText: S.current.kConfPassword),
  MinLengthValidator(8, errorText: S.current.kEnterValidPassword),
]);
final MultiValidator newPasswordValidator = MultiValidator([
  RequiredValidator(errorText: S.current.kEnterNewPassword),
  MinLengthValidator(8, errorText: S.current.kEnterValidPassword),
]);

final MultiValidator firstNameValidator = MultiValidator([
  RequiredValidator(errorText: S.current.kEnterFirstName),
]);
final MultiValidator lastNameValidator = MultiValidator([
  RequiredValidator(errorText: S.current.kEnterLastName),
]);
