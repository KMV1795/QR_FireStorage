import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:qr_demo/view/plugin_page.dart';
import '../controller/login_details_controller.dart';
import '../widget/dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  /* Global Key Declaration */

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /* TextField */

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController verifyOtpController = TextEditingController();

  String phoneNumber = '';
  String otp = '';
  bool verified = false;

  /* Firebase Auth */

  FirebaseAuth auth = FirebaseAuth.instance;
  AuthCredential? credential;

  final LoginDetailsController instance = Get.find();

  /* DateTime, Ip Address and Location*/

  String loginDate = "";
  String yesterdayDate = "";
  String loginTime = "";
  String ipAddress = "";
  Position? currentPosition;
  String currentAddress = "";

  /* Getting IP address*/

  Future<void> initPlatformState() async {
    String ip;
    try {
      ip = await Ipify.ipv4();
    } on PlatformException {
      ip = 'Failed to get ipAddress.';
    }
    if (!mounted) return;
    setState(() {
      ipAddress = ip;
    });
  }


  /* Getting Location And Address*/

  Future<Position> getLocation() async {

    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('', 'Location Permission Denied');
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (kDebugMode) {
      print(placemarks);
    }
    Placemark place = placemarks[0];
    currentAddress = '${place.locality}';
    setState(()  {
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SafeArea(
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.indigo,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.indigo,
            ),
            body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 25),
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 80, bottom: 50),
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ]),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          "Phone Number",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: phoneNumberController,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.indigo,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.indigo,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade800,
                            ),
                            onPressed: () async {

                              CustomSnackBar.showSnackBar(
                                  context: Get.context,
                                  title: "Verifying.....",
                                  message: "Sending OTP",
                                  backgroundColor: Colors.white);

                              CustomSnackBar.showSnackBar(
                                  context: Get.context,
                                  title: "Sending OTP.....",
                                  message: "",
                                  backgroundColor: Colors.white);

                              /* PhoneNumber Verification*/

                              auth.verifyPhoneNumber(
                                  phoneNumber: '+91${phoneNumberController.text}',
                                  verificationCompleted: (AuthCredential authCredential) {
                                    authCredential = PhoneAuthProvider.credential(
                                      verificationId: otp,
                                      smsCode: phoneNumber,
                                    );
                                    setState(() {
                                      verified = true;
                                      credential = authCredential;
                                      phoneNumber = '+91${phoneNumberController.text}';
                                    });
                                  },
                                  verificationFailed: (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  },
                                  codeSent:
                                      (String verificationId, int? token) {
                                    setState(() {
                                      otp = verificationId;
                                    });
                                  },
                                  codeAutoRetrievalTimeout: (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  });
                            },
                            child: const Text("Send OTP",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "OTP",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: verifyOtpController,
                          obscureText: true,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.indigo,
                                width: 0.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.indigo,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade800,
                              ),
                              onPressed: () async {

                                loginDate = DateFormat('MMMM,dd,yyyy')
                                    .format(DateTime.now());
                                yesterdayDate = DateFormat('MMMM,dd,yyyy')
                                    .format(DateTime.now()
                                        .subtract(const Duration(days: 1)));
                                loginTime = DateFormat('hh:mm:ss a')
                                    .format(DateTime.now());

                                /* Calling Ip and Location */

                                initPlatformState();
                                Position position = await getLocation();
                                getAddressFromLatLong(position);

                                if (kDebugMode) {
                                  print(
                                      "details------$yesterdayDate $loginDate $loginTime 'IP:$ipAddress--' $currentAddress");
                                }

                                try {
                                    if(verified == true){

                                      instance.addUserDetails(phoneNumberController.text,verifyOtpController.text);

                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => DashBoardPage(
                                            loginDate: loginDate,
                                            yesterdayDate: yesterdayDate,
                                            loginTime: loginTime,
                                            ipAddress: ipAddress,
                                            locationAddress: currentAddress,
                                          )));
                                    }else {
                                      CustomSnackBar.showSnackBar(
                                          context: Get.context,
                                          title: "Enter Phone Number and OTP to verify",
                                          message: "",
                                          backgroundColor: Colors.white);
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //     SnackBar(content: Text("Enter Phone Number and OTP to verify".toString())));
                                    }

                              }catch(e){
                                  if (kDebugMode) {
                                    print('Error---$e');
                                  }
                                }
                              },
                              child: const Text("Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 80),
                  child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(05),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.lightBlue,
                              offset: Offset(1.0, 1.0),
                            ),
                          ]),
                      child: const Center(
                          child: Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
