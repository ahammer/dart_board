import '../../model.dart';

///🕓🕓🕓🕓🕓🕓🕓🕓🕓
/// Helpers for the ClockModel
///

//Map of Weather to Emoji
const weatherMap = {
  WeatherCondition.cloudy: 'weather_icons/cloud.png',
  WeatherCondition.foggy: 'weather_icons/fog.png',
  WeatherCondition.rainy: 'weather_icons/rain.png',
  WeatherCondition.snowy: 'weather_icons/snow.png',
  WeatherCondition.sunny: 'weather_icons/sun.png',
  WeatherCondition.thunderstorm: 'weather_icons/thunder.png',
  WeatherCondition.windy: 'weather_icons/wind.png'
};

/// Add ability to get the weather asset name from the clock model
extension ClockModelHelpers on ClockModel {
  /// When we want to show the weather as a Icon
  String get weatherAsset => weatherMap[weatherCondition] ?? "Unknown";
}
