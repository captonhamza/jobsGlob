import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:jobs_global/Widgets/custom_button.dart';

import '../../DataBaseManagements/database.dart';
import '../../Models/candidate_profile_model.dart';
import '../../Utils/global.dart';
import '../../Widgets/custom_edtTextFeild.dart';

class EmergencyContactPage extends StatefulWidget {
  CandidateProfileData? candidateProfileData;
  EmergencyContactPage({super.key, this.candidateProfileData});

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  final nameTextController = TextEditingController();
  final relationController = TextEditingController();
  final phoneTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
      nameTextController.text = matchDataUserLoginDeatils[0]['emergencyName'];
      relationController.text =
          matchDataUserLoginDeatils[0]['emergencyRealtion'];

      phoneTextController.text =
          matchDataUserLoginDeatils[0]['emergencyPhoneNo'];
    }

    setState(() {});
  }

  getDataFromApi() async {
    matchDataUserLoginDeatils = await database.getData();
    nameTextController.text = widget.candidateProfileData!.eContactName ?? "";
    relationController.text =
        widget.candidateProfileData!.eContactRelation ?? "";

    phoneTextController.text = widget.candidateProfileData!.eContactPhone ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Emergency Contact",
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
                      controller: nameTextController,
                      hintText: "Name",
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextFieldWidget(
                      controller: relationController,
                      hintText: "Relation",
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextFieldWidget(
                      controller: phoneTextController,
                      hintText: "Phone",
                      inputType: TextInputType.emailAddress,
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

                        if (nameTextController.text.isEmpty) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Enter Name!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (relationController.text.isEmpty) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Enter Relation!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (phoneTextController.text.isEmpty) {
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
                          Map<String, dynamic> PersonDetails = {
                            "emergencyName": nameTextController.text.trim(),
                            "emergencyRealtion": relationController.text.trim(),
                            "emergencyPhoneNo":
                                phoneTextController.text.toString(),
                            "emergencyInfoValid": "true",
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
