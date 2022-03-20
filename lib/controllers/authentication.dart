import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schueler_app/controllers/notifications.dart';
import 'package:schueler_app/controllers/web_data.dart';

import './local_data.dart';

import '../models/exceptions/auth_data_exception.dart';

enum AuthState { LOGGED_IN, LOGGED_OFF }

class Authentication extends GetxController {
  Rx<AuthState> authState = AuthState.LOGGED_OFF.obs;
  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
  }

  void changeState(User? user) {
    if (user == null) {
      authState.value = AuthState.LOGGED_OFF;
    } else {
      authState.value = AuthState.LOGGED_IN;
    }
    update();
  }

  Future<void> login() async {
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
      final notifications = Get.find<Notifications>();
      final webData = Get.find<WebData>();
      await notifications.initialize();
      await webData.fetchData();
      authState.value = AuthState.LOGGED_IN;
      notifications.manageSubscription();
      ever(firebaseUser, changeState);
    } on FirebaseAuthException catch (e) {
      localData.error = e.message;
    } catch (e) {
      localData.error = e.toString();
    }
    update();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
