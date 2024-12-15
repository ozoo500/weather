import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale? local;

  AppLocalization({this.local});

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  late Map<String, String> _localizedStrings;
  Future loadJsonLanguage() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${local!.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  static LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();

  String translate(String key) => _localizedStrings[key] ?? "";
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localizations = AppLocalization(local: locale);
    await localizations.loadJsonLanguage();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}

extension LocalizationContext on BuildContext {
  String translate(String key) {
    var localizations = AppLocalization.of(this);
    return localizations?.translate(key) ?? key;
  }
}
