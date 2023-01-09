import 'package:cloud_firestore/cloud_firestore.dart';

class LoginDetailsModel {
  String? loginDate;
  String? yesterdayDate;
  String? loginTime;
  String? ipAddress;
  String? currentAddress;
  String? randomNumber;
  String? qrImageUrl;

  LoginDetailsModel(
      this.loginDate,
      this.yesterdayDate,
      this.loginTime,
      this.ipAddress,
      this.currentAddress,
      this.randomNumber,
      this.qrImageUrl,
      );

  LoginDetailsModel.fromMap(DocumentSnapshot data) {
    loginDate = data["loginDate"];
    yesterdayDate = data["yesterdayDate"];
    loginTime = data["loginTime"];
    ipAddress = data["ipAddress"];
    currentAddress = data["currentAddress"];
    randomNumber = data["randomNumber"];
    qrImageUrl = data["qrImageUrl"];
  }
}