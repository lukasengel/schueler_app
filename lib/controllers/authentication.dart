import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './local_data.dart';
import './web_data.dart';
import '../models/auth_data_exception.dart';

enum AuthState { LoggedIn, LoggedOff }

class Authentication extends GetxController {
  String error = "";
  AuthState authState = AuthState.LoggedOff;
  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
  }

  void changeState(User? user) {
    if (user == null) {
      authState = AuthState.LoggedOff;
    } else {
      authState = AuthState.LoggedIn;
    }
    update();
  }

  Future<void> login() async {
    error = "";
    final webData = Get.find<WebData>();
    final localData = Get.find<LocalData>();

    try {
      if (localData.settings.username.isEmpty ||
          localData.settings.password.isEmpty) {
        throw (AuthDataException.emptyCredentials());
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: localData.settings.username + "@example.com",
        password: localData.settings.password,
      );
      await webData.fetchData();
      ever(firebaseUser, changeState);
      authState = AuthState.LoggedIn;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? e.toString();
    } catch (e) {
      error = e.toString();
    }
    update();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
