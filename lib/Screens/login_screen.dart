import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobs_global/Screens/AdminScreen/admin_screen.dart';
import 'package:jobs_global/Screens/bottom_navigator_screen.dart';
import 'package:jobs_global/Screens/signUp_screen.dart';
import 'package:jobs_global/Utils/global.dart';
import 'package:jobs_global/Widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../DataBaseManagements/database.dart';
import '../Models/countryModel.dart';
import '../Utils/helper.dart';
import '../Models/cityModel.dart';
import '../Widgets/custom_edtTextFeild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final textEditingControllerEmail = TextEditingController();
  final passwordEditControll = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool? isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  SharedPreferences? prefs;

  Future<void> LoginApiCall() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    var getToken = prefs!.getString("token");

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
        if (mounted) {
          var response = await http
              .post(Uri.parse('${Helper().get_api_urlold()}Login'), body: {
            "user_email": textEditingControllerEmail.text.trim().toString(),
            "password": passwordEditControll.text.trim().toString(),
            "fcm_token": getToken ?? ""
          });

          //  print(response.body);

          if (response.statusCode == 200) {
            var getResponseData = jsonDecode(response.body);

            if (getResponseData['error'] == false ||
                getResponseData['error'] == "false") {
              prefs!.setBool("isLogin", true);
              prefs!.setInt("userID", getResponseData['id']);
              prefs!.setString("userRole", getResponseData['role']);

              setState(() {
                isLoading = false;
              });
              final snackBar = SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColor.goldenColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  content: Text(
                    getResponseData['message'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              if (getResponseData['role'] == "employer") {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AdminHomePage()));
              } else if (getResponseData['role'] == "employee") {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => const BottomNavigatorScreen()));
              }
            } else {
              final snackBar = SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColor.goldenColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  content: Text(
                    getResponseData['message'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {
                isLoading = false;
              });
            }
          } else {
            setState(() {
              isLoading = false;
            });
            final snackBar = SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColor.goldenColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                content: const Text(
                  "SomeThing Went Wrong",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 40,
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
            top: 10,
            child: Form(
              key: _formKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: 200,
                      ),
                      CustomTextFieldWidget(
                        controller: textEditingControllerEmail,
                        hintText: "User Email",
                        prefixIcon: Icons.person,
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: passwordEditControll,
                        paswordVisble: true,
                        hintText: "Password",
                        prefixIcon: Icons.lock,
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomButton(
                          text: "Submit",
                          onPressed: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            if (textEditingControllerEmail.text.isEmpty &&
                                passwordEditControll.text.isEmpty) {
                              final snackBar = SnackBar(
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Fill all fields first",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              LoginApiCall();
                            }
                          }),
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => SignUpScreen()));
                        },
                        child: Text(
                          "New User? SignUp",
                          style: TextStyle(
                              color: AppColor.goldenColor,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: AppColor.goldenColor,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          isLoading!
              ? Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: SpinKitCircle(
                    color: AppColor.goldenColor,
                    size: 80.0,
                  ))
              : Center()
        ],
      ),
    );
  }
}
