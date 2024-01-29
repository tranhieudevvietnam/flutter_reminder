import 'package:flutter_reminder/utils/components/cache/component_cache_hive.dart';

class ModelListReminder extends ModelHiveDefault {
  int? color;
  String? title;
  num? value;

  ModelListReminder({this.color, this.title, this.value, required String id}) {
    this.id= id;
  }

  ModelListReminder.formJson(Map json) {
    id = json['id'];
    color = json['color'];
    title = json['title'];
    value = json['value'];
  }

  @override
  Map<dynamic, dynamic> toJson() {
    final mapData = <dynamic, dynamic>{};
    mapData['id'] = id;
    mapData['color'] = color;
    mapData['title'] = title;
    mapData['value'] = value;
    return mapData;
  }
}
