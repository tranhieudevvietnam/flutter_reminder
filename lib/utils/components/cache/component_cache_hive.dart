 import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

abstract class ModelHiveDefault {
  String? id;

  Map<dynamic, dynamic> toJson();
}

class ComponentCacheHive {
  ComponentCacheHive._();

  static ComponentCacheHive instant = ComponentCacheHive._();
  late Box box;
  Future init() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentsDir.path);
    box = await Hive.openBox("hiveReminder");
  }

  List getAll({required String boxName}) {
    try {
      final dataCurrent = (box.get(boxName, defaultValue: []) as List).map((e) => jsonDecode(e)).toList();
      return dataCurrent;
    } catch (e) {
      return [];
    }
  }

  Future insert({required String boxName, required ModelHiveDefault data, int? index}) async {
    try {
      final dataCurrent = box.get(boxName, defaultValue: []) as List;
      dataCurrent.insert(index ?? 0, jsonEncode(data.toJson()));
      await box.put(boxName, dataCurrent);
      return data;
    } catch (e) {
      return null;
    }
  }

  Future updateAll({required String boxName, required List<ModelHiveDefault> data}) async {
    final listJson = data.map((e) => jsonEncode(e.toJson())).toList();
    await box.put(boxName, listJson);
  }
}
