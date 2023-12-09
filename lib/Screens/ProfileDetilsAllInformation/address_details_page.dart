import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:jobs_global/Models/cityModel.dart';
import 'package:jobs_global/Models/countryModel.dart';
import 'package:jobs_global/Widgets/custom_button.dart';

import '../../DataBaseManagements/database.dart';
import '../../Models/candidate_profile_model.dart';
import '../../Utils/all_city_static_file.dart';
import '../../Utils/all_country_static_file.dart';
import '../../Utils/global.dart';
import '../../Widgets/custom_edtTextFeild.dart';

class AddressDeatilsPage extends StatefulWidget {
  CandidateProfileData? candidateProfileData;
  AddressDeatilsPage({super.key, this.candidateProfileData});

  @override
  State<AddressDeatilsPage> createState() => _AddressDeatilsPageState();
}

class _AddressDeatilsPageState extends State<AddressDeatilsPage> {
  final addressTextController = TextEditingController();
  final postCodeController = TextEditingController();
  final cityTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  CountryModel? selectedContryValue;
  CityModel? selectedTownValue;
  CityModel? selectedCityOfBirth;
  CountryModel? selectedNationalityValue;

  List<Map<String, dynamic>> matchDataUserLoginDeatils = [];
  DatabaseHelper database = DatabaseHelper.instance;

  List<CountryModel> countryList =
      (jsonDecode(AllCountryListJosn)['data'] as List)
          .map((data) => CountryModel(data['id'], data['country_name']))
          .toList();

  List<CityModel> cityList = [];

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
    final countryData = json.decode(AllCountryListJosn);
    setState(() {
      countryList.sort((a, b) => a.countryName.compareTo(b.countryName));

      // cityData.sort((a, b) => a['city_name'].compareTo(b['city_name']));
    });
    final cityData = json.decode(AllCityListJosn);

    matchDataUserLoginDeatils = await database.getData();
    if (matchDataUserLoginDeatils.isNotEmpty) {
      addressTextController.text =
          matchDataUserLoginDeatils[0]['address'] ?? "";

      postCodeController.text = matchDataUserLoginDeatils[0]['postCode'] ?? "";

      String alreadSaveCountry = matchDataUserLoginDeatils[0]['country'];

      selectedContryValue = countryList.firstWhere(
          (country) => country.id.toString() == alreadSaveCountry,
          orElse: () => null!);

      String alreadSaveCity = matchDataUserLoginDeatils[0]['town'];
      String alreadyBirthCity = matchDataUserLoginDeatils[0]['city'];

      cityList = (jsonDecode(AllCityListJosn)['data'] as List)
          .where((city) => city['region_id'] == selectedContryValue!.id)
          .map((data) =>
              CityModel(data['id'], data['city_name'], data['region_id']))
          .toList();
      setState(() {
        cityList.sort((a, b) => a.cityName.compareTo(b.cityName));
      });

      selectedTownValue = cityList.firstWhere(
          (city) => city.id.toString() == alreadSaveCity,
          orElse: () => null!);

      selectedCityOfBirth = cityList.firstWhere(
          (city) => city.id.toString() == alreadyBirthCity,
          orElse: () => null!);

      String alreadSaveNationilty = matchDataUserLoginDeatils[0]['nationality'];

      selectedNationalityValue = countryList.firstWhere(
          (country) => country.id.toString() == alreadSaveNationilty,
          orElse: () => null!);
    }

