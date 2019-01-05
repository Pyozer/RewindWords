import 'package:simple_permissions/simple_permissions.dart';

Future<bool> requestPermissions(List<Permission> permissions) async {
  bool isAllOk = true;
  for (final permission in permissions) {
    final status = await SimplePermissions.requestPermission(permission);
    if (status != PermissionStatus.authorized) isAllOk = false;
  }

  return isAllOk;
}
