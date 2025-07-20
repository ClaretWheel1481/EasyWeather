// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get about => 'À propos';

  @override
  String get themeMode => 'Mode de thème';

  @override
  String get system => 'Système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get temperatureUnit => 'Unité de température';

  @override
  String get cityManager => 'Gestion des villes';

  @override
  String get cities => 'Villes';

  @override
  String get main => 'Principal';

  @override
  String get noCitiesAdded => 'Aucune ville ajoutée';

  @override
  String deleteCityMessage(String cityName) {
    return 'Êtes-vous sûr de vouloir supprimer \"$cityName\" ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get search => 'Rechercher';

  @override
  String get searchHint => 'Nom de la ville...';

  @override
  String get searchHintOnSurface => 'Entrez un nom de ville pour commencer';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get searchError => 'Erreur de recherche';

  @override
  String get weatherUnknown => 'Inconnu';

  @override
  String get weatherClear => 'Soleil';

  @override
  String get weatherCloudy => 'Nuageux';

  @override
  String get weatherFoggy => 'Brouillard';

  @override
  String get weatherRainy => 'Pluie';

  @override
  String get weatherSnowy => 'Neige';

  @override
  String get weatherThunderstorm => 'Orage';

  @override
  String get windDirectionNorth => 'Nord';

  @override
  String get windDirectionNortheast => 'Nord-Est';

  @override
  String get windDirectionEast => 'Est';

  @override
  String get windDirectionSoutheast => 'Sud-Est';

  @override
  String get windDirectionSouth => 'Sud';

  @override
  String get windDirectionSouthwest => 'Sud-Ouest';

  @override
  String get windDirectionWest => 'Ouest';

  @override
  String get windDirectionNorthwest => 'Nord-Ouest';

  @override
  String get humidity => 'Humidité';

  @override
  String get pressure => 'Pression';

  @override
  String get visibility => 'Visibilité';

  @override
  String get feelsLike => 'Ressenti';

  @override
  String get windSpeed => 'V. du vent';

  @override
  String get windDirection => 'Dir. du vent';

  @override
  String get precipitation => 'Précipitations';

  @override
  String get hourlyForecast => 'Prévision horaire';

  @override
  String get next7Days => '7 prochains jours';

  @override
  String get detailedData => 'Données détaillées';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get monetColor => 'Couleur dynamique';

  @override
  String get retry => 'Réessayer';

  @override
  String get weatherDataError => 'Échec du chargement des données météo';

  @override
  String get uvIndex => 'Indice UV';

  @override
  String get addCity => 'Ajouter une ville';

  @override
  String get addByLocation => 'Ajouter par localisation';

  @override
  String get locating => 'Obtention de la localisation...';

  @override
  String get locationPermissionDenied => 'Permission de localisation refusée ou service désactivé';

  @override
  String get locationNotRecognized => 'Localisation actuelle non reconnue';

  @override
  String get locatingSuccess => 'Localisation obtenue, veuillez patienter...';

  @override
  String get airQuality => 'AQ';

  @override
  String get airQualityGood => 'Bonne';

  @override
  String get airQualityModerate => 'Modérée';

  @override
  String get airQualityUnhealthyForSensitive => 'Acceptable';

  @override
  String get airQualityUnhealthy => 'Mauvaise';

  @override
  String get airQualityVeryUnhealthy => 'Très mauvaise';

  @override
  String get airQualityHazardous => 'Dangereuse';

  @override
  String get addHomeWidget => 'Ajouter un widget au bureau';

  @override
  String get ignoreBatteryOptimization => 'Ignorer l\'optimisation de la batterie';

  @override
  String get iBODesc => 'Permet à Zephyr de mettre à jour les données météo en arrière-plan';

  @override
  String get iBODisabled => 'L\'optimisation de la batterie est désactivée';

  @override
  String get starUs => 'Étoilez-nous sur GitHub';

  @override
  String get alert => 'Alertes';

  @override
  String get hourly_windSpeed => 'Vitesse horaire du vent';

  @override
  String get hourly_windSpeed_Desc => 'Vitesse du vent par heure, 10m représente la vitesse du vent à 10 mètres au-dessus du sol, et ainsi de suite.';
}
