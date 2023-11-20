import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobs_global/Models/cityModel.dart';
import 'package:jobs_global/Screens/AdminScreen/admin_screen.dart';
import 'package:jobs_global/Screens/bottom_navigator_screen.dart';
import 'package:jobs_global/Screens/login_screen.dart';
import 'package:jobs_global/Utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../DataBaseManagements/database.dart';
import '../Models/countryModel.dart';
import '../Models/getAllCategoryModel.dart';
import '../Utils/helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    initlizedAllSettings();

    super.initState();
  }

  DatabaseHelper database = DatabaseHelper.instance;

  @override
  void dispose() {
    super.dispose();
  }

  SharedPreferences? prefs;

  initlizedAllSettings() async {
    if (mounted) {
      await getAllJobCategoryList();
    }

    prefs = await SharedPreferences.getInstance();

    bool? checkLogin = prefs!.getBool("isLogin");
    String? getUserRole = prefs!.getString('userRole');

    if (checkLogin == null || checkLogin == false) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      if (getUserRole == "employee" ||
          getUserRole == null ||
          getUserRole.isEmpty) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const BottomNavigatorScreen()));
      } else if (getUserRole == "employer") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AdminHomePage()));
      }
    }
  }

  Future<void> getAllJobCategoryList() async {
    // EasyLoading.show(status: 'Loading');

    if (!await InternetConnectionChecker().hasConnection) {
      final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColor.goldenColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          content: const Text(
            "Please Check Internet!",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        var response = await http.get(
          Uri.parse('${Helper().get_api_urlold()}Categories'),
        );

        //  print(response.body);

        if (response.statusCode == 200) {
          var getResponseData = jsonDecode(response.body);

          GetAllCategoryModel? info =
              GetAllCategoryModel.fromJson(getResponseData);

          if (info.error == false || info.error == "false") {
            if (info.data != null) {
              for (final data in info.data!) {
                await database.allCategorysaveData(data);
              }
            }
          } else {
            final snackBar = SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColor.goldenColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                content: Text(
                  info.message!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          final snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColor.goldenColor,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              content: const Text(
                "SomeThing Went Wrong",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        backgroundColor: AppColor.goldenColor,
      ),
      body: Stack(
        children: [
          Positioned(
              right: 0,
              top: 0,
              child: Image.asset(
                "assets/images/Layer1.png",
                height: 100,
                fit: BoxFit.cover,
              )),
          Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                "assets/images/Layer2.png",
                height: 100,
                fit: BoxFit.cover,
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.goldenColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
