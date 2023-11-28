import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:jobs_global/Widgets/custom_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../../DataBaseManagements/database.dart';
import '../../Models/candidate_profile_model.dart';
import '../../Utils/global.dart';
import '../../Widgets/custom_edtTextFeild.dart';

class DocumentDetailPage extends StatefulWidget {
  CandidateProfileData? candidateProfileData;
  DocumentDetailPage({super.key, this.candidateProfileData});

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  final nationInsuranceController = TextEditingController();
  final utrNoController = TextEditingController();

  File? passportImage, utilsBillImage, residentImage;

  String? passportImageUrl, utilsBillImageUrl, residentImageUrl;

  String? resumFiePath;
  String? resumFiePathUrl;

  String? introDuctionVideoUrl;
  File? introDuctionVideo;
  VideoPlayerController? _controller;
  final _formKey = GlobalKey<FormState>();
  String? selectedVisaRequired;
  String? selectedUkDrivingLicess;

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
      if (matchDataUserLoginDeatils[0]['passportImage'].toString() != "null") {
        passportImage = File(matchDataUserLoginDeatils[0]['passportImage']);
      }
      if (matchDataUserLoginDeatils[0]['UtilityImage'].toString() != "null") {
        utilsBillImage = File(matchDataUserLoginDeatils[0]['UtilityImage']);
      }
      if (matchDataUserLoginDeatils[0]['ResidentImage'].toString() != "null") {
        residentImage = File(matchDataUserLoginDeatils[0]['ResidentImage']);
      }

      nationInsuranceController.text =
          matchDataUserLoginDeatils[0]['insuranceNo'];
      utrNoController.text = matchDataUserLoginDeatils[0]['utrNo'];

      selectedVisaRequired = matchDataUserLoginDeatils[0]['visaRewquired'];
      selectedUkDrivingLicess =
          matchDataUserLoginDeatils[0]['uk_driving_licence'];

      introDuctionVideo = File(matchDataUserLoginDeatils[0]['shortIntro']);
      resumFiePath = matchDataUserLoginDeatils[0]['resumeFile'];

