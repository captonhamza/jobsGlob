import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jobs_global/Screens/HomePageDeatilsSection/apply_jobs_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DataBaseManagements/database.dart';
import '../DataBaseManagements/riverPodStateManagemnts.dart';
import '../Models/getAllCategoryModel.dart';
import '../Utils/global.dart';
import '../Utils/helper.dart';
import 'HomePageDeatilsSection/all_jobs_page.dart';
import 'package:jobs_global/Models/candidate_profile_model.dart';

import 'dart:async';
import 'dart:convert';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<AllCategoryData> getAllCategoryList = [];
  DatabaseHelper database = DatabaseHelper.instance;

  @override
  void initState() {
    getAllCategoryListFunction();

    super.initState();
  }

  getAllCategoryListFunction() async {
    getAllCategoryList = await database.allCategorygetData();
    if (mounted) {
      checkUserProfileStatus();
    }
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
                      Navigator.of(context).pop(); // Close the dialog
                      ref.read(bottomAppBarStateNotifer.notifier).state = 1;
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

  bool? isLoading = false;
  SharedPreferences? prefs;
  int? ProfileStatus;

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
            Uri.parse('${Helper().get_api_urlold()}CanProfileStatus/$userId'),
          );

          if (response.statusCode == 200) {
            var getResponseData = jsonDecode(response.body);

            setState(() {
              isLoading = false;
            });

            if (getResponseData['error'] == false ||
                getResponseData['error'] == "false") {
              if (getResponseData['status'] == 0 ||
                  getResponseData['status'] == '0') {
                prefs!.setInt("profileStatus", 0);

                setState(() {
                  ProfileStatus = 0;
                });
                _showDialog(
                    context,
                    "Please wait until your profile will be approved by Admin",
                    false);
              } else if (getResponseData['status'] == 1 ||
                  getResponseData['status'] == '1') {
                prefs!.setInt("profileStatus", 1);
                setState(() {
                  ProfileStatus = 1;
                  isLoading = false;
                });
              } else {
                _showDialog(
                    context, "Please complete your profile first!", true);
                prefs!.setInt("profileStatus", -1);
                setState(() {
                  isLoading = false;
                  ProfileStatus = -1;
                });
              }
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
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 0),
                  height: 160,
                  width: double.infinity,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: getAllCategoryList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AllJobsPage(
                                      isCategorySide: true,
                                      CategoryId: getAllCategoryList[index].id,
                                    )));
                          },
                          child: Card(
                            elevation: 0,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 24,
                                  right: index == getAllCategoryList.length - 1
                                      ? 24
                                      : 0),
                              width: 152,
                              height: 152,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.goldenColor,
                                      offset: const Offset(0,
                                          0), // Horizontal and vertical offset
                                      blurRadius: 7, // Blur radius
                                      spreadRadius: 0,
                                    ),
                                  ],
                                  border: Border.all(
                                      width: 1,
                                      color: AppColor.goldenColor
                                          .withOpacity(0.8))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/chair.png",
                                    height: 80,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    getAllCategoryList[index].name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AllJobsPage(
                                      isCategorySide: false,
                                    )));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 140,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.goldenColor,
                                    offset: const Offset(
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
                                  "assets/images/jobs.png",
                                  height: 80,
                                  fit: BoxFit.fitHeight,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "All Jobs",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const AllApplyJobsPage()));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 140,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.goldenColor,
                                    offset: const Offset(
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
                                  "assets/images/searchjob.png",
                                  height: 80,
                                  fit: BoxFit.fitHeight,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "Applied Jobs",
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
