import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jobs_global/Widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../DataBaseManagements/database.dart';
import '../../Models/candidate_profile_model.dart';
import '../../Models/getAllCategoryModel.dart';
import '../../Utils/global.dart';
import '../../Widgets/custom_edtTextFeild.dart';

class PersonDeatilsPage extends StatefulWidget {
  CandidateProfileData? candidateProfileData;
  PersonDeatilsPage({super.key, this.candidateProfileData});

  @override
  State<PersonDeatilsPage> createState() => _PersonDeatilsPageState();
}

class _PersonDeatilsPageState extends State<PersonDeatilsPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneContoller = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      // Format the selected date as "d-M-yyyy"
      final formattedDate = DateFormat('d-M-yyyy').format(picked);
      dateOfBirthController.text = formattedDate;
    }
  }

  AllCategoryData? selectedJobTitle;
  String? selectedGenderType;

  File? profileImage = null;
  List<AllCategoryData> getAllCategoryList = [];
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
    getAllCategoryList = await database.allCategorygetData();
    if (matchDataUserLoginDeatils.isNotEmpty) {
      if (matchDataUserLoginDeatils[0]['personaProfileImage'].toString() !=
          "null") {
        profileImage =
            File(matchDataUserLoginDeatils[0]['personaProfileImage']);
      }
      firstNameController.text =
          matchDataUserLoginDeatils[0]['personFirstName'] ?? "";
      lastNameController.text =
          matchDataUserLoginDeatils[0]['personLastName'] ?? "";

      selectedGenderType =
          matchDataUserLoginDeatils[0]['personGenderType'] ?? "";

      getAllCategoryList.forEach((element) {
        if (element.id.toString() ==
            matchDataUserLoginDeatils[0]['personCategoryType'].toString()) {
          selectedJobTitle = element;
        }
      });
      print(selectedJobTitle);

      dateOfBirthController.text =
          matchDataUserLoginDeatils[0]['personDateOfBirth'] ?? "";

      emailController.text = matchDataUserLoginDeatils[0]['personEmail'] ?? "";
      phoneContoller.text = matchDataUserLoginDeatils[0]['personPhoneNo'] ?? "";
    }

    setState(() {});
  }

  String? ProfileImageUrl = "";

  getDataFromApi() async {
    matchDataUserLoginDeatils = await database.getData();
    getAllCategoryList = await database.allCategorygetData();

    ProfileImageUrl = widget.candidateProfileData!.profilePic ?? "";

    firstNameController.text = widget.candidateProfileData!.firstName ?? "";
    lastNameController.text = widget.candidateProfileData!.lastName ?? "";

    selectedGenderType = widget.candidateProfileData!.gender == 1
        ? "Male"
        : widget.candidateProfileData!.gender == 2
            ? "Female"
            : widget.candidateProfileData!.gender == 3
                ? "Other"
                : null;

    getAllCategoryList.forEach((element) {
      if (element.name.toString() ==
          widget.candidateProfileData!.category.toString()) {
        selectedJobTitle = element;
      }
    });

    dateOfBirthController.text = widget.candidateProfileData!.birthDate ?? "";

    emailController.text = widget.candidateProfileData!.email ?? "";
    phoneContoller.text = widget.candidateProfileData!.phone ?? "";

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
            "Personal Deatils",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: AppColor.goldenColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // InkWell(
                                    //   onTap: () async {
                                    //     Navigator.pop(context);
                                    //     final PermissionStatus status =
                                    //         await Permission.camera.status;
                                    //     if (status.isGranted) {
                                    //       var pickImage = await _getImage(
                                    //           ImageSource.camera);
                                    //       if (pickImage != null) {
                                    //         setState(() {
                                    //           ProfileImageUrl = "";
                                    //           profileImage = pickImage;
                                    //         });
                                    //       }
                                    //     } else if (status.isDenied) {
                                    //       Map<Permission, PermissionStatus>
                                    //           statuses = await [
                                    //         Permission.storage,
                                    //         Permission.camera,
                                    //         Permission.photos,
                                    //       ].request();
                                    //     } else {
                                    //       final snackBar = SnackBar(
                                    //           behavior:
                                    //               SnackBarBehavior.floating,
                                    //           backgroundColor:
                                    //               AppColor.goldenColor,
                                    //           padding:
                                    //               const EdgeInsets.symmetric(
                                    //                   horizontal: 10,
                                    //                   vertical: 10),
                                    //           content: const Text(
                                    //             "Please Allow Camera Permssion!",
                                    //             style: TextStyle(
                                    //               color: Colors.black,
                                    //               fontWeight: FontWeight.normal,
                                    //             ),
                                    //           ));
                                    //       ScaffoldMessenger.of(context)
                                    //           .showSnackBar(snackBar);
                                    //     }
                                    //   },
                                    //   child: const Row(
                                    //     children: [
                                    //       Icon(Icons.camera_alt),
                                    //       SizedBox(
                                    //         width: 15,
                                    //       ),
                                    //       Text("Camera"),
                                    //     ],
                                    //   ),
                                    // ),

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
                                              ProfileImageUrl = "";
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
                                                  fontWeight: FontWeight.normal,
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
                      child: profileImage == null && ProfileImageUrl!.isEmpty
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
                          : ProfileImageUrl!.isEmpty
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
                                    ProfileImageUrl!,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                  const SizedBox(
                    height: 16,
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
                      child: DropdownButton<AllCategoryData>(
                        hint: const Text("Select Job"),
                        dropdownColor: AppColor.goldenColor,
                        value: selectedJobTitle,
                        onChanged: (AllCategoryData? newValue) {
                          setState(() {
                            selectedJobTitle = newValue;
                          });
                        },
                        items: getAllCategoryList
                            .map<DropdownMenuItem<AllCategoryData>>(
                              (AllCategoryData value) =>
                                  DropdownMenuItem<AllCategoryData>(
                                value: value,
                                child: SizedBox(
                                  width: 100,
                                  child: Text(
                                    value.name!,
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
                  CustomTextFieldWidget(
                    controller: firstNameController,
                    hintText: "First Name",
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextFieldWidget(
                    controller: lastNameController,
                    hintText: "Last Name",
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
                        hint: const Text("Select Gender"),
                        dropdownColor: AppColor.goldenColor,
                        value: selectedGenderType,
                        onChanged: (newValue) {
                          setState(() {
                            selectedGenderType = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female', 'Other']
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
                      if (datePicked != null && datePicked != DateTime.now()) {
                        // Format the selected date as "d-M-yyyy"
                        final formattedDate =
                            DateFormat('d-M-yyyy').format(datePicked);
                        dateOfBirthController.text = formattedDate;
                      }
                    },
                    readOnly: true,
                    controller: dateOfBirthController,
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
                  CustomTextFieldWidget(
                    controller: emailController,
                    hintText: "Email",
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextFieldWidget(
                    controller: phoneContoller,
                    hintText: "Phone",
                    inputType: TextInputType.phone,
                  ),
                  SizedBox(height: 12),
                  CustomButton(
                    text: "Done",
                    onPressed: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      if (selectedJobTitle == null) {
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColor.goldenColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            content: const Text(
                              "Please Seclect Job Title!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (firstNameController.text.isEmpty) {
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColor.goldenColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            content: const Text(
                              "Please Enter First Name!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (lastNameController.text.isEmpty) {
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColor.goldenColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            content: const Text(
                              "Please Enter Last Name!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (selectedGenderType == null) {
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColor.goldenColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            content: const Text(
                              "Please Select Gender!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (dateOfBirthController.text.isEmpty) {
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColor.goldenColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            content: const Text(
                              "Please Enter Date Of Birth!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (emailController.text.isEmpty) {
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColor.goldenColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            content: const Text(
                              "Please Enter Email!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (phoneContoller.text.isEmpty) {
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColor.goldenColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            content: const Text(
                              "Please Enter Phone!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        // List<int>? imageBytes;
                        // if (profileImage != null) {
                        //   imageBytes = profileImage?.readAsBytesSync();
                        // }
                        Map<String, dynamic> PersonDetails = {
                          "personaProfileImage": profileImage?.path.toString(),
                          "personFirstName": firstNameController.text.trim(),
                          "personLastName": lastNameController.text.trim(),
                          "personCategoryType": selectedJobTitle!.id,
                          "personGenderType": selectedGenderType,
                          "personDateOfBirth":
                              dateOfBirthController.text.trim(),
                          "personEmail": emailController.text.trim(),
                          "personPhoneNo": phoneContoller.text.trim(),
                          "personallInfoValid": "true",
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
    );
  }
}
