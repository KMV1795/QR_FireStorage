import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:qr_demo/view/last_login_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:math';
import '../controller/login_details_controller.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widget/dialog.dart';

class DashBoardPage extends StatefulWidget {
  final String loginDate;
  final String yesterdayDate;
  final String loginTime;
  final String locationAddress;
  final String ipAddress;

  const DashBoardPage({
    Key? key,
    required this.loginDate,
    required this.yesterdayDate,
    required this.loginTime,
    required this.locationAddress,
    required this.ipAddress,
  }) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {

  /* Firebase Instance */

  final LoginDetailsController instance = Get.find();

  /* Random Number Generation */

  Random random = Random();
  int number = 0;
  String randomNumberData = "";

  /* Random Number Generation */

  late String loginDate;
  late String yesterdayDate;
  late String loginTime;
  late String locationAddress;
  late String ipAddress;

  /* Convert QR to image File  */

  ScreenshotController screenshotController = ScreenshotController();

  late File qrFile;
  late File fullQrFile;
  var url;

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    qrFile = await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> widgetToImageFile(Uint8List capturedImage,) async {
    Directory newTempDir = await getTemporaryDirectory();
    String newTempPath = newTempDir.path;
    final newTime = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    String path = '$newTempPath/$newTime.png';
    fullQrFile = await File(path).writeAsBytes(capturedImage);
  }

  @override
  void initState() {
    super.initState();
    number = random.nextInt(100);
    randomNumberData = number.toString();
    loginDate = widget.loginDate;
    yesterdayDate = widget.yesterdayDate;
    loginTime = widget.loginTime;
    ipAddress = widget.ipAddress;
    locationAddress = widget.locationAddress;
    if (kDebugMode) {
      print("number---$number $loginDate $yesterdayDate $loginTime $ipAddress $locationAddress");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: Stack(
          children: [
            Positioned(
              top: -60,
              right: -30,
              child: Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.all(Radius.circular(200)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  instance.logOut();
                },
                child: const Padding(
                  padding:
                  EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
                  child: Text(
                    "LOGOUT",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin:
              EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 09),
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                    ),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 30, right: 30, top: 20),
                      child: SizedBox(
                          height: 200,
                          width: 200,
                          child: QrImage(
                            data: randomNumberData,
                            gapless: true,
                            size: 250,
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Generated Number",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      randomNumberData,
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: Container(
                          height: 50,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 1.2,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(1.0, 1.0),
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Center(
                                child: Text(
                                  "Last login at today, $loginTime",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                )),
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {

                        CustomSnackBar.showSnackBar(
                            context: Get.context,
                            title: "Your Login Details are adding.........",
                            message: "",
                            backgroundColor: Colors.white);

                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your Login Details are adding.........".toString())));

                        /* Convert QR to image and save to Firebase Storage */

                        final qrValidationResult = QrValidator.validate(
                          data: randomNumberData,
                          version: QrVersions.auto,
                          errorCorrectionLevel: QrErrorCorrectLevel.L,
                        );

                        if (qrValidationResult.status ==
                            QrValidationStatus.valid) {
                          final qrCode = qrValidationResult.qrCode;
                          const String title = 'Qr';
                          const String address = 'image';
                          final painter = QrPainter.withQr(
                            qr: qrCode!,
                            color: const Color(0xFF000000),
                            gapless: true,
                            embeddedImageStyle: null,
                            embeddedImage: null,
                          );


                          Directory tempDir = await getTemporaryDirectory();
                          String tempPath = tempDir.path;
                          final time = DateTime
                              .now()
                              .millisecondsSinceEpoch
                              .toString();
                          final path = '$tempPath/$time.png';

                          // ui is from import 'dart:ui' as ui;
                          final picData = await painter.toImageData(2048,
                              format: ui.ImageByteFormat.png);

                          // writeToFile is seen in code snippet below
                          await writeToFile(
                            picData!,
                            path,
                          );
                          await screenshotController
                              .captureFromWidget(Column(
                               children: [
                               const Text(title),
                               Image.file(qrFile),
                               const Text(address),
                            ],
                          )).then((capturedImage) async {
                            await widgetToImageFile(capturedImage);
                          });
                        } else {
                          if (kDebugMode) {
                            print("Image not captured");
                          }
                        }

                        /* qrStorage is a reference to a folder in firebase storage */

                        await FirebaseStorage.instance
                            .ref('qrStorage')
                            .child('qrStorage/$loginDate/$loginTime')
                            .putFile(fullQrFile);
                        url = await FirebaseStorage.instance
                            .ref('qrStorage')
                            .child('qrStorage/$loginDate/$loginTime')
                            .getDownloadURL();


                        /* Add Login Details To Firebase */

                        instance.addLoginDetails(
                            loginDate,
                            yesterdayDate,
                            loginTime,
                            ipAddress,
                            locationAddress,
                            randomNumberData,
                            url.toString());

                        /* Navigate to Login Details page */

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                LastLoginPage(
                                  loginDate: loginDate,
                                  yesterdayDate: yesterdayDate,
                                )));
                      },
                      child: Center(
                        child: Container(
                            height: 50,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 1.5,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade800,
                                    offset: const Offset(1.0, 1.0),
                                  ),
                                ]),
                            child: const Center(
                                child: Text(
                                  "SAVE",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin:
              EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 13),
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
                        "PLUGIN",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}