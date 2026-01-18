import 'package:get/get.dart';
import 'package:myapp/navigation/routes_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/globals/global_variables.dart' as glbv;

class SplashPageController extends GetxController{

  String version = 'v1.0.0';
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   _initializeApp();
  }

  _initializeApp() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    glbv.role = preferences.getString('role')??"";
    bool isLoggedIn = preferences.getBool('isLoggedIn')??false;
    glbv.apiUrl = preferences.getString('api')??'';
    await Future.delayed(Duration(seconds: 2));
    if(isLoggedIn)
      {

        Get.offAllNamed(RoutesConstant.homePage);
      }
    else
      {
        print("Going to Login");
        Get.offAllNamed(RoutesConstant.loginPage);
      }
  }

}