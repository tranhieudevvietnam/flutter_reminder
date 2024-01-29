import 'package:flutter_reminder/models/model_list_reminder.dart';
import 'package:flutter_reminder/utils/components/cache/component_cache_hive.dart';

abstract class ServiceDataListReminderEvent {
  List<ModelListReminder> getAll();
  Future<int> delete(String id);
  Future<bool> insert({required ModelListReminder data, int? index});
  Future<bool> update({required String id, required ModelListReminder data});
  Future updateAll({required List<ModelListReminder> listData});
}

class ServiceDataListReminder extends ServiceDataListReminderEvent {
  ServiceDataListReminder._();

  static ServiceDataListReminder instant = ServiceDataListReminder._();

  String boxName = "listReminder";

  @override
  Future<int> delete(String id) async {
    try {
      final repo =  ComponentCacheHive.instant.getAll(boxName: boxName);
      final listDataCurrent = List<ModelListReminder>.from(repo.map((e) => ModelListReminder.formJson(e))).toList();
      final index = listDataCurrent.indexWhere((element) => element.id == id);
      listDataCurrent.removeAt(index);
      await ComponentCacheHive.instant.updateAll(boxName: boxName, data: listDataCurrent);
      return index;
    } catch (e) {
      return -1;
    }
  }

  @override
  List<ModelListReminder> getAll()  {
    final repo =  ComponentCacheHive.instant.getAll(boxName: boxName);
    final result = List<ModelListReminder>.from(repo.map((e) => ModelListReminder.formJson(e))).toList();
    return result;
  }

  @override
  Future<bool> insert({required ModelListReminder data, int? index}) async {
    try {
      final repo = await ComponentCacheHive.instant.insert(boxName: boxName, data: data);
      return repo != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> update({required String id, required ModelListReminder data}) async {
    try {
      final indexDelete = await delete(id);
      final repo = await ComponentCacheHive.instant.insert(boxName: boxName, data: data, index: indexDelete);
      return repo != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future updateAll({required List<ModelListReminder> listData}) async {
    await ComponentCacheHive.instant.updateAll(boxName: boxName, data: listData);
  }
}
