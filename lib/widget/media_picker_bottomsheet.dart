import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/locator/locator.dart';
import '../generated/l10n.dart';
import '../router/app_router.dart';
import '../values/colors.dart';
import '../values/style.dart';

///This class will use for taking image and video from camera and galley.

class MediaPickerSheet extends StatelessWidget {
  const MediaPickerSheet({
    super.key,
    required this.pickFileType,
    required this.onSelectFile,
  });

  final PickedFileType pickFileType;
  final Function(XFile?, PickedFileType) onSelectFile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              locator<AppRouter>().pop();
              selectMedia(
                sourceType: SourceType.camera,
                pickFileType: pickFileType,
                onSelectFile: onSelectFile,
              );
            },
            child: _RoundedButton(
              buttonLabel: S.current.camera,
              bgColor: AppColor.primaryColor,
              textColor: AppColor.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              locator<AppRouter>().pop();
              selectMedia(
                sourceType: SourceType.gallery,
                pickFileType: pickFileType,
                onSelectFile: onSelectFile,
              );
            },
            child: _RoundedButton(
              buttonLabel: S.current.gallery,
              bgColor: AppColor.primaryColor,
              textColor: AppColor.white,
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => locator<AppRouter>().pop(),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 20,
              ),
              child: _RoundedButton(
                buttonLabel: S.current.cancel,
                bgColor: AppColor.primaryColor,
                textColor: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> selectMedia({
    required SourceType sourceType,
    required PickedFileType pickFileType,
    required Function(XFile?, PickedFileType) onSelectFile,
  }) async {
    XFile? file;

    switch (sourceType) {
      case SourceType.camera:
        if (pickFileType == PickedFileType.image) {
          file = await ImagePicker().pickImage(source: ImageSource.camera);
        } else {
          file = await ImagePicker().pickVideo(source: ImageSource.camera);
        }

        onSelectFile(file, pickFileType);
        break;
      case SourceType.gallery:
        if (pickFileType == PickedFileType.image) {
          file = await ImagePicker().pickImage(source: ImageSource.gallery);
        } else {
          file = await ImagePicker().pickVideo(source: ImageSource.gallery);
        }

        onSelectFile(file, pickFileType);
        break;
    }
  }
}

class _RoundedButton extends StatelessWidget {
  final String buttonLabel;
  final EdgeInsets margin;
  final Color bgColor;
  final Color textColor;
  const _RoundedButton({
    required this.buttonLabel,
    required this.bgColor,
    required this.textColor,
    this.margin = const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: margin,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(100.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.5),
            offset: const Offset(0.5, 2.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: textBold.copyWith(color: textColor),
      ),
    );
  }
}

enum PickedFileType { image, video }

enum SourceType { camera, gallery }
