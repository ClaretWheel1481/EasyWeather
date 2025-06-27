import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'Temperature Unit'**
  String get temperatureUnit;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C)'**
  String get celsius;

  /// No description provided for @fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit (°F)'**
  String get fahrenheit;

  /// No description provided for @cityManager.
  ///
  /// In en, this message translates to:
  /// **'City Manager'**
  String get cityManager;

  /// No description provided for @cities.
  ///
  /// In en, this message translates to:
  /// **'cities'**
  String get cities;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// No description provided for @noCitiesAdded.
  ///
  /// In en, this message translates to:
  /// **'No cities added'**
  String get noCitiesAdded;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @deleteCityMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{cityName}\"?'**
  String deleteCityMessage(String cityName);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter city name...'**
  String get searchHint;

  /// No description provided for @searchHintOnSurface.
  ///
  /// In en, this message translates to:
  /// **'Enter city name to start searching'**
  String get searchHintOnSurface;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Search error'**
  String get searchError;

  /// No description provided for @weatherUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get weatherUnknown;

  /// No description provided for @weatherClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weatherClear;

  /// No description provided for @weatherCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCloudy;

  /// No description provided for @weatherFoggy.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get weatherFoggy;

  /// No description provided for @weatherRainy.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get weatherRainy;

  /// No description provided for @weatherSnowy.
  ///
  /// In en, this message translates to:
  /// **'Snowy'**
  String get weatherSnowy;

  /// No description provided for @weatherThunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get weatherThunderstorm;

  /// No description provided for @windDirectionNorth.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get windDirectionNorth;

  /// No description provided for @windDirectionNortheast.
  ///
  /// In en, this message translates to:
  /// **'Northeast'**
  String get windDirectionNortheast;

  /// No description provided for @windDirectionEast.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get windDirectionEast;

  /// No description provided for @windDirectionSoutheast.
  ///
  /// In en, this message translates to:
  /// **'Southeast'**
  String get windDirectionSoutheast;

  /// No description provided for @windDirectionSouth.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get windDirectionSouth;

  /// No description provided for @windDirectionSouthwest.
  ///
  /// In en, this message translates to:
  /// **'Southwest'**
  String get windDirectionSouthwest;

  /// No description provided for @windDirectionWest.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get windDirectionWest;

  /// No description provided for @windDirectionNorthwest.
  ///
  /// In en, this message translates to:
  /// **'Northwest'**
  String get windDirectionNorthwest;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels Like'**
  String get feelsLike;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windSpeed;

  /// No description provided for @windDirection.
  ///
  /// In en, this message translates to:
  /// **'Wind Direction'**
  String get windDirection;

  /// No description provided for @precipitation.
  ///
  /// In en, this message translates to:
  /// **'Precipitation'**
  String get precipitation;

  /// No description provided for @hourlyForecast.
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get hourlyForecast;

  /// No description provided for @next7Days.
  ///
  /// In en, this message translates to:
  /// **'Next 7 Days'**
  String get next7Days;

  /// No description provided for @detailedData.
  ///
  /// In en, this message translates to:
  /// **'Detailed Data'**
  String get detailedData;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @monetColor.
  ///
  /// In en, this message translates to:
  /// **'Monet Color'**
  String get monetColor;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @weatherDataError.
  ///
  /// In en, this message translates to:
  /// **'Weather data loading failed'**
  String get weatherDataError;

  /// No description provided for @surfacePressure.
  ///
  /// In en, this message translates to:
  /// **'Surface Pressure'**
  String get surfacePressure;

  /// No description provided for @uvIndex.
  ///
  /// In en, this message translates to:
  /// **'UV Index'**
  String get uvIndex;

  /// No description provided for @addCity.
  ///
  /// In en, this message translates to:
  /// **'Add City'**
  String get addCity;

  /// No description provided for @addByLocation.
  ///
  /// In en, this message translates to:
  /// **'Add by Location'**
  String get addByLocation;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Getting location information...'**
  String get locating;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Unable to get location permission or location service is disabled'**
  String get locationPermissionDenied;

  /// No description provided for @locationNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'Unable to recognize the current location'**
  String get locationNotRecognized;

  /// No description provided for @locatingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Location obtained successfully, please wait...'**
  String get locatingSuccess;

  /// No description provided for @airQuality.
  ///
  /// In en, this message translates to:
  /// **'Air Quality'**
  String get airQuality;

  /// No description provided for @airQualityGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get airQualityGood;

  /// No description provided for @airQualityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get airQualityModerate;

  /// No description provided for @airQualityUnhealthyForSensitive.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get airQualityUnhealthyForSensitive;

  /// No description provided for @airQualityUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get airQualityUnhealthy;

  /// No description provided for @airQualityVeryUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Very Poor'**
  String get airQualityVeryUnhealthy;

  /// No description provided for @airQualityHazardous.
  ///
  /// In en, this message translates to:
  /// **'Hazardous'**
  String get airQualityHazardous;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
