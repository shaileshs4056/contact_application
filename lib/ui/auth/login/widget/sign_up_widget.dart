import 'package:flutter/material.dart';
import 'package:contact_number_demo/generated/assets.dart';
import 'package:contact_number_demo/generated/l10n.dart';
import 'package:contact_number_demo/values/export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpWidget extends StatelessWidget {
  final bool fromLogin;
  final Function() onTap;

  const SignUpWidget({
    required this.fromLogin,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColor.hamptonColor.withOpacity(0.349),
          borderRadius: const BorderRadius.all(
            Radius.circular(18.0),
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              fromLogin ? Assets.imageAddUser : Assets.imageUser,
              height: 28.0,
              width: 28.0,
            ),
            4.0.verticalSpace,
            Text(
              fromLogin
                  ? S.current.dontHaveAccount
                  : S.current.alreadyHaveAccount,
              style: textMedium.copyWith(
                color: AppColor.brownColor,
                fontSize: 16.spMin,
              ),
            ),
            4.0.verticalSpace,
            Text(
              fromLogin
                  ? S.current.signUp.toUpperCase()
                  : S.current.login.toUpperCase(),
              style: textBold.copyWith(
                color: AppColor.primaryColor,
                fontSize: 20.spMin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
