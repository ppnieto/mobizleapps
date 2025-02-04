import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dashboard/controllers/event.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mobizleapps/classes/user.dart';

class AuthService<UserT extends UserBase> extends GetxController {
  //final Function(auth.User?)? onUserLogged;
  //final Function(auth.User?)? onUserSignout;
  final FutureOr<UserT> Function(auth.User) userBuilder;

  AuthService({required this.userBuilder});

  StreamSubscription<auth.User?>? _authSubscription;
  StreamSubscription<DocumentSnapshot>? _currentUserDocSubscription;

  UserT? currentUser;

  @override
  void onInit() {
    super.onInit();
    _initializeAuthListener();
  }

  Future<void> signOut() async {
    await auth.FirebaseAuth.instance.signOut();
  }

  Future<auth.User?> signInWithEmailAndPassword(String email, String password) async {
    auth.UserCredential result = await auth.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  Future<auth.UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    return auth.FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> _initializeAuthListener() async {
    _authSubscription ??= auth.FirebaseAuth.instance.authStateChanges().listen((auth.User? user) async {
      Get.log("authStateChanges ");
      if (user == null) {
        EventController.to.fire(MbzEvents.onUserLogout.name, currentUser?.authUser);
        currentUser = null;
      } else {
        currentUser = await userBuilder(user);
        await currentUser?.initAsync();
        EventController.to.fire(MbzEvents.onUserLogged.name, currentUser?.authUser);
      }
      _updateCurrentUserDocSubscription(user);
      update();
    });
  }

  void _updateCurrentUserDocSubscription(auth.User? user) {
    if (user == null) {
      _currentUserDocSubscription?.cancel();
      _currentUserDocSubscription = null;
    } else {
      _currentUserDocSubscription?.cancel();
      _currentUserDocSubscription = currentUser?.userDoc?.reference.snapshots().listen((event) async {
        Get.log('on change userDoc...');
        currentUser = await userBuilder(user);
        await currentUser?.initAsync();
        update();
        onUserUpdated();
      });
    }
  }

  void onUserUpdated() {
    Get.log('userDoc updated');
  }
/*

  Future<void> reloadUser() async {
    Get.log('Auth::reloadUser');
    if (auth.FirebaseAuth.instance.currentUser != null) {
      currentUser = await userBuilder(auth.FirebaseAuth.instance.currentUser!);
      await currentUser?.initAsync();
      update();
    } else {
      Get.log('no encuentro usuario actual');
    }
  }
  */
}
