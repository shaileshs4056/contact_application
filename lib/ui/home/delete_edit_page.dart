import 'package:auto_route/auto_route.dart';
import 'package:contact_number_demo/router/app_router.dart';
import 'package:contact_number_demo/ui/home/add_contact_number.dart';
import 'package:contact_number_demo/values/colors.dart';
import 'package:contact_number_demo/values/extensions/widget_ext.dart';
import 'package:contact_number_demo/values/style.dart';
import 'package:contact_number_demo/values/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class DeleteEditPage extends StatefulWidget {
  final int id;
  DeleteEditPage({super.key, required this.id});
  @override
  State<DeleteEditPage> createState() => _DeleteEditPageState();
}

class _DeleteEditPageState extends State<DeleteEditPage> {
  String? image;
  late GlobalKey<FormState> _formKey;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController CompanyController;
  late FocusNode firstNameNode;
  late FocusNode lastNameNode;
  late FocusNode CompanyNode;
  late ValueNotifier<bool> showLoading;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    firstNameController =
        TextEditingController(text: contactList[widget.id].firstname);
    lastNameController =
        TextEditingController(text: contactList[widget.id].lastname);
    CompanyController =
        TextEditingController(text: contactList[widget.id].company);
    firstNameNode = FocusNode();
    lastNameNode = FocusNode();
    CompanyNode = FocusNode();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    CompanyController.dispose();
    firstNameNode.dispose();
    lastNameNode.dispose();
    CompanyNode.dispose();
    super.dispose();
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    CompanyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mercury,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leadingWidth: 60.w,
        backgroundColor: AppColor.mercury,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: InkWell(
          onTap: () {
            appRouter.pop();
          },
          child: Text(
            "Cancel",
            style: textBold.copyWith(color: AppColor.blueDiamond),
          ).wrapPaddingOnly(top: 15.h, left: 5.w),
        ),
        title: Text(
          "New Contact",
          style: textRegular.copyWith(color: AppColor.black),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Edit existing contact
                // final contact =
                //     contactList.firstWhere((c) => c.id == widget.id);
                // A.firstname = firstNameController.text;
                // contact.lastname = lastNameController.text;
                // contact.company = CompanyController.text;
                clearForm();
                context.router.replaceAll([ShowContactListRoute()]);
              }
            },
            child: Text(
              "Edit",
              style: textRegular.copyWith(color: AppColor.blueDiamond),
            ).wrapPaddingOnly(top: 15.h, right: 15.w),
          ),
          InkWell(
            onTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Edit existing contact

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.network(
                              'https://assets7.lottiefiles.com/packages/lf20_fcfjwiyb.json',
                              width: 100,
                              height: 100,
                              repeat: false,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Data deleted successfully",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              contactList.removeAt(widget.id);
                              appRouter.replaceAll([ShowContactListRoute()]);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    });
              }
            },
            child: Text(
              "Delete",
              style: textRegular.copyWith(color: AppColor.red),
            ).wrapPaddingOnly(top: 15.h, right: 15.w),
          )
        ],
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              width: 1.sw,
              color: AppColor.mercury,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                        color: AppColor.grey,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(image ??
                                'https://www.vhv.rs/dpng/d/505-5058560_person-placeholder-image-free-hd-png-download.png'),
                            fit: BoxFit.contain)),
                    height: 150.h,
                    width: 200.w,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
                    child: Text(
                      "Add Photo",
                      style: textBold.copyWith(
                        color: AppColor.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: AppColor.white,
              child: Column(
                children: [getSignInForm()],
              ),
            ),
            20.verticalSpace,
            buildCustomContainer(icon: Icons.add, text: "add Phone"),
            30.verticalSpace,
            buildCustomContainer(icon: Icons.add, text: "add email"),
            30.verticalSpace,
            buildCustomContainer(icon: Icons.add, text: "add pronounce"),
            30.verticalSpace,
            buildCustomContainerWithTextAndIcon(
                icon: Icons.arrow_forward_ios_outlined,
                leadingText: "Ringtone",
                trailingText: "Dedault"),
            30.verticalSpace,
            buildCustomContainerWithTextAndIcon(
                icon: Icons.arrow_forward_ios_outlined,
                leadingText: "Text Tone",
                trailingText: "Dedault"),
          ],
        ),
      ),
    );
  }

  Widget buildCustomContainerWithTextAndIcon({
    required String leadingText,
    required String trailingText,
    required IconData icon,
    Color leadingTextColor = Colors.black,
    Color trailingTextColor = Colors.blue,
    Color backgroundColor = Colors.white,
    TextStyle? textStyle,
  }) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(
            leadingText,
            style: textStyle ??
                TextStyle(fontSize: 16.sp, color: leadingTextColor),
          ),
          SizedBox(width: 15.w),
          Text(
            trailingText,
            style: (textStyle ?? TextStyle(fontSize: 16.sp))
                .copyWith(color: trailingTextColor),
          ),
          Spacer(),
          Icon(
            icon,
            size: 15.h,
          ),
        ],
      ).wrapPaddingSymmetric(horizontal: 15.w),
    );
  }

  Widget buildCustomContainer({
    required String text,
    required IconData icon,
    Color iconColor = Colors.white,
    Color backgroundColor = Colors.green,
  }) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor.withOpacity(0.5),
            ),
            child: Icon(
              icon,
              size: 15.h,
              color: iconColor,
            ),
          ),
          SizedBox(width: 15.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ), // You can use your textMedium style here
          ),
        ],
      ).wrapPaddingSymmetric(horizontal: 15.w),
    );
  }

  Widget getSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: firstNameController,
            validator: nameValidator,
            focusNode: firstNameNode,
            decoration: InputDecoration(
              hintText: "First name",
            ),
          ),
          TextFormField(
            controller: lastNameController,
            validator: nameValidator,
            focusNode: lastNameNode,
            decoration: InputDecoration(
              hintText: "Last name",
            ),
          ),
          TextFormField(
            controller: CompanyController,
            focusNode: CompanyNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Company",
            ),
          ),
        ],
      ),
    ).wrapPaddingSymmetric(horizontal: 15.w);
  }
}

// To show the dialog
void showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Text("bfcjsjb");
    },
  );
}
