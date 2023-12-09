import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

import '../../DataBaseManagements/database.dart';
import '../../Models/cityModel.dart';
import '../../Models/countryModel.dart';
import '../../Models/getAllCategoryModel.dart';
import '../../Utils/all_city_static_file.dart';
import '../../Utils/all_country_static_file.dart';
import '../../Utils/global.dart';
import '../../Utils/helper.dart';
import '../../Widgets/custom_edtTextFeild.dart';

class CreateNewPostPage extends StatefulWidget {
  const CreateNewPostPage({super.key});

  @override
  State<CreateNewPostPage> createState() => _CreateNewPostPageState();
}

class _CreateNewPostPageState extends State<CreateNewPostPage> {
  final currentDateTime = TextEditingController();
  final jobTitleController = TextEditingController();
  final companyEmailController = TextEditingController();
  final jobNoOfPositionController = TextEditingController();
  final jobExperienceContoller = TextEditingController();
  final slaryController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final companyAboutNoContoller = TextEditingController();
  final addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool? isLoading = false;
  List<AllCategoryData> getAllCategoryList = [];
  SharedPreferences? prefs;
  CountryModel? selectedContryValue;

  List<CountryModel> countryList =
      (jsonDecode(AllCountryListJosn)['data'] as List)
          .map((data) => CountryModel(data['id'], data['country_name']))
          .toList();

  List<CityModel> cityList = [];
  CityModel? selectedCityValue;
  @override
  void initState() {
    setInitialValue();
    super.initState();
  }

  DatabaseHelper database = DatabaseHelper.instance;
  setInitialValue() async {
    var now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    currentDateTime.text = formattedDate.toString();
    getAllCategoryList = await database.allCategorygetData();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  AllCategoryData? selectedJobCategoryValue;
  String? selectCareerLevelValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Post New Job",
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
                      TextFormField(
                        readOnly: true,
                        controller: currentDateTime,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: AppColor.goldenColor),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: AppColor.goldenColor)),
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
                      CustomTextFieldWidget(
                        controller: jobTitleController,
                        hintText: "Title*",
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
                          child: DropdownButton<AllCategoryData>(
                            hint: const Text("Select Category*"),
                            dropdownColor: AppColor.goldenColor,
                            value: selectedJobCategoryValue,
                            onChanged: (AllCategoryData? newValue) {
                              setState(() {
                                selectedJobCategoryValue = newValue;
                              });
                            },
                            items: getAllCategoryList
                                .map<DropdownMenuItem<AllCategoryData>>(
                                  (AllCategoryData value) =>
                                      DropdownMenuItem<AllCategoryData>(
                                    value: value,
                                    child: SizedBox(
                                      width: 250,
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
                            hint: const Text("Select Career Level*"),
                            dropdownColor: AppColor.goldenColor,
                            value: selectCareerLevelValue,
                            onChanged: (newValue) {
                              setState(() {
                                selectCareerLevelValue = newValue!;
                              });
                            },
                            items: <String>[
                              'Intermediate',
                              'Basic',
                              'Advance',
                            ]
                                .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: SizedBox(
                                      width: 250,
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
                      CustomTextFieldWidget(
                        controller: jobNoOfPositionController,
                        hintText: "No of Position*",
                        inputType: TextInputType.phone,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: jobExperienceContoller,
                        hintText: "Experience Required*",
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: slaryController,
                        hintText: "Salary*",
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
                            hint: const Text("Select Country*"),
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
                                      width: 250,
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
                            hint: const Text("Select City*"),
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
                                child: SizedBox(
                                    width: 250, child: Text(city.cityName)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        onTap: () async {
                          final TimeOfDay? newTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 12, minute: 00),
                          );
                          setState(() {
                            startTimeController.text = newTime!.format(context);
                          });
                        },
                        isReadOnly: true,
                        controller: startTimeController,
                        hintText: "Start Time*",
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        onTap: () async {
                          final TimeOfDay? newTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 12, minute: 00),
                          );
                          setState(() {
                            endTimeController.text = newTime!.format(context);
                          });
                        },
                        isReadOnly: true,
                        controller: endTimeController,
                        hintText: "End Time*",
                        inputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomTextFieldWidget(
                        controller: addressController,
                        hintText: "Address*",
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
                            hintText: "Description*",
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

                            if (jobTitleController.text.isEmpty &&
                                jobNoOfPositionController.text.isEmpty &&
                                jobExperienceContoller.text.isEmpty &&
                                slaryController.text.isEmpty &&
                                startTimeController.text.isEmpty &&
                                endTimeController.text.isEmpty &&
                                companyAboutNoContoller.text.isEmpty &&
                                addressController.text.isEmpty &&
                                selectedContryValue == null &&
                                selectedCityValue == null &&
                                selectedJobCategoryValue == null &&
                                selectCareerLevelValue == null) {
                              final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColor.goldenColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  content: const Text(
                                    "Please fill all required feilds!",
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
            .post(Uri.parse('${Helper().get_api_urlold()}PostNewJob'), body: {
          "company_id": userId.toString(),
          "title": jobTitleController.text.trim().toString(),
          "no_of_postions": jobNoOfPositionController.text.trim().toString(),
          "experience": jobExperienceContoller.text.trim().toString(),
          "address": addressController.text.trim().toString(),
          "category": selectedJobCategoryValue!.id.toString(),
          "city": selectedCityValue!.id.toString(),
          "start_time": startTimeController.text.trim().toString(),
          "end_time": endTimeController.text.trim().toString(),
          "date_time": currentDateTime.text.trim().toString(),
          "approve": "0",
          "career": selectCareerLevelValue! == "Intermediate"
              ? "1"
              : selectCareerLevelValue! == "Basic"
                  ? "2"
                  : "3",
          "type": jobTitleController.text.trim().toString(),
          "description": companyAboutNoContoller.text.trim().toString(),
          "apply_date": currentDateTime.text.trim().toString(),
          "country": selectedContryValue!.id.toString(),
          "job_price": slaryController.text.trim().toString(),
        });

        print(response.body);

        if (response.statusCode == 200) {
          var getResponseData = jsonDecode(response.body);

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
