import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// https://stackoverflow.com/a/67151525/14017549
/// handles .isLimited for iOS 14+ where we can restrict access.
abstract class GrantPermissionStrategy {
  final Permission permission;

  GrantPermissionStrategy(this.permission);

  Future<void> request({
    required final OnPermanentlyDenied onPermanentlyDenied,
    required final OnPermissionDenied onPermissionDenied,
    required final OnGranted onGranted,
  }) async {
    final PermissionStatus status = await permission.status;
    debugPrint("GrantPermissionStrategy status: $status");
    if (status.isPermanentlyDenied) {
      onPermanentlyDenied.call();
      return;
    }

    if (!status.isLimited && !status.isGranted) {
      final PermissionStatus result = await permission.request();
      debugPrint(result.index.toString());
      if (result.isDenied) {
        onPermissionDenied.call();
        return;
      }
      if (result.isPermanentlyDenied) {
        onPermanentlyDenied.call();
        return;
      }
    }
    onGranted.call();
  }
}

typedef OnPermanentlyDenied = void Function();
typedef OnPermissionDenied = void Function();

typedef OnGranted = void Function();

class CameraPermission extends GrantPermissionStrategy {
  CameraPermission() : super(Permission.camera);
}

class PhotosPermission extends GrantPermissionStrategy {
  PhotosPermission()
      : super(Platform.isAndroid ? Permission.storage : Permission.photos);
}

class ContactsPermission extends GrantPermissionStrategy {
  ContactsPermission() : super(Permission.contacts);
}

class LocationPermission extends GrantPermissionStrategy {
  LocationPermission() : super(Permission.locationWhenInUse);
}
