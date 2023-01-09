import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controller/login_details_controller.dart';

class TodayPageView extends GetView<LoginDetailsController> {

  final String loginDate;

  TodayPageView(this.loginDate, {Key? key}) : super(key: key);

  final LoginDetailsController instance = Get.find();
  String query = '';

  void initState() {
    query = loginDate;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: instance.loginReference.orderBy('loginDate',descending: false).snapshots(),
        builder: (context, snapshot) {
        if(snapshot.hasData){
          var docs = snapshot.data!.docs;
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index){
                    return docs[index]['loginDate'] == loginDate ?
                    Container(
                      margin: const EdgeInsets.only( bottom: 05),
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 05, bottom: 05),
                      child: Card(
                        color: Colors.grey.shade900,
                        child: ListTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(docs[index]['loginDate'].toString(), style: const TextStyle(
                                  color: Colors.white, fontSize: 18),),
                              Text("IP: ${docs[index]['ipAddress'].toString()}", style: const TextStyle(
                                  color: Colors.white, fontSize: 18),),
                              Text(docs[index]['currentAddress'].toString(), style: const TextStyle(
                                  color: Colors.white, fontSize: 18),),
                            ],
                          ),
                          trailing: Container(
                            height: 100,
                            width: 50,
                            color: Colors.white,
                            child: Center(
                              child: QrImage(
                                data: docs[index]['randomNumber'].toString(),
                                gapless: true,
                                size: 500,
                                errorCorrectionLevel: QrErrorCorrectLevel.H,
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        : Container();
                }
            );
          }else {
           return const Center(
             child: SizedBox(
               width: 50,
               height: 50,
               child: Text("No Login Details Available"),
             ),
           );
          }
        }
    );
  }
}
