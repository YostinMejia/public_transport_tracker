import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:public_transport_tracker/domain/models/bus_model.dart';
import 'package:public_transport_tracker/domain/models/user_model.dart';

class FirebaseFirestoreDatasource {
  Query<UserModel> getUserById(String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: id)
        .withConverter(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(String email) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getBusByEmail(String email) {
    return FirebaseFirestore.instance
        .collection("buses")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();
  }

  Future<DocumentReference<Map<String, dynamic>>> createUser(
    UserSignUpDTO user,
    String authId,
  ) {
    Map<String, dynamic> json = user.toJson();
    json["authId"] = authId;
    return FirebaseFirestore.instance.collection("users").add(json);
  }

  Future<DocumentReference<Map<String, dynamic>>> createBus(
    BusSignUpDTO bus,
    String authId,
  ) {
    Map<String, dynamic> json = bus.toJson();
    json["authId"] = authId;
    return FirebaseFirestore.instance.collection("buses").add(json);
  }

  Future<void> deleteUserById(String id) {
    return FirebaseFirestore.instance.collection("users").doc(id).delete();
  }

   Future<void> deleteBusById(String id) {
    return FirebaseFirestore.instance.collection("buses").doc(id).delete();
  }
}
