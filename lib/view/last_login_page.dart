import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_demo/view/today_page.dart';
import 'package:qr_demo/view/yesterday_page.dart';
import '../controller/login_details_controller.dart';
import 'other_login_page.dart';

class LastLoginPage extends StatefulWidget {

  final String loginDate;
  final String yesterdayDate;

  const LastLoginPage({Key? key, required this.loginDate, required this.yesterdayDate}) : super(key: key);


  @override
  State<LastLoginPage> createState() => _LastLoginPageState();
}

class _LastLoginPageState extends State<LastLoginPage>with SingleTickerProviderStateMixin {

  final LoginDetailsController instance = Get.find();

  late TabController tabController;
  late String loginDate;
  late String yesterdayDate;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    loginDate = widget.loginDate;
    yesterdayDate = widget.yesterdayDate;
    if (kDebugMode) {
      print("date---$loginDate$yesterdayDate");
    }
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
              right: -10,
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
                onTap: (){
                  instance.logOut();
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 30,left: 20,right: 20,bottom: 10),
                  child: Text("LOGOUT",style: TextStyle(fontSize: 20,color: Colors.white),),
                ),
              ),
            ),
            Container(
             height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height /09),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                    ),
                  ]),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height:100,
                    child: TabBar(
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        labelColor: Colors.white,
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                          insets: EdgeInsets.only(bottom: 15, top: 10, left: 20, right: 20),
                        ),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          //color: Colors.white
                        ),
                        labelPadding: const EdgeInsets.only(bottom: 20, right: 20, left: 20,top: 30),
                        controller: tabController,
                        tabs: const [
                          Tab(
                            text: 'Today',
                          ),
                          Tab(
                            text: 'Yesterday',
                          ),
                          Tab(
                            text: 'Other',
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Container(
               margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 06),
               padding: const EdgeInsets.only(top: 50,bottom: 50),
              child: TabBarView(
                controller: tabController,
                children: [
                  TodayPageView(loginDate),
                  YesterdayPageView(yesterdayDate),
                  OtherPageView(loginDate,yesterdayDate),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 13 ),
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
                  child: const Center(child: Text("LAST LOGIN",style: TextStyle(color: Colors.white,fontSize: 25),))),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimarySmallEllipticalBackground extends StatelessWidget {
  final double? height;
  const PrimarySmallEllipticalBackground({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:100,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(20, 8),
            bottomRight: Radius.elliptical(20, 8)),
      ),
    );
  }
}