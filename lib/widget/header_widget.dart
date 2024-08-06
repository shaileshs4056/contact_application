import 'package:flutter/material.dart';
import 'package:contact_number_demo/generated/assets.dart';
import 'package:contact_number_demo/values/export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarWidget extends StatefulWidget {
  final Widget? actionMenu;
  final double paddingStart;
  final Color backgroundColor;

  const AppBarWidget({
    this.actionMenu,
    this.paddingStart = 10.0,
    this.backgroundColor = AppColor.white,
    super.key,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

double paddingTop = kToolbarHeight - 20;

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      padding: EdgeInsets.only(top: paddingTop),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Image.asset(
              Assets.imageBack,
              height: 20.h,
              width: 80.w,
            ),
          ),
          const Spacer(),
          widget.actionMenu ?? Container()
        ],
      ),
    );
  }
}
