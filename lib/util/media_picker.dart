// ignore_for_file: avoid_classes_with_only_static_members

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentPicker {
  /// Pick document
  /// [allowMultiple] pick multiple files
  /// [extension] filter file type by providing file extension
  /// [fileType] provide file type for pick particular media type
  static Future<List<PlatformFile>?> pickDocument({
    bool allowMultiple = false,
    String? extension,
    FileType fileType = FileType.custom,
  }) async {
    try {
      return (await FilePicker.platform.pickFiles(
        type: fileType,
        allowMultiple: allowMultiple,
        allowedExtensions: (extension?.isNotEmpty ?? false)
            ? extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
    } catch (ex, st) {
      debugPrint(ex.toString());
      debugPrintStack(stackTrace: st);
    }
    return null;
  }
}
