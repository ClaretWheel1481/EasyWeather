// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get about => 'Über';

  @override
  String get themeMode => 'Design-Modus';

  @override
  String get system => 'System';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get temperatureUnit => 'Temperatureinheit';

  @override
  String get cityManager => 'Städte verwalten';

  @override
  String get cities => 'Städte';

  @override
  String get main => 'Hauptstadt';

  @override
  String get noCitiesAdded => 'Noch keine Städte hinzugefügt';

  @override
  String deleteCityMessage(String cityName) {
    return 'Möchten Sie \"$cityName\" wirklich löschen?';
  }

  @override
  String get delete => 'Löschen';

  @override
  String get search => 'Suchen';

  @override
  String get searchHint => 'Stadtname eingeben...';

  @override
  String get searchHintOnSurface => 'Geben Sie einen Städtenamen ein, um die Suche zu starten';

  @override
  String get noResults => 'Keine Ergebnisse gefunden';

  @override
  String get searchError => 'Suchfehler';

  @override
  String get weatherUnknown => 'Unbekannt';

  @override
  String get weatherClear => 'Klar';

  @override
  String get weatherCloudy => 'Bewölkt';

  @override
  String get weatherFoggy => 'Nebel';

  @override
  String get weatherRainy => 'Regen';

  @override
  String get weatherSnowy => 'Schnee';

  @override
  String get weatherThunderstorm => 'Gewitter';

  @override
  String get windDirectionNorth => 'Nord';

  @override
  String get windDirectionNortheast => 'Nordost';

  @override
  String get windDirectionEast => 'Ost';

  @override
  String get windDirectionSoutheast => 'Südost';

  @override
  String get windDirectionSouth => 'Süd';

  @override
  String get windDirectionSouthwest => 'Südwest';

  @override
  String get windDirectionWest => 'West';

  @override
  String get windDirectionNorthwest => 'Nordwest';

  @override
  String get humidity => 'Luftfeucht.';

  @override
  String get pressure => 'Luftdruck';

  @override
  String get visibility => 'Sichtweite';

  @override
  String get feelsLike => 'Gefühlt';

  @override
  String get windSpeed => 'Windgeschw.';

  @override
  String get windDirection => 'Windricht.';

  @override
  String get precipitation => 'Niederschlag';

  @override
  String get hourlyForecast => 'Stündliche Vorhersage';

  @override
  String get next7Days => 'Nächste 7 Tage';

  @override
  String get detailedData => 'Detaillierte Daten';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get monetColor => 'Monet-Farbe';

  @override
  String get retry => 'Wiederholen';

  @override
  String get weatherDataError => 'Wetterdaten konnten nicht geladen werden';

  @override
  String get uvIndex => 'UV-Index';

  @override
  String get addCity => 'Stadt hinzufügen';

  @override
  String get addByLocation => 'Per Standort hinzufügen';

  @override
  String get locating => 'Standort wird ermittelt...';

  @override
  String get locationPermissionDenied => 'Standortberechtigung verweigert oder Ortungsdienst nicht aktiviert';

  @override
  String get locationNotRecognized => 'Aktueller Standort nicht erkannt';

  @override
  String get locatingSuccess => 'Standort erfolgreich ermittelt, bitte warten...';

  @override
  String get airQuality => 'Luftqual.';

  @override
  String get airQualityGood => 'Gut';

  @override
  String get airQualityModerate => 'Mäßig';

  @override
  String get airQualityUnhealthyForSensitive => 'Ungesund für sensible Gruppen';

  @override
  String get airQualityUnhealthy => 'Ungesund';

  @override
  String get airQualityVeryUnhealthy => 'Sehr ungesund';

  @override
  String get airQualityHazardous => 'Gefährlich';

  @override
  String get addHomeWidget => 'Homescreen-Widget hinzufügen';

  @override
  String get ignoreBatteryOptimization => 'Batterieoptimierung ignorieren';

  @override
  String get iBODesc => 'Ermöglicht Zephyr die automatische Wetteraktualisierung im Hintergrund';

  @override
  String get iBODisabled => 'Batterieoptimierung ist bereits deaktiviert';

  @override
  String get starUs => 'Einen Stern auf GitHub';

  @override
  String get alert => 'Warnungen';

  @override
  String get hourly_windSpeed => 'Stündliche Windgeschwindigkeit';

  @override
  String get hourly_windSpeed_Desc => 'Stündliche Windgeschwindigkeit, 10m steht für die Windgeschwindigkeit in 10 Metern über dem Boden, usw. Sie können das Diagramm manuell verschieben, um detaillierte Windgeschwindigkeitsdaten pro Stunde zu sehen.';

  @override
  String get hourly_pressure => 'Stündlicher Luftdruck';

  @override
  String get hourly_pressure_Desc => 'Stündlicher Luftdruck auf Meereshöhe und Oberflächendruck auf Bodenhöhe, hPa ist die Einheit des Luftdrucks. Sie können das Diagramm manuell verschieben, um detaillierte stündliche Luftdruckdaten zu sehen.';
}
