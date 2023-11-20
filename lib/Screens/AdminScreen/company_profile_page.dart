import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobs_global/Widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobs_global/Utils/global.dart';
import 'dart:convert';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jobs_global/Screens/AdminScreen/admin_screen.dart';
import 'package:jobs_global/Screens/bottom_navigator_screen.dart';
import 'package:jobs_global/Widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../DataBaseManagements/riverPodStateManagemnts.dart';
import '../../Models/cityModel.dart';
import '../../Models/companyProfileModel.dart';
import '../../Models/countryModel.dart';
import '../../Utils/all_city_static_file.dart';
import '../../Utils/all_country_static_file.dart';
import '../../Utils/global.dart';
import '../../Utils/helper.dart';
import '../../Widgets/custom_edtTextFeild.dart';

class CompanyProfilePage extends ConsumerStatefulWidget {
  CompanyProfileData? candidateProfileData;
  CompanyProfilePage({super.key, this.candidateProfileData});

  @override
  ConsumerState<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends ConsumerState<CompanyProfilePage> {
  final companyNameController = TextEditingController();
  final companyEmailController = TextEditingController();
  final companyPhoneController = TextEditingController();
  final companyregisterNoContoller = TextEditingController();
  final companyWebisteController = TextEditingController();
  final companyaddressController = TextEditingController();
  final companyteamSizeController = TextEditingController();
  final companyAboutNoContoller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Uint8List? Profilebytes = null;
  File? profileImage = null;
  bool? isLoading = false;

  SharedPreferences? prefs;
  CountryModel? selectedContryValue;
  String? companyProfieUrl = "";

  List<CountryModel> countryList =
      (jsonDecode(AllCountryListJosn)['data'] as List)
          .map((data) => CountryModel(data['id'], data['country_name']))
          .toList();

  List<CityModel> cityList = [];
  CityModel? selectedCityValue;
  @override
  void initState() {
    getAlreadyUploadRecordData();
    super.initState();
  }

  getAlreadyUploadRecordData() async {
    if (widget.candidateProfileData != null) {
      companyNameController.text =
          widget.candidateProfileData!.companyName.toString();
      companyEmailController.text =
          widget.candidateProfileData!.mail.toString();
      companyPhoneController.text =
          widget.candidateProfileData!.phone.toString();

      companyWebisteController.text =
          widget.candidateProfileData!.website.toString();
      companyaddressController.text =
          widget.candidateProfileData!.address.toString();
      companyteamSizeController.text =
          widget.candidateProfileData!.teamSize.toString();
      companyAboutNoContoller.text =
          widget.candidateProfileData!.aboutCompany.toString();

      companyProfieUrl = widget.candidateProfileData!.companyLogo.toString();

      String alreadSaveCountry =
          widget.candidateProfileData!.country.toString();

      selectedContryValue = countryList.firstWhere(
          (country) => country.countryName.toString() == alreadSaveCountry,
          orElse: () => null!);

      String alreadSaveCity = widget.candidateProfileData!.city.toString();

      cityList = (jsonDecode(AllCityListJosn)['data'] as List)
          .where((city) => city['region_id'] == selectedContryValue!.id)
          .map((data) =>
              CityModel(data['id'], data['city_name'], data['region_id']))
          .toList();

      selectedCityValue = cityList.firstWhere(
          (city) => city.cityName == alreadSaveCity,
          orElse: () => null!);
    }
  }

  Future<File> _getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    return File(image!.path);
  }

