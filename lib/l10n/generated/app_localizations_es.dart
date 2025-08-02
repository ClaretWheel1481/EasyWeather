// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca de';

  @override
  String get themeMode => 'Modo de Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get temperatureUnit => 'Unidad de Temperatura';

  @override
  String get cityManager => 'Gestor de Ciudades';

  @override
  String get cities => 'ciudades';

  @override
  String get main => 'Principal';

  @override
  String get noCitiesAdded => 'No hay ciudades agregadas';

  @override
  String deleteCityMessage(String cityName) {
    return '¿Estás seguro de eliminar \"$cityName\"?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get search => 'Buscar';

  @override
  String get searchHint => 'Introduce nombre de ciudad...';

  @override
  String get searchHintOnSurface => 'Introduce nombre de ciudad para buscar';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get searchError => 'Error de búsqueda';

  @override
  String get weatherUnknown => 'Desconocido';

  @override
  String get weatherClear => 'Despejado';

  @override
  String get weatherCloudy => 'Nublado';

  @override
  String get weatherFoggy => 'Niebla';

  @override
  String get weatherRainy => 'Lluvioso';

  @override
  String get weatherSnowy => 'Nevado';

  @override
  String get weatherThunderstorm => 'Tormenta';

  @override
  String get windDirectionNorth => 'Norte';

  @override
  String get windDirectionNortheast => 'Noreste';

  @override
  String get windDirectionEast => 'Este';

  @override
  String get windDirectionSoutheast => 'Sureste';

  @override
  String get windDirectionSouth => 'Sur';

  @override
  String get windDirectionSouthwest => 'Suroeste';

  @override
  String get windDirectionWest => 'Oeste';

  @override
  String get windDirectionNorthwest => 'Noroeste';

  @override
  String get humidity => 'Humedad';

  @override
  String get pressure => 'Presión';

  @override
  String get visibility => 'Visibilidad';

  @override
  String get feelsLike => 'Sens. Térmica';

  @override
  String get windSpeed => 'Vel. Viento';

  @override
  String get windDirection => 'Dir. Viento';

  @override
  String get precipitation => 'Precipitación';

  @override
  String get hourlyForecast => 'Pronóstico Horario';

  @override
  String get next7Days => '7 Días';

  @override
  String get detailedData => 'Datos Detallados';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get monetColor => 'Color Dinámico';

  @override
  String get retry => 'Reintentar';

  @override
  String get weatherDataError => 'Error al cargar datos meteorológicos';

  @override
  String get uvIndex => 'Índice UV';

  @override
  String get addCity => 'Agregar Ciudad';

  @override
  String get addByLocation => 'Agregar por Ubicación';

  @override
  String get locating => 'Obteniendo ubicación...';

  @override
  String get locationPermissionDenied => 'Permiso de ubicación denegado o servicio desactivado';

  @override
  String get locationNotRecognized => 'Ubicación actual no reconocida';

  @override
  String get locatingSuccess => 'Ubicación obtenida, espere...';

  @override
  String get airQuality => 'CA';

  @override
  String get airQualityGood => 'Buena';

  @override
  String get airQualityModerate => 'Moderada';

  @override
  String get airQualityFair => 'Aceptable';

  @override
  String get airQualityPoor => 'Mala';

  @override
  String get airQualityVeryPoor => 'Muy Mala';

  @override
  String get airQualityExtremelyPoor => 'Peligrosa';

  @override
  String get addHomeWidget => 'Agregar Widget al Escritorio';

  @override
  String get ignoreBatteryOptimization => 'Ignorar Optimización de Batería';

  @override
  String get iBODesc => 'Permite a Zephyr actualizar los datos meteorológicos en segundo plano';

  @override
  String get iBODisabled => 'Optimización de batería desactivada';

  @override
  String get starUs => 'Valóranos en GitHub';

  @override
  String get alert => 'Alertas';

  @override
  String get hourly_windSpeed => 'Velocidad horaria del viento';

  @override
  String get hourly_windSpeed_Desc => 'Velocidad del viento por hora, 10m representa la velocidad del viento a 10 metros sobre el suelo, y así sucesivamente. Puede deslizar manualmente el gráfico para ver los datos detallados de la velocidad del viento por hora.';

  @override
  String get hourly_pressure => 'Presión atmosférica horaria';

  @override
  String get hourly_pressure_Desc => 'Presión atmosférica horaria a nivel del mar y presión superficial a nivel del suelo, hPa es la unidad de presión atmosférica. Puede deslizar manualmente el gráfico para ver los datos detallados de la presión barométrica horaria.';

  @override
  String get eAQIGrading => 'Clasificación del índice europeo de calidad del aire';

  @override
  String get eAQIDesc => '0-20 es bueno, 20-40 es regular, 40-60 es moderado, 60-80 es deficiente, 80-100 es muy deficiente, >100 es extremadamente deficiente. \nLa clasificación de cada contaminante se ve en las Normas Europeas de Medio Ambiente.';

  @override
  String get weatherSource => 'Fuente meteorológica';

  @override
  String get customColor => 'Color personalizado';

  @override
  String get celsius => 'Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';
}