    setState(() {});
  }

  getDataFromApi() async {
    matchDataUserLoginDeatils = await database.getData();
    var countryData = json.decode(AllCountryListJosn);
    var cityData = json.decode(AllCityListJosn);
    setState(() {
      countryList.sort((a, b) => a.countryName.compareTo(b.countryName));

      // cityData.sort((a, b) => a['city_name'].compareTo(b['city_name']));
    });

    addressTextController.text = widget.candidateProfileData!.address ?? "";

    postCodeController.text = widget.candidateProfileData!.postCode ?? "";

    String alreadSaveCountry = widget.candidateProfileData!.country!;

    selectedContryValue = countryList.firstWhere(
        (country) => country.countryName == alreadSaveCountry,
        orElse: () => null!);

    String alreadSaveCity = widget.candidateProfileData!.town ?? "";
    String alreadyBirthCity = widget.candidateProfileData!.birthCity ?? "";

    cityList = (jsonDecode(AllCityListJosn)['data'] as List)
        .where((city) => city['region_id'] == selectedContryValue!.id)
        .map((data) =>
            CityModel(data['id'], data['city_name'], data['region_id']))
        .toList();

    setState(() {
      cityList.sort((a, b) => a.cityName.compareTo(b.cityName));
    });

    selectedTownValue = cityList.firstWhere(
        (city) => city.cityName.toString() == alreadSaveCity,
        orElse: () => null!);

    selectedCityOfBirth = cityList.firstWhere(
        (city) => city.cityName.toString() == alreadyBirthCity,
        orElse: () => null!);

    String alreadSaveNationilty =
        widget.candidateProfileData!.nationality ?? "";

    selectedNationalityValue = countryList.firstWhere(
        (country) => country.countryName.toString() == alreadSaveNationilty,
        orElse: () => null!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Address Deatils",
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
                      controller: addressTextController,
                      hintText: "Address",
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
                        child: DropdownButton<CountryModel>(
                          hint: const Text("Select Country"),
                          dropdownColor: AppColor.goldenColor,
                          value: selectedContryValue,
                          onChanged: (newValue) {
                            setState(() {
                              selectedContryValue = newValue!;
                              selectedTownValue = null;
                              selectedCityOfBirth = null;
                              cityList = [];

                              // Filter the city list based on the selected country's ID.
                              cityList =
                                  (jsonDecode(AllCityListJosn)['data'] as List)
                                      .where((city) =>
                                          city['region_id'] == newValue.id)
                                      .map((data) => CityModel(data['id'],
                                          data['city_name'], data['region_id']))
                                      .toList();

                              setState(() {
                                cityList.sort(
                                    (a, b) => a.cityName.compareTo(b.cityName));
                              });
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
                          hint: const Text("Select Town"),
                          dropdownColor: AppColor.goldenColor,
                          value: selectedTownValue,
                          onChanged: (newValue) {
                            setState(() {
                              selectedTownValue = newValue;
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
                      controller: postCodeController,
                      hintText: "Post Code",
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
                        child: DropdownButton<CityModel>(
                          hint: const Text("Town/City of Birth"),
                          dropdownColor: AppColor.goldenColor,
                          value: selectedCityOfBirth,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCityOfBirth = newValue;
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
                          hint: const Text("Select Nationality"),
                          dropdownColor: AppColor.goldenColor,
                          value: selectedNationalityValue,
                          onChanged: (newValue) {
                            setState(() {
                              selectedNationalityValue = newValue!;
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
                    SizedBox(height: 12),
                    CustomButton(
                      text: "Done",
                      onPressed: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (addressTextController.text.isEmpty) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Enter Address!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (postCodeController.text.isEmpty) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Enter Post Code!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (selectedCityOfBirth == null) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Enter Town/City of Birth!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (selectedTownValue == null) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Select Town!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (selectedContryValue == null) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Select Country!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (selectedNationalityValue == null) {
                          final snackBar = SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColor.goldenColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              content: const Text(
                                "Please Select Nationality!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          Map<String, dynamic> PersonDetails = {
                            "address": addressTextController.text.trim(),
                            "postCode": postCodeController.text.trim(),
                            "city": selectedCityOfBirth!.id,
                            "country": selectedContryValue!.id,
                            "town": selectedTownValue!.id,
                            "nationality": selectedNationalityValue!.id,
                            "addressInfoValid": "true",
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
