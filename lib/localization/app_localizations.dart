import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixell_app/utils/my_constants.dart';

class AppLocalizations {
  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations prevLocalization;
  static AppLocalizations of(BuildContext context) {
    if(context!=null) {
      prevLocalization = Localizations.of<AppLocalizations>(context, AppLocalizations);
      return prevLocalization;
    }else if(prevLocalization!=null){
      return prevLocalization;
    }
  }

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String selectedLanguageCode = locale.languageCode.toString();
    if (selectedLanguageCode == 'ja') {
      selectedLanguageCode = 'jp'; // https://linker.backlog.jp/view/PIX-84#comment-69222719
    }
    MyConstants.selectedLanguageCode = selectedLanguageCode;

    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'ja','es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
