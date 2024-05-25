import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/utils.dart';

class UserBase {
  final User authUser;
  DocumentSnapshot? userDoc;

  UserBase({required this.authUser});

  @mustCallSuper
  Future<void> initAsync() async {
    Get.log('UserBase::initAsync');
    DocumentReference userRef = FirebaseFirestore.instance.collection("users").doc(authUser.uid);
    userDoc = await userRef.get();
    if (userDoc!.exists == false) {
      // si no existe el usuario lo creamos
      userRef.set({
        'auth_data': {
          'displayName': authUser.displayName,
          'email': authUser.email,
          'isEmailVerified': authUser.emailVerified,
          'isAnonymous': authUser.isAnonymous,
          'metadata': {
            'creationTime': authUser.metadata.creationTime,
            'lastSignInTime': authUser.metadata.lastSignInTime,
          },
          'phoneNumber': authUser.phoneNumber,
          'photoURL': authUser.photoURL,
          'refreshToken': authUser.refreshToken,
          'tenantId': authUser.tenantId,
          'uid': authUser.uid
        }
      });
    }
    Get.log('userDoc = ${userDoc?.reference.path}');
  }
}
