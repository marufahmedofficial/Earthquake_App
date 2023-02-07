import 'dart:convert';

import 'package:earthquake_app/models/earthquake_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EarthquakeProvider extends ChangeNotifier{

  EarthquakeModel? earthquakeModel;
  String fromDate ="2022-08-01";
  String toDate ="2022-08-05";
  String magnitude = "5";

  List<int> magnitudeList =[3,4,5,6,7,8,9,10];

  setNewData(String fromDt, String toDt, String magValue){
    fromDate = fromDt;
    toDate = toDt;
    magnitude = magValue;
  }


  void getEarthquakeData() async {
    final uri = Uri.parse(
        "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$fromDate&endtime=$toDate&minmagnitude=$magnitude&orderby=time&orderby=magnitude");

    try {
      final response = await get(uri);
      final map = json.decode(response.body);
      if (response.statusCode == 200) {
        earthquakeModel = EarthquakeModel.fromJson(map);
        print("Length of data: ${earthquakeModel!.features}");
        notifyListeners();
      } else {
        print(map["message"]);
      }
    } catch (error) {
      rethrow;
    }
  }

}