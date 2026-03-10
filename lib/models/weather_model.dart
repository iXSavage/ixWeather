class WeatherModel {
  final String city;
  final String region;
  final double temperature;
  final String condition;
  final String iconUrl;
  final double high;
  final double low;
  final double humidity;
  final double uvIndex;
  final double wind;
  final String windDirection;
  final double feelsLike;
  final double dewPoint;
  final int code;


  WeatherModel({
    required this.city,
    required this.region,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
    required this.high,
    required this.low,
    required this.humidity,
    required this.uvIndex,
    required this.wind,
    required this.windDirection,
    required this.feelsLike,
    required this.dewPoint,
    required this.code,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['location']['name'],
      region: json['location']['region'],
      temperature: json['current']['temp_c'].toDouble(),
      condition: json['current']['condition']['text'],
      iconUrl: 'https:${json['current']['condition']['icon']}',
      high: json['current']['heatindex_c'].toDouble(),
      low: json['current']['dewpoint_c'].toDouble(),
      humidity: json['current']['humidity'].toDouble(),
      uvIndex: json['current']['uv'].toDouble(),
      wind: json['current']['wind_kph'].toDouble(),
      windDirection: json['current']['wind_dir'],
      feelsLike: json['current']['feelslike_c'],
      dewPoint: json['current']['dewpoint_c'],
      code: json['current']['condition']['code'],
    );
  }

  String get weatherCodeJson {
    const Set<int> rainCodes = {1063,1180,1183,1186,1189,1192,1195,1198,1201,1240,1243,1246,1273,1276};
    const Set<int> snowCodes = {1066,1114,1210,1213,1216,1219,1222,1225,1255,1258,1279,1282};

    if (rainCodes.contains(code)) {
      return 'assets/images/Rain.json';
  } else if (snowCodes.contains(code)) {
      return 'assets/images/Snow.json';
  } else {
      return 'assets/images/empty.json';
  }
  }

  String get uvCategory {
    final uv = uvIndex;
    if (uv <= 2) {
      return 'Low';
    } else if (uv <= 5) {
      return 'Moderate';
    } else if (uv <= 7) {
      return 'High';
    } else if (uv <= 10) {
      return 'Very High';
    } else {
      return 'Extreme';
    }
  }

  String get feelsLikeDescription {
    final diff = (feelsLike - temperature).abs();

    if (diff <= 2) {
      return 'Similar';
    } else {
      return 'Different';
    }
  }
}

class ForecastWeatherModel {
  final String city;
  final List<ForecastDay> days;
  final List<HourlyForecast> hours; // new


  ForecastWeatherModel({
    required this.city,
    required this.days,
    required this.hours
  });

  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) {
    final List list = json['forecast']['forecastday'];

    return ForecastWeatherModel(
      city: json['location']['name'],
      days: list.map((e) => ForecastDay.fromJson(e)).toList(),
      hours: List<HourlyForecast>.from(json['forecast']['forecastday'][0]['hour'].map((x) => HourlyForecast.fromJson(x))
      ),
    );
  }
}

class ForecastDay {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String iconUrl;
  final String sunrise;
  final String sunset;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.iconUrl,
    required this.sunrise,
    required this.sunset,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      maxTemp: json['day']['maxtemp_c'].toDouble(),
      minTemp: json['day']['mintemp_c'].toDouble(),
      condition: json['day']['condition']['text'],
      iconUrl: 'https:${json['day']['condition']['icon']}',
      sunrise: json['astro']['sunrise'],
      sunset: json['astro']['sunset'],
    );
  }
}

class HourlyForecast {
  final String time; // e.g., "2026-01-01 13:00"
  final double tempC;
  final String condition;
  final String iconUrl;
  final double visibilityKm;

  HourlyForecast({
    required this.time,
    required this.tempC,
    required this.condition,
    required this.iconUrl,
    required this.visibilityKm,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'],
      tempC: json['temp_c'].toDouble(),
      condition: json['condition']['text'],
      iconUrl: 'https:${json['condition']['icon']}',
      visibilityKm: json['vis_km'].toDouble(),
    );
  }

  String get visibilityCategory {
    final visibility = visibilityKm;
    if (visibility <= 0.2) {
      return 'Thick Fog';
    } else if (visibility <= 0.5) {
      return 'Moderate Fog';
    } else if (visibility <= 1) {
      return 'Light Fog';
    } else if (visibility <= 2) {
      return 'Thick Fog';
    } else if (visibility <= 4) {
      return 'Haze';
    } else if (visibility <= 10) {
      return 'Light Haze';
    } else if (visibility <= 20) {
      return 'Clear';
    } else {
      return 'Very Clear';
    }
  }

}

