import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FineLocationDialog extends StatelessWidget {
  const FineLocationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "If you want tto know the distance between you and the next stop. Click Settings and active the permission to fine location",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      openAppSettings();
                    },
                    child: Text("Settings"),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
