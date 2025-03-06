import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerRepository {
  Future<PermissionStatus> locationPermission() async {
    return Permission.location.request();
  }
}
