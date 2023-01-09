import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? otp;
  String? phoneNumber;


  UserModel(
      this.otp,
      this.phoneNumber,

      );

  UserModel.fromMap(DocumentSnapshot data) {
    otp = data.id;
    phoneNumber = data["phoneNumber"];

  }
}