      print(selectedVisaRequired);
    }

    setState(() {});
  }

  getDataFromApi() async {
    matchDataUserLoginDeatils = await database.getData();
    passportImageUrl = widget.candidateProfileData!.passportPic ?? "";

    utilsBillImageUrl = widget.candidateProfileData!.utilitybillPic ?? "";

    residentImageUrl = widget.candidateProfileData!.residentPic ?? "";

    nationInsuranceController.text =
        widget.candidateProfileData!.insuranceNo ?? "";
    utrNoController.text = widget.candidateProfileData!.utrNumber ?? "";

    selectedVisaRequired = widget.candidateProfileData!.visaRequired == 1
        ? "Yes"
        : widget.candidateProfileData!.visaRequired == 2
            ? "No"
            : null;
    selectedUkDrivingLicess = widget.candidateProfileData!.ukDrivingLicence == 1
        ? "Yes"
        : widget.candidateProfileData!.ukDrivingLicence == 2
            ? "No"
            : null;

    introDuctionVideoUrl =
        widget.candidateProfileData!.filePortfolioVideo ?? "";
    resumFiePathUrl = widget.candidateProfileData!.fileResume ?? "";

    setState(() {});
  }

  Future<File> _getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    return File(image!.path);
  }

  Future<File> _getVideo(ImageSource source) async {
    final image = await ImagePicker()
        .pickVideo(source: source, maxDuration: Duration(seconds: 30));

    return File(image!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Document",
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
                    CustomTextFieldWidget(
                      controller: nationInsuranceController,
                      hintText: "National Insurance No ",
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextFieldWidget(
                      controller: utrNoController,
                      hintText: "UTR No",
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            width: 1,
                            color: AppColor.goldenColor,
                          )
                          // Background color of the dropdown
                          ),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Text("Visa Required"),
                          dropdownColor: AppColor.goldenColor,
                          value: selectedVisaRequired,
                          onChanged: (newValue) {
                            setState(() {
                              selectedVisaRequired = newValue!;
                            });
                          },
                          items: <String>[
                            'Yes',
                            'No',
                          ]
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: SizedBox(
                                    width: 100,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                          color: Colors.black,
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
                      height: 12,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            width: 1,
                            color: AppColor.goldenColor,
                          )
                          // Background color of the dropdown
                          ),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Text("Driving Licence"),
                          dropdownColor: AppColor.goldenColor,
                          value: selectedUkDrivingLicess,
                          onChanged: (newValue) {
                            setState(() {
                              selectedUkDrivingLicess = newValue!;
                            });
                          },
                          items: <String>[
                            'Yes',
                            'No',
                          ]
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: SizedBox(
                                    width: 100,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 5),
                      child: Row(
                        children: [
                          Text("UPLOAD RESUME*"),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 45,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: AppColor.goldenColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              // final PermissionStatus status =
                              //     await Permission.storage.status;
                              // if (status.isGranted) {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                    'pdf',
                                    'doc',
                                    'docx',
                                    'txt'
                                  ]);

                              if (result != null) {
                                final double fileSizeInMB =
                                    result.files.first.size /
                                        (1024 * 1024); // Convert to MB

                                if (fileSizeInMB > 1.0) {
                                  final snackBar = SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppColor.goldenColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      content: const Text(
                                        "File Size Too Large Please Select File Less Than 1 MB",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  PlatformFile file = result.files.first;
                                  setState(() {
                                    resumFiePathUrl = "";
                                    resumFiePath = file.path;
                                  });
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(3)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: const Text(
                                "Choose File",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          resumFiePath == null ||
                                  resumFiePath!.isEmpty &&
                                      resumFiePathUrl!.isEmpty
                              ? const Center()
                              : resumFiePathUrl!.isEmpty
                                  ? Text(
                                      resumFiePath!.toString().split('/').last,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Expanded(
                                      child: Text(
                                        resumFiePathUrl!
                                            .toString()
                                            .split('/')
                                            .last,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 5),
                      child: Row(
                        children: [
                          Text("UPLOAD SHORT INTRODUCTION*"),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 45,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: AppColor.goldenColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    titlePadding:
                                        const EdgeInsets.only(bottom: 5),
                                    title: Container(
                                        constraints: const BoxConstraints(
                                            maxWidth: 300.0),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        alignment: Alignment.center,
                                        color: AppColor.goldenColor,
                                        child: const Text(
                                          "Select Video Type",
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
                                                  await Permission
                                                      .camera.status;
                                              if (status.isGranted) {
                                                var pickImage = await _getVideo(
                                                    ImageSource.camera);
                                                if (pickImage != null) {
                                                  setState(() {
                                                    introDuctionVideoUrl = "";
                                                    introDuctionVideo =
                                                        pickImage;
                                                  });
                                                }
                                              } else if (status.isDenied) {
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statuses = await [
                                                  Permission.storage,
                                                  Permission.camera,
                                                  Permission.photos,
                                                ].request();
                                              } else {
                                                final snackBar = SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        AppColor.goldenColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
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
                                                      .manageExternalStorage
                                                      .status;
                                              if (status.isGranted) {
                                              } else if (status.isDenied) {
                                                var pickImage = await _getVideo(
                                                    ImageSource.gallery);
                                                if (pickImage != null) {
                                                  setState(() {
                                                    introDuctionVideoUrl = "";
                                                    introDuctionVideo =
                                                        pickImage;
                                                  });
                                                }
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statuses = await [
                                                  Permission.storage,
                                                  Permission.camera,
                                                  Permission.photos,
                                                ].request();
                                              } else {
                                                final snackBar = SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        AppColor.goldenColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
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
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(3)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: const Text(
                                "Choose File",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          introDuctionVideo == null &&
                                  introDuctionVideoUrl.toString().isEmpty
                              ? Center()
                              : introDuctionVideoUrl!.isEmpty
                                  ? Expanded(
                                      child: Text(
                                        introDuctionVideo
                                            .toString()
                                            .split('/')
                                            .last,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : Expanded(
                                      child: Text(
                                      introDuctionVideoUrl
                                          .toString()
                                          .split('/')
                                          .last,
                                      overflow: TextOverflow.ellipsis,
                                    ))

                          // _controller != null
                          //     ? Center(
                          //         child: _controller!.value.isInitialized
                          //             ? AspectRatio(
                          //                 aspectRatio:
                          //                     _controller!.value.aspectRatio,
                          //                 child: VideoPlayer(_controller!),
                          //               )
                          //             : Container(),
                          //       )
                          //     : Center(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 5),
                      child: Row(
                        children: [
                          Text("PHOTO OF PASSPORT OR DRIVING LICENCE"),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 45,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: AppColor.goldenColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    titlePadding:
                                        const EdgeInsets.only(bottom: 5),
                                    title: Container(
                                        constraints: const BoxConstraints(
                                            maxWidth: 300.0),
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
                                                  await Permission
                                                      .camera.status;
                                              if (status.isGranted) {
                                                var pickImage = await _getImage(
                                                    ImageSource.camera);
                                                if (pickImage != null) {
                                                  setState(() {
                                                    passportImageUrl = "";
                                                    passportImage = pickImage;
                                                  });
                                                }
                                              } else if (status.isDenied) {
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statuses = await [
                                                  Permission.storage,
                                                  Permission.camera,
                                                  Permission.photos,
                                                ].request();
                                              } else {
                                                final snackBar = SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        AppColor.goldenColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
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
                                                      .manageExternalStorage
                                                      .status;
                                              if (status.isGranted) {
                                              } else if (status.isDenied) {
                                                var pickImage = await _getImage(
                                                    ImageSource.gallery);
                                                if (pickImage != null) {
                                                  setState(() {
                                                    passportImageUrl = "";
                                                    passportImage = pickImage;
                                                  });
                                                }
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statuses = await [
                                                  Permission.storage,
                                                  Permission.camera,
                                                  Permission.photos,
                                                ].request();
                                              } else {
                                                final snackBar = SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        AppColor.goldenColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
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
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(3)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: const Text(
                                "Choose File",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                          passportImage == null && passportImageUrl!.isEmpty
                              ? const Center()
                              : passportImageUrl!.isEmpty
                                  ? Image.file(
                                      passportImage!,
                                      width: 100,
                                    )
                                  : Image.network(
                                      passportImageUrl!,
                                      width: 100,
                                    )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                                "PHOTO OF RECENT UNTILITY BILL OR BANK STATMENT"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 45,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: AppColor.goldenColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    titlePadding:
                                        const EdgeInsets.only(bottom: 5),
                                    title: Container(
                                        constraints: const BoxConstraints(
                                            maxWidth: 300.0),
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
                                                  await Permission
                                                      .camera.status;
                                              if (status.isGranted) {
                                                var pickImage = await _getImage(
                                                    ImageSource.camera);
                                                if (pickImage != null) {
                                                  setState(() {
                                                    utilsBillImageUrl = "";
                                                    utilsBillImage = pickImage;
                                                  });
                                                }
                                              } else if (status.isDenied) {
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statuses = await [
                                                  Permission.storage,
                                                  Permission.camera,
                                                  Permission.photos,
                                                ].request();
                                              } else {
                                                final snackBar = SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        AppColor.goldenColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
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
                                                      .manageExternalStorage
                                                      .status;
                                              if (status.isGranted) {
                                              } else if (status.isDenied) {
                                                var pickImage = await _getImage(
                                                    ImageSource.gallery);
                                                if (pickImage != null) {
                                                  setState(() {
                                                    utilsBillImageUrl = "";
                                                    utilsBillImage = pickImage;
                                                  });
                                                }
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statuses = await [
                                                  Permission.storage,
                                                  Permission.camera,
                                                  Permission.photos,
                                                ].request();
                                              } else {
                                                final snackBar = SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        AppColor.goldenColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
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
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(3)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: const Text(
                                "Choose File",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                          utilsBillImage == null && utilsBillImageUrl!.isEmpty
                              ? const Center()
                              : utilsBillImageUrl!.isEmpty
                                  ? Image.file(
                                      utilsBillImage!,
                                      width: 100,
                                    )
                                  : Image.network(
                                      utilsBillImageUrl!,
                                      width: 100,
                                    )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 5),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                  "PHOTO OF RESIDENT  (IF NOT UK CITIZEN)")),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 45,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: AppColor.goldenColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    titlePadding:
                                        const EdgeInsets.only(bottom: 5),
                                    title: Container(
                                        constraints: const BoxConstraints(
                                            maxWidth: 300.0),
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
                                                  await Permission
                                                      .camera.status;
                                              if (status.isGranted) {
                                                var pickImage = await _getImage(
                                                    ImageSource.camera);
                                                if (pickImage != null) {
                                                  setState(() {
                                                    residentImageUrl = "";
                                                    residentImage = pickImage;
                                                  });
                                                }
                                              } else if (status.isDenied) {
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statuses = await [
                                                  Permission.storage,
                                                  Permission.camera,
                                                  Permission.photos,
                                                ].request();
                                              } else {
                                                final snackBar = SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        AppColor.goldenColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
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
                                                      .manageExternalStorage
                                                      .status;
                                              if (status.isGranted) {
                                              } else if (status.isDenied) {
                                                var pickImage = await _getImage(
                                                    ImageSource.gallery);
                                                if (pickImage != null) {
                                                  setState(() {
                                                    residentImageUrl = "";
                                                    residentImage = pickImage;
                                                  });
                                                }
                                                Map<Permission,
                                                        PermissionStatus>
                                                    statuses = await [
                                                  Permission.storage,
                                                  Permission.camera,
                                                  Permission.photos,
                                                ].request();
                                              } else {
                                                final snackBar = SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        AppColor.goldenColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
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
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(3)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: const Text(
                                "Choose File",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                          residentImage == null && residentImageUrl!.isEmpty
                              ? const Center()
                              : residentImageUrl!.isEmpty
                                  ? Image.file(
                                      residentImage!,
                                      width: 100,
                                    )
                                  : Image.network(
                                      residentImageUrl!,
                                      width: 100,
                                    )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      text: "Done",
                      onPressed: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (selectedVisaRequired == null) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Select visaRequired!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          Map<String, dynamic> PersonDetails = {
                            "uk_driving_licence": selectedUkDrivingLicess,
                            "resumeFile": resumFiePath,
                            "passportImage": passportImage?.path,
                            "shortIntro": introDuctionVideo?.path,
                            "UtilityImage": utilsBillImage?.path,
                            "ResidentImage": residentImage?.path,
                            "insuranceNo":
                                nationInsuranceController.text.trim(),
                            "utrNo": utrNoController.text.trim(),
                            "visaRewquired": selectedVisaRequired,
                            "documentInfoValid": "true",
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
