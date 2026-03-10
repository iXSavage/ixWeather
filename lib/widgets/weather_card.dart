import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/constants.dart';
import 'package:weatherapp/provider/weather_provider.dart';
import 'package:intl/intl.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.title,required this.description,required this.value, required this.icon, this.unit,});
  final String title;
  final String description;
  final String value;
  final String? unit;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border:Border.all(color: weatherCardBorderColor, width: 2),
        //color: weatherCardBackgroundColor,
        gradient: weatherCardBackgroundColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (unit != null)
                Text(
                  unit!,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            ],
          ),

          Spacer(),

          Text(
            description,
            style:  TextStyle(color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),


        ],
      ),
    );
  }
}

class GridCard extends StatelessWidget {
  const GridCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final weather = provider.weather;

    final forecastProvider = context.watch<ForecastWeatherProvider>();
    final forecast = forecastProvider.weather;

    if (provider.isLoading && forecastProvider.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(100.0),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (weather == null || forecast == null) {
      return Padding(
        padding: const EdgeInsets.all(26.0),
        child: Center(child: Text("No hourly data", style: TextStyle(fontSize: 16.sp))),
      );
    }

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisSpacing: 14.w,
      mainAxisSpacing: 10.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: [
        WeatherCard(
          title: 'UV INDEX',
          icon: Icons.sunny,
          value: '${weather.uvIndex}',
          description: weather.uvCategory,
        ),

        WeatherCard(
          title: 'SUNRISE',
          icon: Icons.sunny,
          value: forecast.days[0].sunrise,
          description: 'Sunset: ${forecast.days[0].sunset}',
        ),

        WeatherCard(
          title: 'WIND',
          icon: Icons.wind_power,
          value: '${weather.wind}',
          unit: ' KM/H',
          description: 'Wind Direction: ${weather.windDirection}',
        ),

        WeatherCard(
          title: 'FEELS LIKE',
          icon: Icons.thermostat,
          value: '${weather.feelsLike}° ',
          unit: 'C',
          description: '${weather.feelsLikeDescription} to the actual temperature',
        ),

        WeatherCard(
          title: 'HUMIDITY',
          icon: Icons.water_drop,
          value: '${weather.humidity}',
          unit: '%',
          description: 'The dew point is ${weather.dewPoint}° C right now.',
        ),

        WeatherCard(
          title: 'VISIBILITY',
          icon: Icons.remove_red_eye,
          value: '${forecast.hours[0].visibilityKm}',
          unit: 'KM',
          description: forecast.hours[0].visibilityCategory,
        ),
      ],
    );
  }
}

class LongCard extends StatelessWidget {
  const LongCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 158.h,
      width: 342.w,
      decoration: BoxDecoration(
        color: Colors.deepPurple

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.air),
              Text('Air Quality'.toUpperCase())
            ],
          ),
          
          Text('3- Low Health Risk'),

          Container(
            height: 5.h,
            color: Colors.red,
          ),

          Divider(),

          Row(
            children: [
              Text('See more'),
              Icon(Icons.arrow_right_alt)
            ],
          )

        ],
      ),
    );
  }
}

class ForecastDesign extends StatelessWidget {
  final String title;
  final String iconUrl;
  final String temperature;
  const ForecastDesign({super.key, required this.title, required this.temperature, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        gradient: forecastBackgroundColor,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: weatherCardBorderColor, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontSize: 15.sp)),
          // Replace with your actual weather icon
          Image.network(iconUrl),
          Text(temperature, style: TextStyle(color: Colors.white, fontSize: 20.sp)),
        ],
      ),
    );
  }
}

class ForecastRow extends StatelessWidget {
  const ForecastRow({super.key});

  @override
  Widget build(BuildContext context) {
    final forecastProvider = context.watch<ForecastWeatherProvider>();
    final forecast = forecastProvider.weather;

    // 1️⃣ Show loading indicator
    if (forecastProvider.isLoading) {
      return SizedBox(
        height: 146.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // 2️⃣ Show error message if any
    if (forecastProvider.error != null) {
      return SizedBox(
        height: 146.h,
        child: Center(
          child: Text(
            forecastProvider.error!,
            style: TextStyle(color: Colors.red, fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // 3️⃣ Show empty state if no data
    if (forecast == null || forecast.days.isEmpty) {
      return SizedBox(
        height: 146.h,
        child: Center(
          child: Text(
            "No forecast data available",
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      );
    }

    // 4️⃣ Show the forecast list
    return SizedBox(
      height: 146.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.days.length,
        itemBuilder: (context, index) {
          final day = forecast.days[index];

          return ForecastDesign(
            title: DateFormat.E().format(DateTime.parse(day.date)), // "Mon", "Tue"
            temperature: '${day.maxTemp.toInt()}°',
            iconUrl: day.iconUrl,
          );
        },
      ),
    );
  }
}

class HourlyForecastRow extends StatelessWidget {
  const HourlyForecastRow({super.key});

  @override
  Widget build(BuildContext context) {
    final forecastProvider = context.watch<ForecastWeatherProvider>();
    final forecast = forecastProvider.weather;

    // 1️⃣ Show loading indicator
    if (forecastProvider.isLoading) {
      return SizedBox(
        height: 146.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // 2️⃣ Show error message if any
    if (forecastProvider.error != null) {
      return SizedBox(
        height: 146.h,
        child: Center(
          child: Text(
            forecastProvider.error!,
            style: TextStyle(color: Colors.red, fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (forecast == null || forecast.hours.isEmpty) {
      return SizedBox(
        height: 146.h,
        child: Center(child: Text("No hourly data", style: TextStyle(fontSize: 16.sp))),
      );
    }

    return SizedBox(
      height: 146.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.hours.length,
        itemBuilder: (context, index) {
          final hour = forecast.hours[index];

          // format the time to HH AM/PM
          final formattedTime = DateFormat.j().format(DateTime.parse(hour.time));

          return ForecastDesign(
            title: formattedTime,
            temperature: '${hour.tempC.toInt()}°',
            iconUrl: hour.iconUrl,
          );
        },
      ),
    );
  }
}

