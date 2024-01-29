import 'package:flutter_reminder/models/model_total_count.dart';
import 'package:flutter_reminder/utils/components/cache/component_cache_hive.dart';

abstract class ServiceDataTotalCountEvent {
  updateAll(List<ModelTotalCount> listData);
  List<ModelTotalCount> getAll();
}

class ServiceDataTotalCount extends ServiceDataTotalCountEvent {
  ServiceDataTotalCount._();

  static ServiceDataTotalCount instant = ServiceDataTotalCount._();

  String boxName = "totalCount";

  @override
  updateAll(List<ModelTotalCount> listData) async {
    await ComponentCacheHive.instant.updateAll(boxName: boxName, data: listData);
  }

  @override
  getAll() {
    final repo = ComponentCacheHive.instant.getAll(boxName: boxName);
    final result = List<ModelTotalCount>.from(repo.map((e) => ModelTotalCount.formJson(e))).toList();
   
    return result;
  }
}
