import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:public_transport_tracker/features/bus/domain/bus_model.dart';

class BusRemoteDatasource {
  Future<QuerySnapshot<Map<String, dynamic>>> getBusByEmail(String email) {
    return FirebaseFirestore.instance
        .collection("buses")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();
  }

  Future<DocumentReference<Map<String, dynamic>>> createBus(
    BusSignUpDTO bus,
    String authId,
  ) {
    Map<String, dynamic> json = bus.toJson();
    json["authId"] = authId;
    return FirebaseFirestore.instance.collection("buses").add(json);
  }

  Future<void> deleteBusById(String id) {
    return FirebaseFirestore.instance.collection("buses").doc(id).delete();
  }
}
