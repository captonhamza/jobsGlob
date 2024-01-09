// import 'package:flutter/material.dart';
// import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:jobs_global/Widgets/custom_button.dart';

// import '../../DataBaseManagements/database.dart';
// import '../../Models/candidate_profile_model.dart';
// import '../../Utils/global.dart';
// import '../../Widgets/custom_edtTextFeild.dart';

// class BankDetailPage extends StatefulWidget {
//   CandidateProfileData? candidateProfileData;
//   BankDetailPage({super.key, this.candidateProfileData});

//   @override
//   State<BankDetailPage> createState() => _BankDetailPageState();
// }

// class _BankDetailPageState extends State<BankDetailPage> {
//   final bankShortCodeController = TextEditingController();
//   final accountNumberController = TextEditingController();
//   final nameofAccountController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();
//   List<Map<String, dynamic>> matchDataUserLoginDeatils = [];
//   DatabaseHelper database = DatabaseHelper.instance;
//   @override
//   void initState() {
//     if (widget.candidateProfileData != null) {
//       getDataFromApi();
//     } else {
//       getDataBaseRecord();
//     }
//     super.initState();
//   }

//   getDataBaseRecord() async {
//     matchDataUserLoginDeatils = await database.getData();

//     if (matchDataUserLoginDeatils.isNotEmpty) {
//       bankShortCodeController.text = matchDataUserLoginDeatils[0]['sortCode'];
//       accountNumberController.text = matchDataUserLoginDeatils[0]['accountNo'];

//       nameofAccountController.text =
//           matchDataUserLoginDeatils[0]['accountName'];
//     }

//     setState(() {});
//   }

//   getDataFromApi() async {
//     matchDataUserLoginDeatils = await database.getData();
//     bankShortCodeController.text =
//         widget.candidateProfileData!.bankSortCode ?? "";
//     accountNumberController.text =
//         widget.candidateProfileData!.accountNumber ?? "";

//     nameofAccountController.text =
//         widget.candidateProfileData!.nameOfAccount ?? "";

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           child: Text(
//             "Bank Deatil",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         backgroundColor: AppColor.goldenColor,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Center(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CustomTextFieldWidget(
//                       controller: bankShortCodeController,
//                       hintText: "Bank Short Code",
//                       inputType: TextInputType.text,
//                     ),
//                     const SizedBox(
//                       height: 12,
//                     ),
//                     CustomTextFieldWidget(
//                       controller: accountNumberController,
//                       hintText: "Account Number",
//                       inputType: TextInputType.number,
//                     ),
//                     const SizedBox(
//                       height: 12,
//                     ),
//                     CustomTextFieldWidget(
//                       controller: nameofAccountController,
//                       hintText: "Name of Account",
//                       inputType: TextInputType.text,
//                     ),
//                     const SizedBox(
//                       height: 12,
//                     ),
//                     CustomButton(
//                       text: "Done",
//                       onPressed: () async {
//                         FocusScopeNode currentFocus = FocusScope.of(context);
//                         if (!currentFocus.hasPrimaryFocus) {
//                           currentFocus.unfocus();
//                         }

//                         if (bankShortCodeController.text.isEmpty) {
//                           final snackBar = SnackBar(
//                               behavior: SnackBarBehavior.floating,
//                               backgroundColor: AppColor.goldenColor,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               content: const Text(
//                                 "Please Enter Bank Short Code!",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ));
//                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                         } else if (accountNumberController.text.isEmpty) {
//                           final snackBar = SnackBar(
//                               behavior: SnackBarBehavior.floating,
//                               backgroundColor: AppColor.goldenColor,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               content: const Text(
//                                 "Please Enter Account Number!",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ));
//                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                         } else if (nameofAccountController.text.isEmpty) {
//                           final snackBar = SnackBar(
//                               behavior: SnackBarBehavior.floating,
//                               backgroundColor: AppColor.goldenColor,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               content: const Text(
//                                 "Please Enter Name of Account!",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.normal,
//                                 ),
//                               ));
//                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                         } else {
//                           Map<String, dynamic> PersonDetails = {
//                             "sortCode": bankShortCodeController.text.trim(),
//                             "accountNo": accountNumberController.text.trim(),
//                             "accountName":
//                                 nameofAccountController.text.toString(),
//                             "bankInfoValid": "true",
//                           };

//                           if (matchDataUserLoginDeatils.isEmpty) {
//                             int id = await database.saveData(PersonDetails);
//                             if (id > 0) {
//                               Navigator.pop(context);
//                             }
//                           } else {
//                             int id = await database.updateData(
//                                 matchDataUserLoginDeatils[0]['id'],
//                                 PersonDetails);
//                             if (id > 0) {
//                               Navigator.pop(context);
//                             }
//                           }
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
