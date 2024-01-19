import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reminder/utils/components/cache/component_cache_data.dart';

class ModelLogo {
  final num day;
  final num week;
  late String valueLogo;

  ModelLogo({required this.day, required this.week}) {
    valueLogo = "ic_launcher_${week}_$day";
  }
}

class ConstantLogoApp {
  List<ModelLogo> listDataLogoApps = [];

  ConstantLogoApp._();
  static ConstantLogoApp instant = ConstantLogoApp._();

  intData() {
    for (var i = 0; i < 31; i++) {
      for (var ii = 0; ii < 7; ii++) {
        ModelLogo dataTemp = ModelLogo(
          day: i + 1,
          week: ii + 1,
        );
        listDataLogoApps.add(dataTemp);
      }
    }
  }

  setLogoApp() async {
    final dateCurrent = DateTime.now();
    final dataCurrent = listDataLogoApps.firstWhere((element) => element.day == dateCurrent.day && element.week == dateCurrent.weekday);

    try {
      if (ComponentCacheData.instant.pref.getString("icon") == dataCurrent.valueLogo) return;
      await ComponentCacheData.instant.pref.setString("icon", dataCurrent.valueLogo);
      await DynamicIconFlutter.setIcon(icon: dataCurrent.valueLogo, listAvailableIcon: listDataLogoApps.map((e) => e.valueLogo).toList());
      debugPrint("App icon change successful");
      return;
    } on PlatformException catch (e) {
      // await DynamicIconFlutter.setAlternateIconName(null);
      debugPrint("Change app icon back to default");
      return;
    }
  }

  getStringWeekByNumber(num value) {
    switch (value) {
      case 0:
        return "Mon";
      default:
    }
  }
}
