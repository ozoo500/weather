import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_app/constants/app_colors.dart';
import 'package:weather_app/constants/app_localization.dart';
import 'package:weather_app/constants/app_string.dart';
import 'package:weather_app/views/screens/profile_screen.dart';
import '../../constants/app_assets.dart';
import '../../controller/api_services.dart';
import '../../model/current_weather_data.dart';
import '../../shared_widget/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const SafeArea(child: HomeBody()),
    const SafeArea(child: ProfileScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(weatherProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.heightBox,

          weatherData.when(
            data: (data) {
              return Column(
                children: [
                   CityNameHeader(data:data),
                  10.heightBox,
                  CurrentWeatherInfo(data: data),
                  10.heightBox,
                  WeatherDetails(data: data),
                  20.heightBox,
                  const HourlyForecast(),
                   Next7DaysSection(),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }
}

class CityNameHeader extends StatelessWidget {
  const CityNameHeader({super.key, required this.data});
  final CurrentWeatherData data;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'City name displayed at the top',
      child: "${data.name}"
          .text
          .fontFamily("Poppins")
          .size(32)
          .letterSpacing(3)
          .make(),
    );
  }
}

class CurrentWeatherInfo extends StatelessWidget {
  final CurrentWeatherData data;

  const CurrentWeatherInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          label: 'Weather icon representing current weather',
          child: Image.asset(
            AppAssets.zeroOne,
            width: 80,
            height: 80,
          ),
        ),
        Semantics(
          label: 'Current weather temperature with description',
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: "${data.main?.temp}°",
                style: const TextStyle(
                    color: Vx.gray900, fontSize: 64, fontFamily: "Poppins"),
              ),
              TextSpan(
                text: "${data.weather?.first.main}",
                style: const TextStyle(
                    color: Vx.gray700,
                    letterSpacing: 3,
                    fontSize: 14,
                    fontFamily: "Poppins"),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class WeatherDetails extends StatelessWidget {
  const WeatherDetails({super.key, required this.data});
  final CurrentWeatherData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(3, (index) {
        var iconList = [
          AppAssets.clouds,
          AppAssets.humidity,
          AppAssets.windSpeed
        ];
        var values = [data.clouds!.all, data.main!.humidity, data.wind!.speed];
        return Column(
          children: [
            Semantics(
              label: 'Weather icon for weather condition at index $index',
              child: Image.asset(
                iconList[index],
                width: 60,
                height: 60,
              ).box.gray200.padding(const EdgeInsets.all(8)).roundedSM.make(),
            ),
            10.heightBox,
            Semantics(
              label: 'Percentage or value displayed for weather condition',
              child: values[index]!.text.gray400.make(),
            ),
          ],
        );
      }),
    );
  }
}

class HourlyForecast extends ConsumerWidget {
  const HourlyForecast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hourlyWeather = ref.watch(hourlyProvider);

    return Semantics(
      label: 'A horizontal list displaying forecast for upcoming hours',
      child: SizedBox(
        height: 150,
        child: hourlyWeather.when(
          data: (data) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: data.list!.length,
              itemBuilder: (context, index) {
                final hourData = data.list![index];
                return Semantics(
                  label: 'Hourly weather forecast for hour ${index + 1}',
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text("${index+1} AM",
                            style: const TextStyle(color: Vx.gray600)),
                        Image.asset(
                          AppAssets.clouds,
                          width: 80,
                        ),
                        Text(
                          "${hourData.main!.temp}°",
                          style: const TextStyle(color: Vx.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
          error: (error, stack) {
            return Center(child: Text('Failed to load hourly data: $error'));
          },
        ),
      ),
    );
  }
}

class Next7DaysSection extends StatelessWidget {
   Next7DaysSection({super.key});

  final List<Map<String, String>> next7Days = [
    {"day": "Mon", "temp": "28°C", "condition": "Sunny"},
    {"day": "Tue", "temp": "30°C", "condition": "Cloudy"},
    {"day": "Wed", "temp": "27°C", "condition": "Rainy"},
    {"day": "Thu", "temp": "25°C", "condition": "Sunny"},
    {"day": "Fri", "temp": "29°C", "condition": "Windy"},
    {"day": "Sat", "temp": "32°C", "condition": "Cloudy"},
    {"day": "Sun", "temp": "26°C", "condition": "Clear"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Semantics(
              label: 'Title for the next 7 days forecast section',
              child: "Next 7 Days"
                  .text
                  .semiBold
                  .size(16)
                  .make(),
            ),
            Semantics(
              label: 'Button to view all 7 day forecast',
              child: TextButton(
                onPressed: () {},
                child: "View All".text.make(),
              ),
            ),
          ],
        ),
        10.heightBox,
        SizedBox(
          height: 100,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: next7Days.length,
            itemBuilder: (context, index) {
              var dayData = next7Days[index];
              return Semantics(
                label: 'Weather for ${dayData["day"]}',
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayData["day"]!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Icon(
                          Icons.wb_sunny,
                          size: 40,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dayData["temp"]!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          dayData["condition"]!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Search Screen',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
