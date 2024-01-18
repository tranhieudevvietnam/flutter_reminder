import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ko.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'cache/component_cache_data.dart';

class ComponentLanguageCode {
  ComponentLanguageCode._();

  static ComponentLanguageCode instant = ComponentLanguageCode._();

  ///TODO: config default language code English
  Future init() async {
    if (languageCode == null) {
      await ComponentLanguageCode.instant.setLanguageCode("en");
    }
  }

  static AppLocalizations get language => _localizedValues[ComponentLanguageCode.instant.languageCode]!;

  static final _localizedValues = <String, AppLocalizations>{
    'en': AppLocalizationsEn(),
    'ko': AppLocalizationsKo(),
  };

  // #region local language
  ///Lấy ra local language
  String? get languageCode => ComponentCacheData.instant.pref.getString("languageCode");

  ///Lưu lại local language
  Future<void>? setLanguageCode(String languageCode) => ComponentCacheData.instant.pref.setString("languageCode", languageCode);

  // #endregion
}
