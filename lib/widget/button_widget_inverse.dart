import 'package:flutter/material.dart';
import 'package:contact_number_demo/values/export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButtonInverse extends StatelessWidget {
  final String label;
  final Function() callback;
  final double? elevation;
  final double? height;
  final double? radius;
  final double? padding;
  final bool buttonColor;

  const AppButtonInverse(
    this.label,
    this.callback, {
    super.key,
    double this.elevation = 0.0,
    this.height,
    this.radius,
    this.padding,
    this.buttonColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: MaterialButton(
        elevation: elevation,
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0).r,
        onPressed: callback,
        color: buttonColor ? AppColor.primaryColor : AppColor.primaryColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColor.primaryColor),
          borderRadius:
              BorderRadius.all(Radius.circular(radius ?? kBorderRadius)),
        ),
        child: Text(
          label,
          style: textBold.copyWith(color: AppColor.white, fontSize: 16.spMin),
        ),
      ),
    );
  }
}
