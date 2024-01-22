import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_reminder/contants/constant_logo_app.dart';

import 'modules/reminder/page_reminder_export.dart' as reminder;
import 'utils/components/cache/component_cache_data.dart';
import 'utils/components/component_language_code.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ComponentCacheData.instant.initCache();
  await ComponentLanguageCode.instant.init();
  await ConstantLogoApp.instant.intData();



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const reminder.PageHome(),
    );
  }
}
