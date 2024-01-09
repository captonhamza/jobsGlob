import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobs_global/Models/candidate_profile_model.dart';
import 'package:jobs_global/Screens/ProfileDetilsAllInformation/address_details_page.dart';
import 'package:jobs_global/Screens/ProfileDetilsAllInformation/badge_detail_page.dart';
import 'package:jobs_global/Screens/ProfileDetilsAllInformation/bank_details_page.dart';
import 'package:jobs_global/Screens/ProfileDetilsAllInformation/emergency_contact_page.dart';
import 'package:jobs_global/Screens/ProfileDetilsAllInformation/personal_details_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jobs_global/Utils/global.dart';
import 'dart:convert';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobs_global/Screens/AdminScreen/admin_screen.dart';
import 'package:jobs_global/Screens/bottom_navigator_screen.dart';
import 'package:jobs_global/Widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../DataBaseManagements/database.dart';
import '../DataBaseManagements/riverPodStateManagemnts.dart';
import '../Utils/helper.dart';
import 'dart:async';

import '../Widgets/custom_profile_view_deatils.dart';
import 'ProfileDetilsAllInformation/document_details_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  DatabaseHelper database = DatabaseHelper.instance;
  List<Map<String, dynamic>> matchDataUserLoginDeatils = [];

  @override
  void initState() {
    if (mounted) {
      checkIntlizedValue();
    }
    super.initState();
  }

  VideoPlayerController? _controller;
  bool _isVideoInitialized = false;
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> initializeVideoPlayer(String url) async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await _controller?.initialize();
    setState(() {
      _isVideoInitialized = true;
    });
  }

  int? ProfileStatus;
  checkIntlizedValue() async {
    prefs = await SharedPreferences.getInstance();
    ProfileStatus = prefs!.getInt("profileStatus");
    setState(() {});
    if (ProfileStatus == 0 || ProfileStatus == 1) {
      if (mounted) {
        getCandidiateProfileData();
      }
    }

    if (mounted) {
      getDataBaseRecord();
    }
  }

  bool personInfoValid = false;
  bool addressInfoValid = false;
  bool emergencyInfoValid = false;
  bool documentInfoValid = false;
  bool bankInfoValid = false;
  bool badgeInfoValid = false;

  getDataBaseRecord() async {
    matchDataUserLoginDeatils = await database.getData();

    if (matchDataUserLoginDeatils.isEmpty) {
    } else {
      personInfoValid =
          matchDataUserLoginDeatils[0]['personallInfoValid'] == "true"
              ? true
              : false;
      addressInfoValid =
          matchDataUserLoginDeatils[0]['addressInfoValid'] == "true"
              ? true
              : false;
      emergencyInfoValid =
          matchDataUserLoginDeatils[0]['emergencyInfoValid'] == "true"
              ? true
              : false;
      documentInfoValid =
          matchDataUserLoginDeatils[0]['documentInfoValid'] == "true"
              ? true
              : false;
      // bankInfoValid = matchDataUserLoginDeatils[0]['bankInfoValid'] == "true"
      //     ? true
      //     : false;
      badgeInfoValid = matchDataUserLoginDeatils[0]['badgeInfoValid'] == "true"
          ? true
          : false;
    }

    setState(() {});
  }

  bool? isLoading = false;
  CandidateProfileData? candidateProfileData = CandidateProfileData();

  SharedPreferences? prefs;
  Future<void> getCandidiateProfileData() async {
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
            Uri.parse('${Helper().get_api_urlold()}CanProfile/$userId'),
          );

          //  print(response.body);

          if (response.statusCode == 200) {
            var getResponseData = jsonDecode(response.body);

            CandidatePRofileModel? info =
                CandidatePRofileModel.fromJson(getResponseData);

            if (info.error == false || info.error == "false") {
              if (info.data != null) {
                candidateProfileData = info.data!;
                if (candidateProfileData!.filePortfolioVideo != null &&
                    candidateProfileData!.filePortfolioVideo!.isNotEmpty) {
                  initializeVideoPlayer(
                      candidateProfileData!.filePortfolioVideo.toString());
                }
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
    return SafeArea(
      child: ProfileStatus == 0 || ProfileStatus == 1
          ? Stack(
              children: [
                CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      snap: false,
                      pinned: true,
                      floating: false,

                      flexibleSpace: FlexibleSpaceBar(
                          title: const Text("Profile Detail",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ) //TextStyle
                              ), //Text
                          background:
                              candidateProfileData!.profilePic == null ||
                                      candidateProfileData!.profilePic!.isEmpty
                                  ? Icon(Icons.image)
                                  : Image.network(
                                      candidateProfileData!.profilePic!,
                                      fit: BoxFit.cover,
                                    ) //Images.network
                          ), //FlexibleSpaceBar
                      expandedHeight: 200,
                      backgroundColor: AppColor.goldenColor,

                      //<Widget>[]
                    ), //SliverAppBar
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 5, bottom: 8),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 20),
                                  ),
                                  Card(
                                    margin: const EdgeInsets.only(top: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomHeaderTitle("PERSONAL DETAIL"),
                                          CustomTitlewithData("First Name",
                                              candidateProfileData!.firstName),
                                          CustomTitlewithData("Last Name",
                                              candidateProfileData!.lastName),
                                          CustomTitlewithData("Category",
                                              candidateProfileData!.category),
                                          CustomTitlewithData(
                                              "Gender",
                                              candidateProfileData!.gender == 1
                                                  ? "Male"
                                                  : candidateProfileData!
                                                              .gender ==
                                                          2
                                                      ? "Female"
                                                      : "Other"),
                                          CustomTitlewithData("Birth Date",
                                              candidateProfileData!.birthDate),
                                          CustomTitlewithData("Email",
                                              candidateProfileData!.email),
                                          CustomTitlewithData("Phone",
                                              candidateProfileData!.phone),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _controller?.dispose();
                                          ProfileStatus = -1;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColor.goldenColor,
                                            shape: BoxShape.circle),
                                        height: 50,
                                        width: 50,
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Card(
                                margin: const EdgeInsets.only(top: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomHeaderTitle("ADDRESS DETAIL"),
                                      CustomTitlewithData("Address",
                                          candidateProfileData!.address),
                                      CustomTitlewithData("City",
                                          candidateProfileData!.birthCity),
                                      CustomTitlewithData("Country",
                                          candidateProfileData!.country),
                                      CustomTitlewithData("Post Code",
                                          candidateProfileData!.postCode),
                                      CustomTitlewithData(
                                          "Town", candidateProfileData!.town),
                                      CustomTitlewithData("Nationality",
                                          candidateProfileData!.nationality),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.only(top: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomHeaderTitle("EMERGENCY DETAIL"),
                                      CustomTitlewithData("Name",
                                          candidateProfileData!.eContactName),
                                      CustomTitlewithData(
                                          "Realtion",
                                          candidateProfileData!
                                              .eContactRelation),
                                      CustomTitlewithData("Phone",
                                          candidateProfileData!.eContactPhone),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.only(top: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomHeaderTitle("DOCUMENTS"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text("Passport"),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              candidateProfileData!
                                                              .passportPic ==
                                                          null ||
                                                      candidateProfileData!
                                                          .passportPic!.isEmpty
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: AppColor
                                                                  .goldenColor),
                                                          color: Colors
                                                              .grey.shade300,
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Icon(
                                                        Icons.person,
                                                        color: Colors
                                                            .grey.shade700,
                                                        size: 80,
                                                      ),
                                                    )
                                                  : ClipOval(
                                                      child: Image.network(
                                                        candidateProfileData!
                                                            .passportPic
                                                            .toString(),
                                                        fit: BoxFit.cover,
                                                        height: 110,
                                                        width: 110,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text("Utility"),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              candidateProfileData!
                                                              .utilitybillPic ==
                                                          null ||
                                                      candidateProfileData!
                                                          .utilitybillPic!
                                                          .isEmpty
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: AppColor
                                                                  .goldenColor),
                                                          color: Colors
                                                              .grey.shade300,
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Icon(
                                                        Icons.person,
                                                        color: Colors
                                                            .grey.shade700,
                                                        size: 80,
                                                      ),
                                                    )
                                                  : ClipOval(
                                                      child: Image.network(
                                                        candidateProfileData!
                                                            .utilitybillPic
                                                            .toString(),
                                                        fit: BoxFit.cover,
                                                        height: 110,
                                                        width: 110,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text("Resident"),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              candidateProfileData!
                                                              .residentPic ==
                                                          null ||
                                                      candidateProfileData!
                                                          .residentPic!.isEmpty
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: AppColor
                                                                  .goldenColor),
                                                          color: Colors
                                                              .grey.shade300,
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Icon(
                                                        Icons.person,
                                                        color: Colors
                                                            .grey.shade700,
                                                        size: 80,
                                                      ),
                                                    )
                                                  : ClipOval(
                                                      child: Image.network(
                                                        candidateProfileData!
                                                            .residentPic
                                                            .toString(),
                                                        fit: BoxFit.cover,
                                                        height: 110,
                                                        width: 110,
                                                      ),
                                                    ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text("Short Introduction"),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              candidateProfileData!
                                                          .filePortfolioVideo !=
                                                      null
                                                  ? _isVideoInitialized
                                                      ? Container(
                                                          width:
                                                              200, // Set width to 50
                                                          height:
                                                              100, // Set height to 50
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              AspectRatio(
                                                                aspectRatio:
                                                                    _controller!
                                                                            .value
                                                                            .aspectRatio *
                                                                        2,
                                                                child: VideoPlayer(
                                                                    _controller!),
                                                              ),
                                                              Positioned(
                                                                left: 0,
                                                                right: 0,
                                                                top: 0,
                                                                bottom: 0,
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    _controller!
                                                                            .value
                                                                            .isPlaying
                                                                        ? Icons
                                                                            .pause
                                                                        : Icons
                                                                            .play_arrow,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 50,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      if (_controller!
                                                                          .value
                                                                          .isPlaying) {
                                                                        _controller!
                                                                            .pause();
                                                                      } else {
                                                                        _controller!
                                                                            .play();
                                                                      }
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : CircularProgressIndicator(
                                                          color: AppColor
                                                              .goldenColor,
                                                        )
                                                  : Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: AppColor
                                                                  .goldenColor),
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Image.asset(
                                                        "assets/images/filenotfound.png",
                                                        height: 80,
                                                      )),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text("Resume"),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              candidateProfileData!.fileResume !=
                                                          null &&
                                                      candidateProfileData!
                                                          .fileResume!
                                                          .isNotEmpty
                                                  ? ClipOval(
                                                      child: InkWell(
                                                        onTap: () async {
                                                          openFile(
                                                              candidateProfileData!
                                                                  .fileResume
                                                                  .toString());
                                                        },
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: AppColor
                                                                        .goldenColor),
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: Image.asset(
                                                              "assets/images/pdf.png",
                                                              height: 80,
                                                            )),
                                                      ),
                                                    )
                                                  : Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: AppColor
                                                                  .goldenColor),
                                                          color: Colors
                                                              .grey.shade300,
                                                          shape:
                                                              BoxShape.circle),
                                                      child: Image.asset(
                                                        "assets/images/filenotfound.png",
                                                        height: 80,
                                                      )),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      CustomTitlewithData("Insurance No",
                                          candidateProfileData!.insuranceNo),
                                      CustomTitlewithData(
                                          "UTR No",
                                          candidateProfileData!.utrNumber
                                              .toString()),
                                      CustomTitlewithData(
                                          "UK Driving Licence",
                                          candidateProfileData!.ukDrivingLicence
                                              .toString()),
                                    ],
                                  ),
                                ),
                              ),
                              // Card(
                              //   margin: const EdgeInsets.only(top: 20),
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(8)),
                              //   elevation: 5,
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(8)),
                              //     width: double.infinity,
                              //     child: Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              //       children: [
                              //         CustomHeaderTitle("BANK DETAIL"),
                              //         CustomTitlewithData("Sort Code",
                              //             candidateProfileData!.bankSortCode),
                              //         CustomTitlewithData("Account No",
                              //             candidateProfileData!.accountNumber),
                              //         CustomTitlewithData("Name of Account",
                              //             candidateProfileData!.nameOfAccount),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              Card(
                                margin: const EdgeInsets.only(top: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomHeaderTitle("BADGE DETAIL"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          candidateProfileData!.badgePic ==
                                                      null ||
                                                  candidateProfileData!
                                                      .badgePic!.isEmpty
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: AppColor
                                                              .goldenColor),
                                                      color:
                                                          Colors.grey.shade300,
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.grey.shade700,
                                                    size: 80,
                                                  ),
                                                )
                                              : ClipOval(
                                                  child: Image.network(
                                                    candidateProfileData!
                                                        .badgePic
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    height: 110,
                                                    width: 110,
                                                  ),
                                                )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      CustomTitlewithData("Badge Type",
                                          candidateProfileData!.badgeType),
                                      CustomTitlewithData("Badge No",
                                          candidateProfileData!.badgeNumber),
                                      CustomTitlewithData("Expiry Date",
                                          candidateProfileData!.badgeExpiry),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        childCount: 1,
                      ), //SliverChildBuildDelegate
                    ) //SliverList
                  ], //<Widget>[]
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
                    : const Center(),
              ],
            )
          : //CustonScrollView

          Stack(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          InkWell(
                              onTap: () async {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => PersonDeatilsPage(
                                              candidateProfileData:
                                                  candidateProfileData,
                                            )))
                                    .then((value) async {
                                  await getDataBaseRecord();
                                });
                              },
                              child: CustomCardDesign(
                                  "Step 1", "Personal Deatils",
                                  validate: personInfoValid)),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                              onTap: () async {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => AddressDeatilsPage(
                                              candidateProfileData:
                                                  candidateProfileData,
                                            )))
                                    .then((value) async {
                                  await getDataBaseRecord();
                                });
                              },
                              child: CustomCardDesign(
                                  "Step 2", "Address Deatils",
                                  validate: addressInfoValid)),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                              onTap: () async {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => EmergencyContactPage(
                                              candidateProfileData:
                                                  candidateProfileData,
                                            )))
                                    .then((value) async {
                                  await getDataBaseRecord();
                                });
                              },
                              child: CustomCardDesign(
                                  "Step 3", "Emergency Contact Deatils",
                                  validate: emergencyInfoValid)),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                              onTap: () async {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => DocumentDetailPage(
                                              candidateProfileData:
                                                  candidateProfileData,
                                            )))
                                    .then((value) async {
                                  await getDataBaseRecord();
                                });
                              },
                              child: CustomCardDesign("Step 4", "Documents",
                                  validate: documentInfoValid)),
                          const SizedBox(
                            height: 5,
                          ),
                          // InkWell(
                          //     onTap: () async {
                          //       Navigator.of(context)
                          //           .push(MaterialPageRoute(
                          //               builder: (_) => BankDetailPage(
                          //                     candidateProfileData:
                          //                         candidateProfileData,
                          //                   )))
                          //           .then((value) async {
                          //         await getDataBaseRecord();
                          //       });
                          //     },
                          //     child: CustomCardDesign("Step 5", "Bank Deatil",
                          //         validate: bankInfoValid)),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          InkWell(
                              onTap: () async {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => BadgeDetailPage(
                                              candidateProfileData:
                                                  candidateProfileData,
                                            )))
                                    .then((value) async {
                                  await getDataBaseRecord();
                                });
                              },
                              child: CustomCardDesign("Step 5", "Badge Deatils",
                                  validate: badgeInfoValid)),
                          const SizedBox(
                            height: 18,
                          ),
                          CustomButton(
                              text: "Submit",
                              buttonHight: 48,
                              textSize: 20,
                              onPressed: () async {
                                if (personInfoValid &&
                                        addressInfoValid &&
                                        documentInfoValid &&
                                        emergencyInfoValid &&
                                        badgeInfoValid
                                    // &&
                                    // bankInfoValid

                                    ) {
                                  UploadProfileApi();
                                } else {
                                  final snackBar = SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppColor.goldenColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      content: const Text(
                                        "Please fill all requirements first!",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }),
                        ],
                      ),
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
                    : const Center(),
                Positioned(
                    right: 0,
                    top: 0,
                    child: Image.asset(
                      "assets/images/Layer1.png",
                      height: 100,
                      fit: BoxFit.cover,
                    )),
              ],
            ),
    );
  }

  Widget CustomCardDesign(String? title, String? name,
      {bool? validate = false}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: TextStyle(color: AppColor.goldenColor),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  name!,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            validate == true
                ? Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 16,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey.shade200),
                    child: const Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 16,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> UploadProfileApi() async {
    setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();
    int? userId = await prefs!.getInt("userID");
    final requestBody = {
      'status': '0',
      'uk_driving_licence':
          matchDataUserLoginDeatils[0]['uk_driving_licence'].toString() == "Yes"
              ? "1"
              : "2",
      'visa_required':
          matchDataUserLoginDeatils[0]['visaRewquired'].toString() == "Yes"
              ? "1"
              : "2",
      // 'name_of_account': matchDataUserLoginDeatils[0]['accountName'].toString(),
      // 'account_number': matchDataUserLoginDeatils[0]['accountNo'].toString(),
      // 'bank_sort_code': matchDataUserLoginDeatils[0]['sortCode'].toString(),

      'name_of_account': "".toString(),
      'account_number': "".toString(),
      'bank_sort_code': "".toString(),
      'e_contact_phone':
          matchDataUserLoginDeatils[0]['emergencyPhoneNo'].toString(),
      'e_contact_relation':
          matchDataUserLoginDeatils[0]['emergencyRealtion'].toString(),
      'e_contact_name':
          matchDataUserLoginDeatils[0]['emergencyName'].toString(),
      'nationality': matchDataUserLoginDeatils[0]['nationality'].toString(),
      'user_id': userId.toString(),
      'category_id':
          matchDataUserLoginDeatils[0]['personCategoryType'].toString(),
      'first_name': matchDataUserLoginDeatils[0]['personFirstName'].toString(),
      'last_name': matchDataUserLoginDeatils[0]['personLastName'].toString(),
      'gender':
          matchDataUserLoginDeatils[0]['personGenderType'].toString() == "Male"
              ? "1"
              : matchDataUserLoginDeatils[0]['personGenderType'].toString() ==
                      "Female"
                  ? "2"
                  : "3",
      'town': matchDataUserLoginDeatils[0]['town'].toString(),
      'country': matchDataUserLoginDeatils[0]['country'].toString(),
      'address': matchDataUserLoginDeatils[0]['address'].toString(),
      'post_code': matchDataUserLoginDeatils[0]['postCode'].toString(),
      'email': matchDataUserLoginDeatils[0]['personEmail'].toString(),
      'phone': matchDataUserLoginDeatils[0]['personPhoneNo'].toString(),
      'birth_date':
          matchDataUserLoginDeatils[0]['personDateOfBirth'].toString(),
      'birth_city': matchDataUserLoginDeatils[0]['city'].toString(),
      'badge_type': matchDataUserLoginDeatils[0]['badgeType'].toString(),
      'badge_expiry': matchDataUserLoginDeatils[0]['expiryDate'].toString(),
      'badge_number': matchDataUserLoginDeatils[0]['badgeNo'].toString(),
      'insurance_no': matchDataUserLoginDeatils[0]['insuranceNo'].toString(),
      'utr_number': matchDataUserLoginDeatils[0]['utrNo'].toString()
    };

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};

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
        var request = http.MultipartRequest(
            'POST', Uri.parse('${Helper().get_api_urlold()}UpdateEmpProfile'));

        // Add RequestBody parts
        requestBody.forEach((key, value) {
          request.fields[key] = value;
        });

        if (matchDataUserLoginDeatils[0]['personaProfileImage'] != null) {
          String? imageBytes =
              matchDataUserLoginDeatils[0]['personaProfileImage'];

          request.files.add(
            await http.MultipartFile.fromPath(
              'profile_pic',
              imageBytes!,
            ),
          );
        } else {
          request.fields['profile_pic'] = '';
        }

        if (matchDataUserLoginDeatils[0]['passportImage'] != null) {
          String? imageBytes = matchDataUserLoginDeatils[0]['passportImage'];

          request.files.add(
              await http.MultipartFile.fromPath('passport_pic', imageBytes!));
        } else {
          request.fields['passport_pic'] = '';
        }

        if (matchDataUserLoginDeatils[0]['UtilityImage'] != null) {
          String? imageBytes = matchDataUserLoginDeatils[0]['UtilityImage'];
          request.files.add(await http.MultipartFile.fromPath(
              'utilitybill_pic', imageBytes!));
        } else {
          request.fields['utilitybill_pic'] = '';
        }

        if (matchDataUserLoginDeatils[0]['ResidentImage'] != null) {
          String? imageBytes = matchDataUserLoginDeatils[0]['ResidentImage'];
          request.files.add(
              await http.MultipartFile.fromPath('resident_pic', imageBytes!));
        } else {
          request.fields['resident_pic'] = '';
        }
        if (matchDataUserLoginDeatils[0]['badgeImage'] != null) {
          String? imageBytes = matchDataUserLoginDeatils[0]['badgeImage'];
          request.files
              .add(await http.MultipartFile.fromPath('badge_pic', imageBytes!));
        } else {
          request.fields['badge_pic'] = '';
        }

        if (matchDataUserLoginDeatils[0]['resumeFile'] != null) {
          String? imageBytes = matchDataUserLoginDeatils[0]['resumeFile'];
          request.files.add(
              await http.MultipartFile.fromPath('file_resume', imageBytes!));
        } else {
          request.fields['file_resume'] = '';
        }

        if (matchDataUserLoginDeatils[0]['shortIntro'] != null) {
          String? imageBytes = await matchDataUserLoginDeatils[0]['shortIntro'];

          File file = new File(imageBytes!);
          if (file.existsSync()) {
            request.files.add(await http.MultipartFile.fromPath(
              'file_portfolio_video',
              file.path,
            ));
          } else {
            request.fields['file_portfolio_video'] = '';
          }
        }

        request.headers.addAll(headers);

        dynamic response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          print(responseBody);
          var getResponseData = jsonDecode(responseBody);

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
            int? value =
                await database.deleteData(matchDataUserLoginDeatils[0]['id']);
            if (value > 0) {
              ref.read(bottomAppBarStateNotifer.notifier).state = 0;
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

  void openFile(String fileUrl) async {
    try {
      await OpenFile.open(fileUrl);
    } catch (error) {
      print('Error opening file: $error');
    }
  }
}
