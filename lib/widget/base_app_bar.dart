import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:contact_number_demo/generated/assets.dart';
import 'package:contact_number_demo/values/export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  late String? title;
  bool centerTitle = false;
  late Color? backgroundColor;
  late double? elevations;
  List<Widget>? action;
  bool leadingIcon = false;
  bool showTitle = false;
  VoidCallback? backAction;
  Widget? titleWidget;
  Widget? leadingWidget;
  Color? leadingWidgetColor;
  Color? titleWidgetColor;

  BaseAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.backgroundColor = AppColor.primaryColor,
    this.elevations = 0.0,
    this.action,
    this.leadingIcon = false,
    this.showTitle = false,
    this.backAction,
    this.titleWidget,
    this.leadingWidget,
    this.leadingWidgetColor,
    this.titleWidgetColor,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  }) : assert(
          title == null || titleWidget == null,
          "Title and Title widget both can't be null",
        );

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<BaseAppBar> createState() => _BaseAppBarState();
}

class _BaseAppBarState extends State<BaseAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: widget.centerTitle,
      title: !widget.showTitle
          ? const SizedBox.shrink()
          : widget.titleWidget ??
              Text(
                widget.title!,
                style: textBold.copyWith(
                  fontSize: 19.spMin,
                  color: widget.titleWidgetColor,
                ),
              ),
      backgroundColor: widget.backgroundColor ?? AppColor.white,
      elevation: widget.elevations,
      automaticallyImplyLeading: false,
      //brightness: Brightness.dark,
      leading: widget.leadingIcon
          ? widget.leadingWidget ??
              IconButton(
                icon: Image.asset(
                  Assets.imageBack,
                  height: 20.0,
                  width: 24.0,
                  color: widget.leadingWidgetColor,
                ),
                onPressed: () {
                  if (widget.backAction != null) {
                    widget.backAction!.call();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
              )
          : null,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: widget.action, systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}
