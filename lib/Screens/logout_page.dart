import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobs_global/DataBaseManagements/riverPodStateManagemnts.dart';
import 'package:jobs_global/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/global.dart';

class LogoutPage extends ConsumerStatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends ConsumerState<LogoutPage> {
  SharedPreferences? prefs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColor.goldenColor,
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
