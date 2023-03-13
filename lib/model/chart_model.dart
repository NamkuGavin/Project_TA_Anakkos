// To parse this JSON data, do
//
//     final chartModel = chartModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChartModel chartModelFromJson(String str) =>
    ChartModel.fromJson(json.decode(str));

String chartModelToJson(ChartModel data) => json.encode(data.toJson());

class ChartModel {
  ChartModel({
    required this.chart,
  });

  List<Chart> chart;

  factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
        chart: List<Chart>.from(json["chart"].map((x) => Chart.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "chart": List<dynamic>.from(chart.map((x) => x.toJson())),
      };
}

class Chart {
  Chart({
    required this.month,
    required this.value,
  });

  String month;
  Value value;

  factory Chart.fromJson(Map<String, dynamic> json) => Chart(
        month: json["month"],
        value: Value.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "value": value.toJson(),
      };
}

class Value {
  Value({
    required this.type,
    required this.profit,
  });

  Type type;
  int profit;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        type: typeValues.map[json["type"]]!,
        profit: json["profit"],
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "profit": profit,
      };
}

enum Type { PROF }

final typeValues = EnumValues({"prof": Type.PROF});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
