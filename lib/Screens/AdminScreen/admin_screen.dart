import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jobs_global/Screens/AdminScreen/company_profile_page.dart';
import 'package:jobs_global/Screens/AdminScreen/create_new_post_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:jobs_global/Models/candidate_profile_model.dart';

import 'dart:async';
import 'dart:convert';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import '../../DataBaseManagements/riverPodStateManagemnts.dart';
import '../../Utils/global.dart';
import '../../Utils/helper.dart';
import '../bottom_navigator_screen.dart';
import '../login_screen.dart';
import 'companyBottomAppBar.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  @override
  void initState() {
    if (mounted) {
      checkUserProfileStatus();
    }
    super.initState();
  }

  void _showDialog(BuildContext context, String text, bool noButtonShow) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text),
          actions: <Widget>[
            noButtonShow == true
                ? MaterialButton(
                    child: Text(
                      "Not Now",
                      style: TextStyle(color: AppColor.goldenColor),
                    ),
                    onPressed: () {
                      // Perform your action here
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  )
                : const Center(),
            noButtonShow == true
                ? MaterialButton(
                    child: Text(
                      "Ok",
                      style: TextStyle(color: AppColor.goldenColor),
                    ),
                    onPressed: () {
                      // Perform your action here
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => CompanyProfilePage()));

                      // Close the dialog
                    },
                  )
                : MaterialButton(
                    child: Text(
                      "Ok",
                      style: TextStyle(color: AppColor.goldenColor),
                    ),
                    onPressed: () {
                      // Perform your action here
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
          ],
        );
      },
    );
  }

  int? ProfileStatus;
  bool? isLoading = false;
  SharedPreferences? prefs;
  Future<void> checkUserProfileStatus() async {
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
        if (mounted) {
          var response = await http.get(
            Uri.parse('${Helper().get_api_urlold()}ComProfileStatus/$userId'),
          );

          if (response.statusCode == 200) {
            var getResponseData = jsonDecode(response.body);

            if (getResponseData['error'] == false ||
                getResponseData['error'] == "false") {
              if (getResponseData['status'] == 0 ||
                  getResponseData['status'] == '0') {
                prefs!.setInt("profileStatus", 0);
                ProfileStatus = 0;
                _showDialog(
                    context,
                    "Please wait until your profile will be approved by Admin",
                    false);
              } else if (getResponseData['status'] == 1 ||
                  getResponseData['status'] == '1') {
                prefs!.setInt("profileStatus", 1);
                ProfileStatus = 1;
              } else {
                _showDialog(
                    context, "Please complete your profile first!", true);
                prefs!.setInt("profileStatus", -1);
                ProfileStatus = -1;
              }

              setState(() {
                isLoading = false;
              });
            } else {
              prefs!.setInt("profileStatus", -1);
              setState(() {
                ProfileStatus = -1;
                isLoading = false;
              });
              _showDialog(context, "Please complete your profile first!", true);
            }
          } else {
            prefs!.setInt("profileStatus", -1);
            setState(() {
              ProfileStatus = -1;
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
          ProfileStatus = -1;
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Home",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                prefs = await SharedPreferences.getInstance();
                await prefs!.clear();
                ref.invalidate(bottomAppBarStateNotifer);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout))
        ],
        backgroundColor: AppColor.goldenColor,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.jpeg",
                  width: 260,
                ),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (ProfileStatus == 1) {
                              ref
                                  .read(bottomAppBarStateNotifer.notifier)
                                  .state = 0;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      const CompanyBottomNavigatorScreen()));
                            } else if (ProfileStatus == 0) {
                              _showDialog(
                                  context,
                                  "Please wait until your profile will be approved by Admin",
                                  false);
                            } else {
                              _showDialog(context,
                                  "Please complete your profile first!", true);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 140,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.goldenColor,
                                    offset: Offset(
                                        0, 0), // Horizontal and vertical offset
                                    blurRadius: 7, // Blur radius
                                    spreadRadius: 0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color:
                                        AppColor.goldenColor.withOpacity(0.8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/dashbaord.png",
                                  height: 80,
                                  fit: BoxFit.fitHeight,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "DashBoard",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (ProfileStatus == 1) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const CreateNewPostPage()));
                            } else if (ProfileStatus == 0) {
                              _showDialog(
                                  context,
                                  "Please wait until your profile will be approved by Admin",
                                  false);
                            } else {
                              _showDialog(context,
                                  "Please complete your profile first!", true);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 140,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.goldenColor,
                                    offset: Offset(
                                        0, 0), // Horizontal and vertical offset
                                    blurRadius: 7, // Blur radius
                                    spreadRadius: 0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color:
                                        AppColor.goldenColor.withOpacity(0.8))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/newpost.png",
                                  height: 80,
                                  fit: BoxFit.fitHeight,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "Poast a New Job",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: Image.asset(
                "assets/images/Layer1.png",
                height: 100,
                fit: BoxFit.cover,
              )),
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
              : const Center()
        ],
      ),
    );
  }
}
