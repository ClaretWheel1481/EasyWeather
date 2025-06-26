English | [简体中文](README_CN.md)

<p align="center">
  <a href="https://github.com/ClaretWheel1481/easyweather">
    <img src="./public/easyweather.png" height="200"/>
  </a>
</p>

# EasyWeather

A simple and beautiful weather app built with Flutter, powered by the OpenMeteo API and the search functionality is provided by the OpenStreetMap API.

---

## Warning
> ⚠️ Only suitable for Android 9.0 or iOS 14 and above mobile devices.

## Features
- Real-time weather query for multiple cities
- City management: add, delete, set default
- 7-day weather forecast
- Dynamic weather icons and backgrounds
- Theme settings with dynamic color support
- Temperature unit switch (°C/°F)
- Localization (l10n) support

## Usage
1. Tap the search button in the top right corner to search for a city. Select a city to return to the main screen and save it to city list, or tap the location button to get weather data of your local city.
2. Manage saved cities in the settings page: set default or delete.
3. Switch theme, language, and temperature unit in settings.

## Tech Stack
- Flutter 3.32.4
- OpenMeteo API
- OpenStreetMap API


## Contributing
We welcome community users to contribute! Feel free to fork this repository, submit Pull Requests, and make suggestions and report bugs through Issues.

### Translation
1. The language files are located in the `/lib/l10n` directory.
2. You need to duplicate the `app_en.arb` file, then change the file name to the language you want to translate, for example, `app_fr.arb`.
3. Complete the translation of the language files.
4. Run `flutter gen-l10n` in the terminal at the root of your project.
5. Push your code and submit a [Pull Request](https://github.com/ClaretWheel1481/EasyWeather/pulls).

## Screenshots
<table>
  <tr>
    <td><img src="./public/sample_main_light.png" width="200"/></td>
    <td><img src="./public/sample_main_dark.png" width="200"/></td>
  </tr>
  <tr>
    <td><img src="./public/sample_settings_light.png" width="200"/></td>
    <td><img src="./public/sample_settings_dark.png" width="200"/></td>
  </tr>
</table>

## Download
[Click here to download the latest version of EasyWeather](https://github.com/ClaretWheel1481/easyweather/releases/latest)

## Acknowledgments
This project is built with the help of these amazing open-source projects and APIs:

### Frameworks & SDKs
- [Flutter](https://flutter.dev/) - UI framework
- [Dart](https://dart.dev/) - Programming language

### APIs
- [OpenMeteo API](https://open-meteo.com/) - Weather data
- [OpenStreetMap API](https://www.openstreetmap.org/) - City search

### Dependencies
- [shared_preferences](https://pub.dev/packages/shared_preferences) - Local data storage
- [http](https://pub.dev/packages/http) - HTTP requests
- [dynamic_color](https://pub.dev/packages/dynamic_color) - Material You dynamic colors
- [geolocator](https://pub.dev/packages/geolocator) - Location services
- [geocoding](https://pub.dev/packages/geocoding) - Address geocoding
- [flutter_localizations](https://flutter.dev/docs/development/accessibility-and-localization/internationalization) - Internationalization

## License
[MIT License](LICENSE) © Huang LinXing