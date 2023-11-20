import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jobs_global/Screens/login_screen.dart';
import 'package:jobs_global/Utils/global.dart';
import 'package:jobs_global/Widgets/custom_button.dart';

import '../Widgets/custom_edtTextFeild.dart';
import 'dart:convert';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobs_global/Screens/bottom_navigator_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final textEditingControllerEmail = TextEditingController();
  final passwordEditControll = TextEditingController();
  final confirmPasswordEditControll = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String selectedValue = 'Candidate';
  bool? isLoading = false;
  Future<void> registerApiCall() async {
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
        var response = await http
            .post(Uri.parse('${Helper().get_api_urlold()}Signup'), body: {
          "user_email": textEditingControllerEmail.text.trim().toString(),
          "password": passwordEditControll.text.trim().toString(),
          "user_role":
              selectedValue == "Candidate" ? 2.toString() : 3.toString()
        });

        //  print(response.body);

        if (response.statusCode == 200) {
          var getResponseData = jsonDecode(response.body);

          if (getResponseData['error'] == false ||
              getResponseData['error'] == "false") {
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
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginScreen()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            bottom: 30,
            top: 0,
            child: SingleChildScrollView(
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
                          height: 12,
                        ),
                        CustomTextFieldWidget(
                          controller: confirmPasswordEditControll,
                          paswordVisble: true,
                          hintText: "Confirm Password",
                          prefixIcon: Icons.lock,
                          inputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: AppColor
                                .goldenColor, // Background color of the dropdown
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.black,
                              iconSize: 0,
                              value: selectedValue,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                });
                              },
                              items: <String>[
                                'Candidate',
                                'Company',
                              ]
                                  .map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: SizedBox(
                                        width: 100,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomButton(
                            text: "Signup",
                            onPressed: () async {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (textEditingControllerEmail.text
                                      .toString()
                                      .isEmpty ||
                                  passwordEditControll.text
                                      .toString()
                                      .isEmpty ||
                                  confirmPasswordEditControll.text
                                      .toString()
                                      .isEmpty) {
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
                              } else if (passwordEditControll.text
                                      .toString()
                                      .trim() !=
                                  (confirmPasswordEditControll.text
                                      .trim()
                                      .toString())) {
                                final snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: AppColor.goldenColor,
                                    duration: Duration(seconds: 1),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    content: const Text(
                                      "Confirm password not match",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                registerApiCall();
                              }
                            }),
                        const SizedBox(
                          height: 12,
                        ),
                        InkWell(
                          onTap: () async {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => LoginScreen()));
                          },
                          child: Text(
                            "Back to Login",
                            style: TextStyle(
                                color: AppColor.goldenColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
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
