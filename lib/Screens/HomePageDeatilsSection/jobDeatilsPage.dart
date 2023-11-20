import 'package:flutter/material.dart';

import 'package:jobs_global/Widgets/custom_button.dart';
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

import '../../Models/all_jobs_model.dart';
import '../../Utils/global.dart';
import '../../Utils/helper.dart';

class JobDetailsPage extends StatefulWidget {
  AllJobList? allJobListObject;
  bool? isCompanySide;
  bool? isAppliedJobSide;

  JobDetailsPage({
    super.key,
    this.allJobListObject,
    this.isCompanySide,
    this.isAppliedJobSide,
  });

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  void _showDialog(BuildContext context, String text, bool noButtonShow) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text),
          actions: <Widget>[
            MaterialButton(
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.goldenColor,
            title: const Text("Jobs Deatil"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.allJobListObject!.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.allJobListObject!.category!,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 22,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.black38,
                            ),
                            Expanded(
                              child: Text(
                                widget.allJobListObject!.address!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            // Text(
                            //   widget.allJobListObject!.city!,
                            //   style: GoogleFonts.roboto(
                            //     fontWeight: FontWeight.w400,
                            //     fontSize: 14,
                            //   ),
                            // ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 135,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.pink.shade50,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/jobs.png",
                                        height: 80,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${widget.allJobListObject!.startTime.toString()}\n${widget.allJobListObject!.endTime.toString()}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 135,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.yellow.shade50,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/date.png",
                                        height: 80,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${widget.allJobListObject!.dateTime.toString()}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 135,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/experience.png",
                                        height: 80,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "${widget.allJobListObject!.experience} - Years",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                widget.allJobListObject!.description.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ))
                            ],
                          ),
                        ),
                        widget.isCompanySide == true
                            ? CustomButton(
                                text: "Close",
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            : widget.isAppliedJobSide == true
                                ? CustomButton(
                                    text: "Close",
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                : CustomButton(
                                    text: "Apply",
                                    onPressed: () async {
                                      prefs =
                                          await SharedPreferences.getInstance();
                                      int? ProfileStatus =
                                          prefs!.getInt("profileStatus");

                                      if (ProfileStatus == 1) {
                                        ApplyJobApi();
                                      } else if (ProfileStatus == 0) {
                                        _showDialog(
                                            context,
                                            "Please wait until your profile will be approved by Admin",
                                            false);
                                      } else {
                                        _showDialog(
                                            context,
                                            "Please complete your profile first!",
                                            false);
                                      }
                                    },
                                  ),
                      ],
                    ),
                  ),
                ),
              ],
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
            : const Center()
      ],
    );
  }

  Future<void> ApplyJobApi() async {
    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    int? userId = prefs!.getInt("userID");
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
            .post(Uri.parse('${Helper().get_api_urlold()}ApplyJob'), body: {
          "user_id": userId.toString(),
          "job_id": widget.allJobListObject!.id.toString(),
          "short_list": "0",
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

            Navigator.pop(context);
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
}
