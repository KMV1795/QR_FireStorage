import 'package:get/get.dart';
import 'package:qr_demo/view/today_page.dart';
import '../view/bindings.dart';
import '../view/login_page.dart';
import '../view/plugin_page.dart';

class AppRoute {
  AppRoute._(); // to prevent instantiating object

  static final routes = [
    GetPage(name: '/loginPage', page: () => const LoginScreen()),

    GetPage(
      name: '/dashBoardPage',
      page: () => const DashBoardPage(
        loginDate: '',
        yesterdayDate: '',
        loginTime: '',
        locationAddress: '',
        ipAddress: '',
      ),
    ),

    GetPage(
        name: '/todayPage',
        page: () => TodayPageView(""),
        binding: LoginDetailsBindings()),
  ];
}