  Future<File?> _showImagePickerDialog(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    try {
      final selectedImage = await showDialog<File>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColor.goldenColor,
            contentPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.only(bottom: 5),
            title: Container(
                constraints: const BoxConstraints(maxWidth: 300.0),
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                color: AppColor.goldenColor,
                child: const Text(
                  "Select Image",
                  style: TextStyle(color: Colors.white),
                )),
            content: Container(
              height: 140,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              color: Colors.white,
              constraints: const BoxConstraints(maxWidth: 300.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      final PermissionStatus status =
                          await Permission.camera.status;
                      if (status.isGranted) {
                        final pickedFile = await _picker.pickImage(
                          source: ImageSource.camera,
                        );
                        if (pickedFile != null) {
                          Navigator.of(context).pop(File(pickedFile.path));
                        }
                      } else if (status.isDenied) {
                        Navigator.pop(context);

                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.storage,
                          Permission.camera,
                          Permission.photos,
                        ].request();
                      } else {
                        Navigator.pop(context);
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColor.goldenColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            content: const Text(
                              "Please Allow Camera Permssion!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                          await Permission.storage.status;
                      if (status.isGranted) {
                        final pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          Navigator.of(context).pop(File(pickedFile.path));
                        }
                      } else if (status.isDenied) {
                        Navigator.pop(context);

                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.storage,
                          Permission.camera,
                          Permission.photos,
                        ].request();
                      } else {
                        Navigator.pop(context);
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColor.goldenColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            content: const Text(
                              "Please Allow Gallery Permssion!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

      // Check if an image was selected and do something with it
      if (selectedImage != null) {
        return selectedImage;
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              ref.read(bottomAppBarStateNotifer.notifier).state = 0;
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => AdminHomePage()));
            },
            icon: Icon(Icons.arrow_back)),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Comapny Profile",
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
          SingleChildScrollView(
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
                                  titlePadding:
                                      const EdgeInsets.only(bottom: 5),
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
                                                  companyProfieUrl = "";
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
                                                  companyProfieUrl = "";
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
                          child: profileImage == null &&
                                  companyProfieUrl.toString().isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: AppColor.goldenColor),
                                      color: Colors.grey.shade300,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey.shade700,
                                    size: 100,
                                  ),
                                )
                              : companyProfieUrl!.isEmpty
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
                                        companyProfieUrl!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                      const SizedBox(
                        height: 16,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: companyNameController,
                        hintText: "Comapny Name*",
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: companyEmailController,
                        hintText: "Email Address*",
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: companyPhoneController,
                        hintText: "Phone*",
                        inputType: TextInputType.phone,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: companyregisterNoContoller,
                        hintText: "Registration No*",
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: companyWebisteController,
                        hintText: "Website URL*",
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(height: 12),
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
                          child: DropdownButton<CountryModel>(
                            hint: const Text("Select Country"),
                            dropdownColor: AppColor.goldenColor,
                            value: selectedContryValue,
                            onChanged: (newValue) {
                              setState(() {
                                selectedContryValue = newValue!;
                                selectedCityValue = null;
                                cityList = [];

                                // Filter the city list based on the selected country's ID.
                                cityList = (jsonDecode(AllCityListJosn)['data']
                                        as List)
                                    .where((city) =>
                                        city['region_id'] == newValue.id)
                                    .map((data) => CityModel(data['id'],
                                        data['city_name'], data['region_id']))
                                    .toList();
                              });
                            },
                            items: countryList
                                .map<DropdownMenuItem<CountryModel>>(
                                  (CountryModel value) =>
                                      DropdownMenuItem<CountryModel>(
                                    value: value,
                                    child: SizedBox(
                                      width: 100,
                                      child: Text(
                                        value.countryName,
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
                          child: DropdownButton<CityModel>(
                            hint: const Text("Select City"),
                            dropdownColor: AppColor.goldenColor,
                            value: selectedCityValue,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCityValue = newValue;
                              });
                            },
                            items: cityList.map((city) {
                              return DropdownMenuItem<CityModel>(
                                value: city,
                                child: Text(city.cityName),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: companyaddressController,
                        hintText: "Address*",
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: companyteamSizeController,
                        hintText: "Team Size*",
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: companyAboutNoContoller,
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        minLines: 5,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: AppColor.goldenColor)),
                            hintText: "About Company*",
                            hintStyle: const TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.normal),
                            errorStyle: const TextStyle(height: 0),
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
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            if (companyNameController.text.isEmpty) {
                              final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Please Enter Comapny Name!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (companyEmailController.text.isEmpty) {
                              final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Please Enter Email Address!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (companyPhoneController.text.isEmpty) {
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (companyregisterNoContoller
                                .text.isEmpty) {
                              final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Please Enter Company Registration No!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (companyWebisteController.text.isEmpty) {
                              final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Please Enter Company Website URL",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (companyaddressController.text.isEmpty) {
                              final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Please Enter Company Address",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (companyteamSizeController.text.isEmpty) {
                              final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Please Enter Team Size",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (companyAboutNoContoller.text.isEmpty) {
                              final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Please Enter Company About",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (selectedContryValue == null) {
                              final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Please Select Country",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (selectedCityValue == null) {
                              final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Please Select City",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              UploadProfileApi();
                            }
                          }),
                    ],
                  ),
                ),
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
      'user_id': userId.toString(),
      'company_name': companyNameController.text.trim(),
      'c_mail': companyEmailController.text.trim(),
      'c_phone': companyPhoneController.text.trim(),
      'c_website': companyWebisteController.text.trim(),
      'c_team_size': companyteamSizeController.text.trim(),
      'c_about_company': companyAboutNoContoller.text.trim(),
      'registration_no': companyregisterNoContoller.text.trim(),
      'c_country': selectedContryValue!.id.toString(),
      'c_city': selectedCityValue!.id.toString(),
      'c_address': companyaddressController.text.trim(),
      'status': 0.toString()
    };

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
            'POST', Uri.parse('${Helper().get_api_urlold()}UpdateComProfile'));

        // Add RequestBody parts
        requestBody.forEach((key, value) {
          request.fields[key] = value;
        });

        if (profileImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
              'company_logo', profileImage!.path.toString()));
        } else {
          request.fields['company_logo'] = '';
        }

        dynamic response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          print(responseBody);
          var getResponseData = jsonDecode(responseBody);

          if (getResponseData['error'] == false ||
              getResponseData['error'] == "false") {
            prefs!.setInt("profileStatus", 0);
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

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => AdminHomePage()));
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
