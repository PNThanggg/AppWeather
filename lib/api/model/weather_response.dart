class WeatherResponse {
  final double? latitude;
  final double? longitude;
  final double? generationtimeMs;
  final int? utcOffsetSeconds;
  final String? timezone;
  final String? timezoneAbbreviation;
  final double? elevation;
  final CurrentWeather? currentWeather;
  final HourlyUnits? hourlyUnits;
  final Hourly? hourly;
  final DailyUnits? dailyUnits;
  final Daily? daily;

  WeatherResponse({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.currentWeather,
    this.hourlyUnits,
    this.hourly,
    this.dailyUnits,
    this.daily,
  });

  WeatherResponse.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] as double?,
        longitude = json['longitude'] as double?,
        generationtimeMs = json['generationtime_ms'] as double?,
        utcOffsetSeconds = json['utc_offset_seconds'] as int?,
        timezone = json['timezone'] as String?,
        timezoneAbbreviation = json['timezone_abbreviation'] as String?,
        elevation = json['elevation'] as double?,
        currentWeather =
            (json['current_weather'] as Map<String, dynamic>?) != null
                ? CurrentWeather.fromJson(
                    json['current_weather'] as Map<String, dynamic>)
                : null,
        hourlyUnits = (json['hourly_units'] as Map<String, dynamic>?) != null
            ? HourlyUnits.fromJson(json['hourly_units'] as Map<String, dynamic>)
            : null,
        hourly = (json['hourly'] as Map<String, dynamic>?) != null
            ? Hourly.fromJson(json['hourly'] as Map<String, dynamic>)
            : null,
        dailyUnits = (json['daily_units'] as Map<String, dynamic>?) != null
            ? DailyUnits.fromJson(json['daily_units'] as Map<String, dynamic>)
            : null,
        daily = (json['daily'] as Map<String, dynamic>?) != null
            ? Daily.fromJson(json['daily'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'generationtime_ms': generationtimeMs,
        'utc_offset_seconds': utcOffsetSeconds,
        'timezone': timezone,
        'timezone_abbreviation': timezoneAbbreviation,
        'elevation': elevation,
        'current_weather': currentWeather?.toJson(),
        'hourly_units': hourlyUnits?.toJson(),
        'hourly': hourly?.toJson(),
        'daily_units': dailyUnits?.toJson(),
        'daily': daily?.toJson()
      };
}

class CurrentWeather {
  final double? temperature;
  final double? windspeed;
  final int? winddirection;
  final int? weathercode;
  final String? time;

  CurrentWeather({
    this.temperature,
    this.windspeed,
    this.winddirection,
    this.weathercode,
    this.time,
  });

  CurrentWeather.fromJson(Map<String, dynamic> json)
      : temperature = json['temperature'] as double?,
        windspeed = json['windspeed'] as double?,
        winddirection = json['winddirection'] as int?,
        weathercode = json['weathercode'] as int?,
        time = json['time'] as String?;

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'windspeed': windspeed,
        'winddirection': winddirection,
        'weathercode': weathercode,
        'time': time
      };

  @override
  String toString() {
    return "Current weather: Temperature: $temperature, Wind speed: ${windspeed.toString()}";
  }
}

class HourlyUnits {
  final String? time;
  final String? weathercode;
  final String? temperature2m;

  HourlyUnits({
    this.time,
    this.weathercode,
    this.temperature2m,
  });

  HourlyUnits.fromJson(Map<String, dynamic> json)
      : time = json['time'] as String?,
        weathercode = json['weathercode'] as String?,
        temperature2m = json['temperature_2m'] as String?;

  Map<String, dynamic> toJson() => {
        'time': time,
        'weathercode': weathercode,
        'temperature_2m': temperature2m,
      };
}

class Hourly {
  final List<String>? time;
  final List<int>? weathercode;
  final List<double>? temperature2m;

  Hourly({
    this.time,
    this.weathercode,
    this.temperature2m,
  });

  Hourly.fromJson(Map<String, dynamic> json)
      : time =
            (json['time'] as List?)?.map((dynamic e) => e as String).toList(),
        weathercode = (json['weathercode'] as List?)
            ?.map((dynamic e) => e as int)
            .toList(),
        temperature2m = (json['temperature_2m'] as List?)
            ?.map((dynamic e) => e as double)
            .toList();

  Map<String, dynamic> toJson() => {
        'time': time,
        'weathercode': weathercode,
        'temperature_2m': temperature2m,
      };
}

class DailyUnits {
  final String? time;
  final String? weathercode;
  final String? temperature2mMax;
  final String? temperature2mMin;

  DailyUnits({
    this.time,
    this.weathercode,
    this.temperature2mMax,
    this.temperature2mMin,
  });

  DailyUnits.fromJson(Map<String, dynamic> json)
      : time = json['time'] as String?,
        weathercode = json['weathercode'] as String?,
        temperature2mMax = json['temperature_2m_max'] as String?,
        temperature2mMin = json['temperature_2m_min'] as String?;

  Map<String, dynamic> toJson() => {
        'time': time,
        'weathercode': weathercode,
        'temperature_2m_max': temperature2mMax,
        'temperature_2m_min': temperature2mMin,
      };
}

class Daily {
  final List<String>? time;
  final List<int>? weathercode;
  final List<double>? temperature2mMax;
  final List<double>? temperature2mMin;

  Daily({
    this.time,
    this.weathercode,
    this.temperature2mMax,
    this.temperature2mMin,
  });

  Daily.fromJson(Map<String, dynamic> json)
      : time =
            (json['time'] as List?)?.map((dynamic e) => e as String).toList(),
        weathercode = (json['weathercode'] as List?)
            ?.map((dynamic e) => e as int)
            .toList(),
        temperature2mMax = (json['temperature_2m_max'] as List?)
            ?.map((dynamic e) => e as double)
            .toList(),
        temperature2mMin = (json['temperature_2m_min'] as List?)
            ?.map((dynamic e) => e as double)
            .toList();

  Map<String, dynamic> toJson() => {
        'time': time,
        'weathercode': weathercode,
        'temperature_2m_max': temperature2mMax,
        'temperature_2m_min': temperature2mMin,
      };
}
