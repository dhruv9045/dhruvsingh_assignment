import 'package:assignment/functions/firebaseFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString cnfPassword = ''.obs;
  RxString fullname = ''.obs;
  RxString phone = ''.obs;
  RxString fcmtoken = ''.obs;
  RxString gender = ''.obs;
  // RxString gender = ''.obs;
  RxList<String> genderList =
      ['--Select Gender--', 'Male', 'Female', 'Transgender'].obs;
  RxBool login = false.obs;
  RxBool isObservable = true.obs;

  loginUpdate(val) {
    login.value = val;
    update();
  }

  fcmUpdate(val) {
    fcmtoken.value = val;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    gender.value = genderList.first;
    super.onInit();
  }

  void signupUser(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.value, password: password.value);
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(fullname.value);
      await FirebaseAuth.instance.currentUser!.updateEmail(email.value);
      await FirestoreServices.saveUser(
          name: fullname.value,
          phone: phone.value,
          email: email.value,
          gender: gender.value,
          fcm: fcmtoken.value,
          uid: userCredential.user!.uid);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email Provided already Exists')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void signinUser(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.value, password: password.value);
      await FirestoreServices.updateUser(
          fcm: fcmtoken.value, uid: userCredential.user!.uid);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('You are Logged in')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user Found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Password did not match')));
      }
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
