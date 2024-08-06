import 'package:flutter/material.dart';
import 'package:contact_number_demo/values/export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonOkText;
  final String buttonCancelText;
  final VoidCallback? onTapOkCallback;
  final VoidCallback? onTapCancelCallback;

  const CustomAlertDialog({
    required this.title,
    required this.subTitle,
    required this.buttonOkText,
    required this.buttonCancelText,
    this.onTapOkCallback,
    this.onTapCancelCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: AppColor.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Text(
                title,
                style: textBold,
              ),
            ),
            Divider(
              height: 0,
              thickness: 1.h,
              color: AppColor.primaryColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
              child: Text(
                subTitle,
                textAlign: TextAlign.center,
                style: textMedium.copyWith(fontSize: 20.spMin),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onTapCancelCallback!();
                    },
                    child: LayoutBuilder(
                      builder: (context, snapshot) {
                        return Container(
                          width: 100.w,
                          height: 40.h,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: AppColor.primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              buttonCancelText,
                              style: textBold.copyWith(color: AppColor.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20.w),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onTapOkCallback!();
                    },
                    child: LayoutBuilder(
                      builder: (context, snapshot) {
                        return Container(
                          width: 100.w,
                          height: 40.h,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: AppColor.primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              buttonOkText,
                              style: textBold.copyWith(color: AppColor.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
