import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/constants.dart';
import 'provider/weather_provider.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC7E5F0),
        elevation: 0,
        leading: BackButton(color: Colors.grey,),
        title: const Text("Enter a Location",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 26
          ),
        ),
        centerTitle: true,
      ),

      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: searchBackgroundColor
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Lottie.asset('assets/images/loading.json'),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Loading indicator
                if (provider.isLoading)
                  const CircularProgressIndicator(),

                // Show weather data
                if (!provider.isLoading && provider.weather != null)
                  Column(
                    children: [
                      Text(
                        provider.weather!.city,
                        style: TextStyle(
                          fontSize: 38.sp,
                          //fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1,
                        )
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "${provider.weather!.temperature.toInt()}°C",
                        style: temperatureStyle,
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),

                // Show error if any
                if (!provider.isLoading && provider.error != null)
                  Text(
                    provider.error!,
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),

                SizedBox(height: 20.h),

                // City input
                TextField(
                  controller: _cityController,
                  onTapOutside: (event){
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter city",
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                    border: OutlineInputBorder(),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                    )
                  ),
                ),

                SizedBox(height: 10.h),

                // Search button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC7E5F0),
                    foregroundColor: Colors.white,
                    minimumSize: Size(100.w, 40.h)
                  ),
                  onPressed: () {
                    final city = _cityController.text.trim();
                    if (city.isNotEmpty) {
                      context.read<WeatherProvider>().fetchWeather(city);
                      context.read<ForecastWeatherProvider>().fetchForecastWeather(city);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Search", style: TextStyle(fontSize: 20),),
                ),

                //Lottie.asset('assets/images/loading.json')

              ],
            ),
          ),
        ],
      )
    );
  }
}
