import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobs_global/Models/candidate_profile_model.dart';
import 'package:jobs_global/Screens/AdminScreen/company_profile_page.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/companyProfileModel.dart';
import '../../Utils/helper.dart';
import '../../Widgets/custom_profile_view_deatils.dart';

class CompanyViewProfilePage extends StatefulWidget {
  const CompanyViewProfilePage({Key? key}) : super(key: key);

  @override
  State<CompanyViewProfilePage> createState() => _CompanyViewProfilePageState();
}

class _CompanyViewProfilePageState extends State<CompanyViewProfilePage> {
  @override
  void initState() {
    if (mounted) {
      checkIntlizedValue();
    }
    super.initState();
  }

  int? ProfileStatus;
  checkIntlizedValue() async {
    getCandidiateProfileData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  bool? isLoading = false;
  CompanyProfileData? candidateProfileData = CompanyProfileData();

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
            Uri.parse('${Helper().get_api_urlold()}ComProfile/$userId'),
          );

          //  print(response.body);

          if (response.statusCode == 200) {
            var getResponseData = jsonDecode(response.body);

            CompanyProfileModel? info =
                CompanyProfileModel.fromJson(getResponseData);

            if (info.error == false || info.error == "false") {
              if (info.data != null) {
                candidateProfileData = info.data!;
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
        child: Stack(
      children: [
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              snap: false,
              pinned: true,
              floating: false,

              flexibleSpace: FlexibleSpaceBar(
                  title: const Text("Profile Deatil",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ) //TextStyle
                      ), //Text
                  background: candidateProfileData!.companyLogo == null ||
                          candidateProfileData!.companyLogo!.isEmpty
                      ? Icon(Icons.image)
                      : Image.network(
                          candidateProfileData!.companyLogo!,
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
                                  borderRadius: BorderRadius.circular(8)),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: CustomTitlewithData("Name",
                                        candidateProfileData!.companyName),
                                  ),
                                  CustomTitlewithData(
                                      "Email", candidateProfileData!.mail),
                                  CustomTitlewithData(
                                      "Phone", candidateProfileData!.phone),
                                  CustomTitlewithData(
                                      "City", candidateProfileData!.city),
                                  CustomTitlewithData("Team Size",
                                      candidateProfileData!.teamSize),
                                  CustomTitlewithData(
                                      "Country", candidateProfileData!.country),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 0,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => CompanyProfilePage(
                                        candidateProfileData:
                                            candidateProfileData)));
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
    ));
  }
}
