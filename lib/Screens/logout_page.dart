import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobs_global/DataBaseManagements/database.dart';
import 'package:jobs_global/DataBaseManagements/riverPodStateManagemnts.dart';
import 'package:jobs_global/Screens/login_screen.dart';
import 'package:jobs_global/Screens/signUp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:jobs_global/Screens/HomePageDeatilsSection/jobDeatilsPage.dart';
import 'package:jobs_global/Utils/global.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobs_global/Utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/all_jobs_model.dart';
import '../../Utils/helper.dart';
import '../Utils/global.dart';

class LogoutPage extends ConsumerStatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends ConsumerState<LogoutPage> {
  SharedPreferences? prefs;
  DatabaseHelper database = DatabaseHelper.instance;
  bool? isLoading = false;
  Future<void> deleteUserAccont() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    int? userId = await prefs!.getInt("userID");

    if (!await InternetConnectionChecker().hasConnection) {
      setState(() {
        isLoading = false;
      });
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
        var response = await http.get(Uri.parse(
            '${Helper().get_api_urlold()}deleteEmployerUser/$userId'));

        print(response.body);

        if (response.statusCode == 200) {
          var getResponseData = jsonDecode(response.body);

          GetAllJobsModel? info = GetAllJobsModel.fromJson(getResponseData);

          if (info.error == false || info.error == "false") {
            setState(() {
              isLoading = false;
            });

            prefs = await SharedPreferences.getInstance();
            await prefs!.clear();
            database.resetDatabase();
            ref.invalidate(bottomAppBarStateNotifer);
            database = DatabaseHelper.instance;

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
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignUpScreen()));
          } else {
            setState(() {
              isLoading = false;
            });
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
          setState(() {
            isLoading = false;
          });
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
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showDialog(
    BuildContext context,
    String text,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permanently Delete Account?"),
          content: Text(text),
          actions: <Widget>[
            MaterialButton(
              child: Text(
                "Delete",
                style: TextStyle(color: AppColor.goldenColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteUserAccont();
                // Perform your action here
                // Close the dialog
              },
            ),
            MaterialButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: AppColor.goldenColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                // Perform your action here
                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColor.goldenColor,
        actions: [
          InkWell(
            onTap: () async {
              _showDialog(context,
                  "Are you certain about permanently deleting your account? Deleting your account entails the removal of all personal information, and once deleted, access to the account will no longer be possible. This action is irreversible and results in the complete erasure of associated data.");
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              alignment: Alignment.center,
              child: Text(
                "Delete Account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: InkWell(
            onTap: () async {
              prefs = await SharedPreferences.getInstance();
              await prefs!.clear();
              ref.invalidate(bottomAppBarStateNotifer);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logout.png",
                  color: AppColor.goldenColor,
                  height: 80,
                ),
                const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
