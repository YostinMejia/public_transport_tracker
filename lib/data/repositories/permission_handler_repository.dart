import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerRepository {
  
  static void locationPermission()async{
    await Permission.location
  .onDeniedCallback(() {
    // Your code
    openAppSettings();
  })
  .onGrantedCallback(() {
    // Your code
  })
  .onPermanentlyDeniedCallback(() {
    // Your code
  })
  .onRestrictedCallback(() {
    // Your code
  })
  .onLimitedCallback(() {
    // Your code
  })
  .onProvisionalCallback(() {
    // Your code
    print("provisional");
  })
  .request();
  }

}