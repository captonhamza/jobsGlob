import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:jobs_global/Widgets/custom_button.dart';

import '../../DataBaseManagements/database.dart';
import '../../Models/candidate_profile_model.dart';
import '../../Utils/global.dart';
import '../../Widgets/custom_edtTextFeild.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class BadgeDetailPage extends StatefulWidget {
  CandidateProfileData? candidateProfileData;
  BadgeDetailPage({super.key, this.candidateProfileData});

  @override
  State<BadgeDetailPage> createState() => _BadgeDetailPageState();
}

class _BadgeDetailPageState extends State<BadgeDetailPage> {
  final badgeTypeController = TextEditingController();
  final badgeNumberController = TextEditingController();
  final expiryDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? profileImage = null;
  List<Map<String, dynamic>> matchDataUserLoginDeatils = [];
  DatabaseHelper database = DatabaseHelper.instance;
  @override
  void initState() {
    if (widget.candidateProfileData != null) {
      getDataFromApi();
    } else {
      getDataBaseRecord();
    }
    super.initState();
  }

  getDataBaseRecord() async {
    matchDataUserLoginDeatils = await database.getData();

    if (matchDataUserLoginDeatils.isNotEmpty) {
      if (matchDataUserLoginDeatils[0]['badgeImage'].toString() != "null") {
        profileImage = File(matchDataUserLoginDeatils[0]['badgeImage']);
      }
      badgeTypeController.text = matchDataUserLoginDeatils[0]['badgeType'];
      badgeNumberController.text = matchDataUserLoginDeatils[0]['badgeNo'];

      expiryDateController.text = matchDataUserLoginDeatils[0]['expiryDate'];
    }

    setState(() {});
  }

  String? badgeImageUrl = "";
  getDataFromApi() async {
    matchDataUserLoginDeatils = await database.getData();
    badgeImageUrl = widget.candidateProfileData!.badgePic ?? "";

    badgeTypeController.text = widget.candidateProfileData!.badgeType ?? "";
    badgeNumberController.text = widget.candidateProfileData!.badgeNumber ?? "";

    expiryDateController.text = widget.candidateProfileData!.badgeExpiry ?? "";

    setState(() {});
  }

  Future<File> _getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    return File(image!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Badge Deatil",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: AppColor.goldenColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: AppColor.goldenColor,
                                contentPadding: EdgeInsets.zero,
                                titlePadding: const EdgeInsets.only(bottom: 5),
                                title: Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 300.0),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    alignment: Alignment.center,
                                    color: AppColor.goldenColor,
                                    child: const Text(
                                      "Select Image",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                content: Container(
                                  height: 140,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  color: Colors.white,
                                  constraints:
                                      const BoxConstraints(maxWidth: 300.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final PermissionStatus status =
                                              await Permission.camera.status;
                                          if (status.isGranted) {
                                            var pickImage = await _getImage(
                                                ImageSource.camera);
                                            if (pickImage != null) {
                                              setState(() {
                                                badgeImageUrl = "";
                                                profileImage = pickImage;
                                              });
                                            }
                                          } else if (status.isDenied) {
                                            Map<Permission, PermissionStatus>
                                                statuses = await [
                                              Permission.storage,
                                              Permission.camera,
                                              Permission.photos,
                                            ].request();
                                          } else {
                                            final snackBar = SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    AppColor.goldenColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                content: const Text(
                                                  "Please Allow Camera Permssion!",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(Icons.camera_alt),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text("Camera"),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final PermissionStatus status =
                                              await Permission
                                                  .manageExternalStorage.status;
                                          if (status.isGranted) {
                                          } else if (status.isDenied) {
                                            var pickImage = await _getImage(
                                                ImageSource.gallery);
                                            if (pickImage != null) {
                                              setState(() {
                                                badgeImageUrl = "";
                                                profileImage = pickImage;
                                              });
                                            }
                                            Map<Permission, PermissionStatus>
                                                statuses = await [
                                              Permission.storage,
                                              Permission.camera,
                                              Permission.photos,
                                            ].request();
                                          } else {
                                            final snackBar = SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    AppColor.goldenColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                content: const Text(
                                                  "Please Allow Gallery Permssion!",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(Icons.image),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text("Gallery"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: profileImage == null && badgeImageUrl!.isEmpty
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: AppColor.goldenColor),
                                    color: Colors.grey.shade300,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade700,
                                  size: 100,
                                ),
                              )
                            : badgeImageUrl!.isEmpty
                                ? ClipOval(
                                    child: Image.file(
                                      profileImage!,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.network(
                                      badgeImageUrl!,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                    const SizedBox(
                      height: 16,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextFieldWidget(
                      controller: badgeTypeController,
                      hintText: "Badge Type",
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextFieldWidget(
                      controller: badgeNumberController,
                      hintText: "Badge Number",
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      onTap: () async {
                        var datePicked = await DatePicker.showSimpleDatePicker(
                            context,
                            backgroundColor: Colors.white,
                            pickerMode: DateTimePickerMode.datetime,
                            titleText: "",
                            initialDate: DateTime(1990),
                            lastDate: DateTime(2090),
                            dateFormat: "dd-MMMM-yyyy",
                            looping: true,
                            textColor: Colors.black);
                        if (datePicked != null &&
                            datePicked != DateTime.now()) {
                          // Format the selected date as "d-M-yyyy"
                          final formattedDate =
                              DateFormat('d-M-yyyy').format(datePicked);
                          expiryDateController.text = formattedDate;
                        }
                      },
                      readOnly: true,
                      controller: expiryDateController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 15),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: AppColor.goldenColor)),
                          hintText: "Date of Birth",
                          hintStyle: const TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.normal),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: AppColor.goldenColor))),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomButton(
                      text: "Done",
                      onPressed: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (badgeTypeController.text.isEmpty) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Enter Badge Type!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (badgeNumberController.text.isEmpty) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Enter Badge Number!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (expiryDateController.text.isEmpty) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Enter Date of Birth",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          Map<String, dynamic> PersonDetails = {
                            "badgeImage": profileImage?.path,
                            "badgeType": badgeTypeController.text.trim(),
                            "badgeNo": badgeNumberController.text.trim(),
                            "expiryDate": expiryDateController.text.toString(),
                            "badgeInfoValid": "true",
                          };

                          if (matchDataUserLoginDeatils.isEmpty) {
                            int id = await database.saveData(PersonDetails);
                            if (id > 0) {
                              Navigator.pop(context);
                            }
                          } else {
                            int id = await database.updateData(
                                matchDataUserLoginDeatils[0]['id'],
                                PersonDetails);
                            if (id > 0) {
                              Navigator.pop(context);
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
