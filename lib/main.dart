

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/navigation/get_pages.dart';
import 'package:myapp/navigation/routes_constant.dart';

void main()async{
  runApp(MyApp()) ;
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       title: "NaiviSense",
      theme: ThemeData.light(useMaterial3: true),
      initialRoute: RoutesConstant.splashPage,
      getPages: getPages,
    );
  }
}




