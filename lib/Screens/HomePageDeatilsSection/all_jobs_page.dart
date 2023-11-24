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

class AllJobsPage extends StatefulWidget {
  bool? isCategorySide;
  int? CategoryId;
  AllJobsPage({super.key, this.isCategorySide, this.CategoryId});

  @override
  State<AllJobsPage> createState() => _AllJobsPageState();
}

class _AllJobsPageState extends State<AllJobsPage> {
  @override
  void initState() {
    if (mounted) {
      getAllJobCategoryList();
    }
    super.initState();
  }

  SharedPreferences? prefs;
  @override
  void dispose() {
    super.dispose();
  }

  bool? isLoading = false;
  List<AllJobList> allJobList = [];

  Future<void> getAllJobCategoryList() async {
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
        var response = await http.get(
          widget.isCategorySide == true
              ? Uri.parse(
                  '${Helper().get_api_urlold()}CatJobs/${widget.CategoryId}/$userId')
              : Uri.parse('${Helper().get_api_urlold()}AllJobs/$userId'),
        );

        print(response.body);

        if (response.statusCode == 200) {
          var getResponseData = jsonDecode(response.body);

          GetAllJobsModel? info = GetAllJobsModel.fromJson(getResponseData);

          if (info.error == false || info.error == "false") {
            if (info.data != null) {
              allJobList = info.data!;
            }
            setState(() {
              isLoading = false;
            });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.goldenColor,
        title: const Text("All Jobs"),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            allJobList.length > 0
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: allJobList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => JobDetailsPage(
                                                allJobListObject:
                                                    allJobList[index])));
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    elevation: 3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: AppColor
                                                              .goldenColor)),
                                                  child:
                                                      const Icon(Icons.person)),
                                              const SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    allJobList[index].title!,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                    child: Text(
                                                        "${allJobList[index].startTime.toString()}-${allJobList[index].endTime.toString()}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                            color: Colors
                                                                .black54)),
                                                  ),
                                                  Text(
                                                    "${allJobList[index].city}(${allJobList[index].category})",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          allJobList[index].status! > 0
                                              ? Center()
                                              : InkWell(
                                                  onTap: () async {
                                                    prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    int? ProfileStatus = prefs!
                                                        .getInt(
                                                            "profileStatus");

                                                    if (ProfileStatus == 1) {
                                                      ApplyJobApi(
                                                          allJobList[index].id);
                                                    } else if (ProfileStatus ==
                                                        0) {
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
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 20,
                                                        vertical: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .purple.shade300,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3)),
                                                      child: Text(
                                                        "Apply",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  )
                : isLoading == false
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_off_outlined),
                            Text(
                              "No Data Found",
                              style: TextStyle(color: Colors.black87),
                            )
                          ],
                        ),
                      )
                    : const Center(),
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
      ),
    );
  }

  Future<void> ApplyJobApi(int? jobId) async {
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
          "job_id": jobId.toString(),
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
