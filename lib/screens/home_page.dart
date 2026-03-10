import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/constants.dart';
import 'package:weatherapp/provider/weather_provider.dart';
import 'package:weatherapp/widgets/weather_card.dart';
import 'package:weatherapp/rough_work.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  double sheetSize = 0.27;

  @override
  void initState() {
    super.initState();

    _sheetController.addListener(() {
      setState(() {
        sheetSize = _sheetController.size;
      });
    });

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshAllWeather();
    });
  }

  Future<void> refreshAllWeather() async {
    final weatherProvider = context.read<WeatherProvider>();
    final forecastProvider = context.read<ForecastWeatherProvider>();

    try {
      // Get position ONCE
      final position = await LocationHelper.getPosition();

      // Use the same position for both requests (parallel)
      await Future.wait([
        weatherProvider.fetchWeatherByCoordinates(position.latitude, position.longitude),
        forecastProvider.fetchForecastByCoordinates(position.latitude, position.longitude),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final forecastProvider = context.watch<ForecastWeatherProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: refreshAllWeather,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              Image.asset(
                'assets/images/MainBackground.png',
                fit: BoxFit.cover,
              ),

              if (!provider.isLoading && provider.weather != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: Offset(0, 20.h),
                    child: Lottie.asset(provider.weather!.weatherCodeJson, fit: BoxFit.contain),
                  ),
                ),

              if (!provider.isLoading && provider.weather != null)
                Align(
                alignment: Alignment.topLeft,
                child: Transform.translate(
                  offset: Offset(10, 50.h),
                  child: Text(provider.weather!.region, style: TextStyle(
                    fontSize: 30,
                    color: Colors.white
                  ),
                  ),
                ),
              ),

              //Current weather at top
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // needed for pull-to-refresh
                child: Transform.translate(
                  offset: Offset(0, 100.h),
                  child: Column(
                    children: [
                      if (provider.isLoading)
                        const CircularProgressIndicator(),

                      if (!provider.isLoading && provider.weather != null)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: sheetSize < 0.7 ? 1 : 0,
                          child: Column(
                            children: [
                              Text(provider.weather!.city, style: cityStyle),
                              Text('${provider.weather!.temperature.toString()}°', style: temperatureStyle),
                              Text(provider.weather!.condition, style: conditionStyle),
                              Image.network(provider.weather!.iconUrl),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // House image
              Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, 80.h),
                  child: Image.asset('assets/images/House.png'),
                ),
              ),

              // Draggable sheet
              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: 0.27,
                minChildSize: 0.2,
                maxChildSize: 0.8,
                builder: (context, scrollController) {
                  if (forecastProvider.isLoading) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: draggableScrollableBackgroundColor,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (forecastProvider.error != null) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: draggableScrollableBackgroundColor,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          forecastProvider.error!,
                          style: TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                    );
                  }

                  return Container(
                    decoration: const BoxDecoration(
                      gradient: draggableScrollableBackgroundColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.all(16.w),
                      children: [
                        const TabBar(
                          dividerColor: Color(0xFF3D2364),
                          dividerHeight: 2,
                          indicatorColor: Color(0xFFB570F7),
                          labelColor: Colors.grey,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: 'Hourly Forecast'),
                            Tab(text: 'Weekly Forecast'),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          height: 146.h,
                          child: const TabBarView(
                            children: [
                              HourlyForecastRow(),
                              ForecastRow(),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GridCard(),
                      ],
                    ),
                  );
                },
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: sheetSize > 0.76 ? 1 : 0,
                  child: Container(
                    height: 180.h,
                    padding: EdgeInsets.only(top: 40.h),
                    decoration: const BoxDecoration(
                        color: Color(0xFF3D2364),
                        gradient: topBackgroundColor
                    ),
                    child: provider.weather == null
                        ? const SizedBox()
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.weather!.city,
                          style: TextStyle(
                            fontSize: 35.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${provider.weather!.temperature}° | ${provider.weather!.condition}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topRight,
                child: Transform.translate(
                  offset: Offset(-10, 50.h),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WeatherHomePage()),
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/magnifying-glass.svg',
                      width: 24.w,
                      height: 24.h,
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    color: Colors.grey,
                    iconSize: 44,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}