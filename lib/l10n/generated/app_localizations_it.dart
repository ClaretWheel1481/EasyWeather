// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get about => 'Informazioni';

  @override
  String get themeMode => 'Modalità Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get temperatureUnit => 'Unità di Temperatura';

  @override
  String get celsius => 'Celsius (°C)';

  @override
  String get fahrenheit => 'Fahrenheit (°F)';

  @override
  String get cityManager => 'Gestore Città';

  @override
  String get cities => 'città';

  @override
  String get main => 'Principale';

  @override
  String get noCitiesAdded => 'Nessuna città aggiunta';

  @override
  String get confirm => 'Conferma';

  @override
  String deleteCityMessage(String cityName) {
    return 'Sei sicuro di voler eliminare \"$cityName\"?';
  }

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get search => 'Cerca';

  @override
  String get searchHint => 'Inserisci nome città...';

  @override
  String get searchHintOnSurface => 'Inserisci nome città per iniziare la ricerca';

  @override
  String get noResults => 'Nessun risultato trovato';

  @override
  String get searchError => 'Errore di ricerca';

  @override
  String get weatherUnknown => 'Sconosciuto';

  @override
  String get weatherClear => 'Sereno';

  @override
  String get weatherCloudy => 'Nuvoloso';

  @override
  String get weatherFoggy => 'Nebbia';

  @override
  String get weatherRainy => 'Pioggia';

  @override
  String get weatherSnowy => 'Neve';

  @override
  String get weatherThunderstorm => 'Temporale';

  @override
  String get windDirectionNorth => 'Nord';

  @override
  String get windDirectionNortheast => 'Nordest';

  @override
  String get windDirectionEast => 'Est';

  @override
  String get windDirectionSoutheast => 'Sudest';

  @override
  String get windDirectionSouth => 'Sud';

  @override
  String get windDirectionSouthwest => 'Sudovest';

  @override
  String get windDirectionWest => 'Ovest';

  @override
  String get windDirectionNorthwest => 'Nordovest';

  @override
  String get humidity => 'Umidità';

  @override
  String get pressure => 'Pressione';

  @override
  String get visibility => 'Visibilità';

  @override
  String get feelsLike => 'Percepita';

  @override
  String get windSpeed => 'Vento';

  @override
  String get windDirection => 'Direzione';

  @override
  String get precipitation => 'Precip.';

  @override
  String get hourlyForecast => 'Previsioni Orarie';

  @override
  String get next7Days => 'Prossimi 7 Giorni';

  @override
  String get detailedData => 'Dati Dettagliati';

  @override
  String get settings => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get monetColor => 'Colore Dynamico';

  @override
  String get retry => 'Riprova';

  @override
  String get weatherDataError => 'Caricamento dati meteo fallito';

  @override
  String get uvIndex => 'Indice UV';

  @override
  String get addCity => 'Aggiungi Città';

  @override
  String get addByLocation => 'Aggiungi per Posizione';

  @override
  String get locating => 'Ottenimento informazioni posizione...';

  @override
  String get locationPermissionDenied => 'Impossibile ottenere il permesso di posizione o il servizio di posizione è disabilitato';

  @override
  String get locationNotRecognized => 'Impossibile riconoscere la posizione corrente';

  @override
  String get locatingSuccess => 'Posizione ottenuta con successo, attendere...';

  @override
  String get airQuality => 'QA';

  @override
  String get airQualityGood => 'Buona';

  @override
  String get airQualityModerate => 'Moderata';

  @override
  String get airQualityUnhealthyForSensitive => 'Discreta';

  @override
  String get airQualityUnhealthy => 'Scarsa';

  @override
  String get airQualityVeryUnhealthy => 'Molto Scarsa';

  @override
  String get airQualityHazardous => 'Pericolosa';

  @override
  String get addHomeWidget => 'Aggiungi widget per il desktop';

  @override
  String get starUs => 'Dateci una stella';
}
