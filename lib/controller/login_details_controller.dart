import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/LoginDetailsModel.dart';
import '../model/UserModel.dart';
import '../view/login_page.dart';
import '../widget/dialog.dart';

class LoginDetailsController extends GetxController{

  static LoginDetailsController instance =Get.find();

  FirebaseAuth auth = FirebaseAuth.instance;


  /* Collection Create and  Read From Firebase for Login Details*/

  CollectionReference loginReference = FirebaseFirestore.instance.collection("LoginDetails");
  RxList<LoginDetailsModel> loginDetailsList = RxList<LoginDetailsModel>([]);
  late LoginDetailsModel loginDetailsModel;
  var foundToday = List.empty(growable: true).obs;
  var foundBefore = List.empty(growable: true).obs;

  Stream<List<LoginDetailsModel>> getLoginDetails() =>
      loginReference.snapshots().map((snapshot) =>
          snapshot.docs.map((item) => LoginDetailsModel.fromMap(item)).toList());


  /* Collection Create and  Read From Firebase for Login Details*/

  CollectionReference userReference = FirebaseFirestore.instance.collection("user");
  RxList<UserModel> userList = RxList<UserModel>([]);
  late UserModel userModel;


  Stream<List<UserModel>> getUser() =>
      userReference.snapshots().map((snapshot) =>
          snapshot.docs.map((item) => UserModel.fromMap(item)).toList());



  @override
  void onInit() {
    super.onInit();
    userList.bindStream(getUser());
    loginDetailsList.bindStream(getLoginDetails());
  }

  @override
  void onClose() {
    super.dispose();
  }

  /* Adding User Details to Collection User Details */

  Future addUserDetails(
      String phoneNumber,
      String otp,
      ) async {
    userReference.add({
      'phoneNumber': phoneNumber,
      'otp':otp,
    }).whenComplete(() {
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "UserDetails Added Successfully",
          message: "",
          backgroundColor: Colors.white);
    }).catchError((e){
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.redAccent);
    });
  }

  /* Adding Login Details to Collection Login Details */

  Future addLoginDetails(
  String loginDate,
  String yesterdayDate,
  String loginTime,
  String ipAddress,
  String currentAddress,
  String randomNumber,
  String qrImageUrl,
      ) async {
    loginReference.add({
      'loginDate': loginDate,
      'yesterdayDate':yesterdayDate,
      'loginTime': loginTime,
      'ipAddress':ipAddress,
      'currentAddress': currentAddress,
      'randomNumber': randomNumber,
      'qrImageUrl': qrImageUrl,
    }).whenComplete(() {
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "LoginDetails Added Successfully",
          message: "",
          backgroundColor: Colors.white);
    }).catchError((e){
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.redAccent);
    });
  }

/* Singing Out User*/

  void logOut() async {
    await auth.signOut().then((value) => Get.offAll(() => const LoginScreen()));
  }

}