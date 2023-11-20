import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Helper {
  String? apiURL2 = "https://jobsglob.com/apis/test.php/";

  String? apiGetWay = "";
  String? apiGetWay2 = "";

  void init(BuildContext context) {}

  double? get_screen_width(context) {
    return MediaQuery.of(context).size.width;
  }

  String? get_api_urlold() {
    return apiURL2.toString();
    //print('object');
  }

  String? get_api_getWay() {
    return apiGetWay.toString();
    //print('object');
  }

  String? get_api_getWay2() {
    return apiGetWay2.toString();
    //print('object');
  }

  static Future<String> getImageFromURL(String url) async {
    final ByteData imageData =
        await NetworkAssetBundle(Uri.parse(url)).load("");
    final Uint8List bytes = imageData.buffer.asUint8List();
    return FromByteToBaseString(bytes);
  }

  // static future Image imageFromBase64String(String base64String) {
  //   return Image.memory(
  //     base64Decode(base64String),
  //     fit: BoxFit.fill,
  //   );
  // }

  static Uint8List FromBaseStringToByte(String base64String) {
    //return base64Decode(base64String);
    Uint8List _bytesImage = Base64Decoder().convert(base64String);
    return _bytesImage;
  }

  static String FromByteToBaseString(Uint8List data) {
    return base64Encode(data);
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
