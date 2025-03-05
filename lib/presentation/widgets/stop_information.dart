import 'package:flutter/material.dart';
import 'package:public_transport_tracker/domain/models/stop_model.dart';

class StopInformation extends StatelessWidget {
  final StopModel stop;
  final double distance;
  StopInformation({super.key, required this.stop, required this.distance});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color.fromARGB(255, 152, 188, 153),
      child: ListTile(
        title: Text(stop.name),
        subtitle: Text("Address: ${stop.address}\nDistance: ${distance.round()} Meters"),
        trailing: Icon(Icons.bus_alert_outlined),
        isThreeLine: true,
      ),
    );
  }
}
