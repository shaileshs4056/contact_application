import 'package:auto_route/auto_route.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:contact_number_demo/core/locator/locator.dart';
import 'package:contact_number_demo/generated/l10n.dart';
import 'package:contact_number_demo/router/app_router.dart';
import 'package:contact_number_demo/ui/auth/login/widget/sign_up_widget.dart';
import 'package:contact_number_demo/values/export.dart';
import 'package:contact_number_demo/widget/app_text_filed.dart';
import 'package:contact_number_demo/widget/button_widget_inverse.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobx/mobx.dart';

import '../../../generated/assets.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final bool _isHidden = true;
  late GlobalKey<FormState> _formKey;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController passwordController;
  late TextEditingController confPasswordController;
  late FocusNode mobileNode;
  late ValueNotifier<bool> showLoading;
  late ValueNotifier<bool> _isRead;
  late List<ReactionDisposer> _disposers;

  bool get isCurrent => !ModalRoute.of(context)!.isCurrent;

  Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('US');

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    passwordController = TextEditingController();
    confPasswordController = TextEditingController();
    mobileNode = FocusNode();
    showLoading = ValueNotifier<bool>(false);
    _isRead = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confPasswordController.dispose();
    mobileNode.dispose();
    showLoading.dispose();
    _isRead.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30).r,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              30.0.verticalSpace,
              getHeaderContent(),
              getSignUpForm(),
              40.0.verticalSpace,
              SignUpWidget(
                fromLogin: false,
                onTap: () => locator<AppRouter>().pop(),
              ),
              40.0.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeaderContent() {
    return Column(
      children: [
        10.0.verticalSpace,
        Text(
          S.current.signUp.toUpperCase(),
          style: textBold.copyWith(
            color: AppColor.primaryColor,
            fontSize: 24.spMin,
          ),
        ),
        10.0.verticalSpace,
        Text(
          S.current.fillDetails,
          style: textLight.copyWith(
            color: AppColor.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget getSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          25.0.verticalSpace,
          AppTextField(
            controller: nameController,
            label: S.current.name,
            hint: S.current.name,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.sentences,
            validators: nameValidator,
            prefixIcon: IconButton(
              onPressed: null,
              icon: Image.asset(
                Assets.imageUser,
                color: AppColor.primaryColor,
                height: 26.0,
                width: 26.0,
              ),
            ),
          ),
          10.0.verticalSpace,
          AppTextField(
            controller: emailController,
            label: S.current.email,
            hint: S.current.email,
            keyboardType: TextInputType.emailAddress,
            validators: emailValidator,
            prefixIcon: IconButton(
              onPressed: null,
              icon: Image.asset(
                Assets.imageEmail,
                color: AppColor.primaryColor,
                height: 26.0,
                width: 26.0,
              ),
            ),
          ),
          10.0.verticalSpace,
          AppTextField(
            controller: mobileController,
            label: S.current.mobNumber,
            hint: S.current.mobNumber,
            keyboardType: TextInputType.phone,
            validators: mobileValidator,
            focusNode: mobileNode,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              LengthLimitingTextInputFormatter(10),
            ],
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: null,
                    icon: Image.asset(
                      Assets.imageMobile,
                      color: AppColor.primaryColor,
                      height: 26.0.r,
                      width: 26.0.r,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async => {
                      Future.delayed(Duration.zero, () {
                        mobileNode.unfocus();
                        mobileNode.canRequestFocus = false;
                      }),
                      await _openCountryPickerDialog(),
                      mobileNode.canRequestFocus = true,
                    },
                    child: Row(
                      children: [
                        Text(
                          '+${_selectedDialogCountry.phoneCode}',
                          style: textMedium.copyWith(
                            fontSize: 15.spMin,
                          ),
                        ),
                        5.0.horizontalSpace,
                        Image.asset(
                          Assets.imageArrowDown,
                          color: AppColor.osloGray,
                          height: 8.0,
                          width: 8.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          10.0.verticalSpace,
          AppTextField(
            label: S.current.password,
            hint: S.current.password,
            obscureText: _isHidden,
            validators: passwordValidator,
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            maxLength: 15,
            prefixIcon: IconButton(
              onPressed: null,
              icon: Image.asset(
                Assets.imagePassword,
                color: AppColor.primaryColor,
                height: 26.0,
                width: 26.0,
              ),
            ),
          ),
          10.0.verticalSpace,
          AppTextField(
            label: S.current.confPassword,
            hint: S.current.confPassword,
            obscureText: _isHidden,
            validators: confPasswordValidator,
            controller: confPasswordController,
            keyboardType: TextInputType.visiblePassword,
            keyboardAction: TextInputAction.done,
            maxLength: 15,
            prefixIcon: IconButton(
              onPressed: null,
              icon: Image.asset(
                Assets.imagePassword,
                color: AppColor.primaryColor,
                height: 26.0,
                width: 26.0,
              ),
            ),
          ),
          16.0.verticalSpace,
          ValueListenableBuilder<bool>(
            valueListenable: _isRead,
            builder: (context, bool value, child) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  height: 20.0,
                  width: 20.0,
                  duration: const Duration(milliseconds: 300),
                  child: IconButton(
                    splashColor: AppColor.transparent,
                    padding: EdgeInsets.zero,
                    icon: Image.asset(
                      Assets.imageCheckedBox,
                      color: value ? AppColor.primaryColor : AppColor.osloGray,
                    ),
                    onPressed: () => _isRead.value = !value,
                  ),
                ),
                8.0.horizontalSpace,
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: S.current.iAgree,
                      style: textLight.copyWith(
                        color: AppColor.grey,
                        fontSize: 14.spMin,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: S.current.tNc,
                          style: textSemiBold.copyWith(
                            fontSize: 14.spMin,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(S.current.tNc)),
                              );
                            },
                        ),
                        TextSpan(
                          text: S.current.and,
                        ),
                        TextSpan(
                          text: S.current.privacyPolicy,
                          style: textSemiBold.copyWith(
                            fontSize: 14.spMin,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.current.privacyPolicy),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          18.0.verticalSpace,
          AppButtonInverse(
            S.current.signUp.toUpperCase(),
            () {
              //navigator.pushNamed(RouteName.otpVerificationPage);
              if (_formKey.currentState?.validate() ?? false) {
                if (passwordController.text.trim() !=
                    confPasswordController.text.trim()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.current.passwordMismatch)),
                  );

                  return;
                }
                if (!_isRead.value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        S.current.acceptTnC,
                      ),
                    ),
                  );

                  return;
                }
                signUpAndNavigateToHome();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> signUpAndNavigateToHome() async {
    // locator<AppRouter>().push(const HomeRoute());
  }

  void removeDisposer() {
    for (final element in _disposers) {
      element.reaction.dispose();
    }
  }

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          const SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );

  Future _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => CountryPickerDialog(
          titlePadding: const EdgeInsets.all(8.0),
          searchCursorColor: Colors.lightBlueAccent,
          searchInputDecoration: InputDecoration(hintText: S.current.search),
          isSearchable: true,
          title: Text(S.current.selectYourPhoneCode),
          onValuePicked: (Country country) =>
              setState(() => _selectedDialogCountry = country),
          itemBuilder: _buildDialogItem,
          priorityList: [
            CountryPickerUtils.getCountryByIsoCode('US'),
            CountryPickerUtils.getCountryByIsoCode('IN'),
          ],
        ),
      );
}
