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

import '../../Models/all_apply_jobs_model.dart';
import '../../Models/all_jobs_model.dart';
import '../../Utils/helper.dart';

class AllApplyJobsPage extends StatefulWidget {
  const AllApplyJobsPage({super.key});

  @override
  State<AllApplyJobsPage> createState() => _AllApplyJobsPageState();
}

class _AllApplyJobsPageState extends State<AllApplyJobsPage> {
  @override
  void initState() {
    if (mounted) {
      getAllJobapplyList();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool? isLoading = false;
  List<AllApplyJobList> allApplyJobList = [];

  SharedPreferences? prefs;

  Future<void> getAllJobapplyList() async {
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
          Uri.parse('${Helper().get_api_urlold()}AppliedJobs/$userId'),
        );

        //  print(response.body);

        if (response.statusCode == 200) {
          var getResponseData = jsonDecode(response.body);

          GetAllApplyJobsModel? info =
              GetAllApplyJobsModel.fromJson(getResponseData);

          if (info.error == false || info.error == "false") {
            if (info.data != null) {
              allApplyJobList = info.data!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.goldenColor,
        title: const Text("Applied Jobs"),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            allApplyJobList.length > 0
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
                              itemCount: allApplyJobList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => JobDetailsPage(
                                                isAppliedJobSide: true,
                                                allJobListObject: AllJobList(
                                                  title: allApplyJobList[index]
                                                      .title,
                                                  dateTime:
                                                      allApplyJobList[index]
                                                          .dateTime,
                                                  description:
                                                      allApplyJobList[index]
                                                          .description,
                                                  category:
                                                      allApplyJobList[index]
                                                          .category,
                                                  address:
                                                      allApplyJobList[index]
                                                          .address,
                                                  startTime:
                                                      allApplyJobList[index]
                                                          .startTime,
                                                  endTime:
                                                      allApplyJobList[index]
                                                          .endTime,
                                                  experience:
                                                      allApplyJobList[index]
                                                          .experience,
                                                  noOfPostions:
                                                      allApplyJobList[index]
                                                          .noOfPostions,
                                                ))));
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
                                                    allApplyJobList[index]
                                                        .title!,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                    child: Text(
                                                        "${allApplyJobList[index].startTime.toString()}-${allApplyJobList[index].endTime.toString()}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                            color: Colors
                                                                .black54)),
                                                  ),
                                                  Text(
                                                    "${allApplyJobList[index].city}(${allApplyJobList[index].category})",
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
                                          Container(
                                              // padding:
                                              //     const EdgeInsets.symmetric(
                                              //   horizontal: 20,
                                              //   vertical: 8,
                                              // ),
                                              // decoration: BoxDecoration(
                                              //     color: Colors.purple.shade300,
                                              //     borderRadius:
                                              //         BorderRadius.circular(3)),
                                              child:
                                                  Icon(Icons.access_time_sharp))
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
}
