import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../api/model/base_response.dart';
import '../../api/model/weather_response.dart';
import '../../api/provider/api_client.dart';
import '../../api/provider/api_constant.dart';
import '../../assets/app_image.dart';
import '../../util/app_constant.dart';
import '../../util/disable_glow_behavior.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

enum WeatherState { morning, afternoon, night, rain }

class _WeatherPageState extends State<WeatherPage> {
  WeatherState weatherState = WeatherState.morning;
  String bgImagePath = AppImage.bg1;

  int idErrorLocation = 0;
  String currentAddress = '';

  @override
  void initState() {
    super.initState();

    weatherState = greeting();

    if (weatherState == WeatherState.morning) {
      bgImagePath = AppImage.bg1;
    } else if (weatherState == WeatherState.afternoon) {
      bgImagePath = AppImage.bg2;
    } else {
      bgImagePath = AppImage.bg3;
    }
  }

  WeatherState greeting() {
    var hour = DateTime.now().hour;

    if (hour > 5 && hour < 12) {
      return WeatherState.morning;
    }

    if (hour < 17) {
      return WeatherState.afternoon;
    }

    return WeatherState.night;
  }

  Future<WeatherResponse?> getWeather(Position currentPosition) async {
    double lat = currentPosition.latitude;
    double lng = currentPosition.longitude;

    List<String> listIndexHourly = [
      'temperature_2m',
      'weathercode',
    ];

    List<String> listIndexDaily = [
      'weathercode',
      'temperature_2m_max',
      'temperature_2m_min',
    ];

    BaseResponse response =
        await ApiClient.instance.request(endPoint: ApiConstant.urlAPIWeather, method: ApiClient.GET, queryParameters: {
      'latitude': '$lat',
      'longitude': '$lng',
      'hourly': listIndexHourly,
      'daily': listIndexDaily,
      'current_weather': true,
      'timezone': 'auto',
    });

    try {
      List<Placemark> listAddress = await placemarkFromCoordinates(lat, lng);

      if (listAddress.isNotEmpty) {
        currentAddress = '${listAddress.first.subAdministrativeArea}, ${listAddress.first.administrativeArea}';
      }

      debugPrint("Current address: $currentAddress");
    } catch (e) {
      log('$e');
    }

    if (response.result == true) {
      debugPrint("Weather success");
      return WeatherResponse.fromJson(response.data);
    } else {
      if (kDebugMode) {
        print("Weather code: ${response.code} - Weather message: ${response.message}");
      }

      return Future.error("Error: ${response.message}");
    }
  }

  Future<Position> getLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      idErrorLocation = 0;
      return Future.error("Location service are disabled.");
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();

      if (locationPermission == LocationPermission.denied) {
        idErrorLocation = 1;
        return Future.error("Location permission are disabled.");
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      idErrorLocation = 2;
      return Future.error("Location permission are permanently denied, can't request location");
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getLocation(),
        builder: (context, snapshot) {
          debugPrint("idErrorLocation = $idErrorLocation");
          if (snapshot.hasData) {
            return FutureBuilder(
              future: getWeather(snapshot.data!),
              builder: (context, snapshotWeather) {
                if (snapshotWeather.hasData) {
                  List weatherCodeDay = snapshotWeather.data!.hourly!.weathercode!.sublist(0, 24);
                  List temperatureDay = snapshotWeather.data!.hourly!.temperature2m!.sublist(0, 24);
                  List timeDay = snapshotWeather.data!.hourly!.time!.sublist(0, 24);

                  List<Map<String, dynamic>> dataDay = List.generate(
                    weatherCodeDay.length,
                        (index) {
                      Map weather = AppConstant.listWMOCode
                          .firstWhere((element) => element['code'] == (weatherCodeDay[index] ?? -1));

                      return {
                        'weather_code': weather['image'],
                        'temperature': temperatureDay[index],
                        'time': timeDay[index],
                      };
                    },
                  );

                  String weatherStatus = AppConstant.listWMOCode.firstWhere((element) =>
                  element['code'] == (snapshotWeather.data!.currentWeather!.weathercode ?? -1))['desEN'];

                  debugPrint("Data day: ${dataDay.toString()}");

                  return Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            bgImagePath,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 7,
                            right: 12,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${snapshotWeather.data!.currentWeather!.temperature!.toInt().toString()}°C",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6.0,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "H : ${snapshotWeather.data!.daily!.temperature2mMax![0].toInt().toString()}°",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        Text(
                                          "L : ${snapshotWeather.data!.daily!.temperature2mMin![0].toInt().toString()}°",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      currentAddress,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: DisableGlowBehavior(),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12.0,
                                    left: 12.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    weatherStatus,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF474747),
                                      fontFamily: 'Sarabun',
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2.0,
                                  margin: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    bottom: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC3C3C3).withOpacity(0.2),
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: dataDay
                                          .map(
                                            (e) => Container(
                                          margin: const EdgeInsets.only(
                                            right: 20,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                DateFormat('HH:mm').format(DateTime.parse(e['time'])),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color(0xFF474747),
                                                  fontFamily: 'Sarabun',
                                                ),
                                              ),
                                              const SizedBox(height: 6.0),
                                              SvgPicture.asset(
                                                e['weather_code'],
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(height: 6.0),
                                              Text(
                                                '${e['temperature'].toInt()}°',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color(0xFF474747),
                                                  fontFamily: 'Sarabun',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Tomorrow's temperature",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF474747),
                                        fontFamily: 'Sarabun',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                for (int i = 0; i < snapshotWeather.data!.daily!.time!.length; i++)
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 30,
                                      bottom: 12,
                                      right: 30,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          i == 0
                                              ? "Today"
                                              : DateFormat('EEE').format(DateFormat("yyyy-MM-dd")
                                              .parse(snapshotWeather.data!.daily!.time![i])),
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF474747),
                                            fontFamily: 'Sarabun',
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${snapshotWeather.data!.daily!.temperature2mMax![i].toInt()}°",
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF474747),
                                            fontFamily: 'Sarabun',
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6.0,
                                        ),
                                        Text(
                                          "${snapshotWeather.data!.daily!.temperature2mMin![i].toInt()}°",
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF474747),
                                            fontFamily: 'Sarabun',
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } else if (snapshotWeather.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Error: ${snapshot.error.toString()}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Image.asset(
                        bgImagePath,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    ],
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return Colors.red;
                        }
                        return null; // Defer to the widget's default.
                      },
                    ),
                  ),
                  onPressed: () async {
                    if (idErrorLocation == 0) {
                      await Geolocator.openLocationSettings();
                    } else if (idErrorLocation == 1) {
                      await Geolocator.requestPermission();
                    } else {
                      await Geolocator.openAppSettings();
                    }

                    setState(() {});
                  },
                  child: Text(
                    idErrorLocation == 0
                        ? "Enable location service"
                        : idErrorLocation == 1
                        ? 'Enable permission'
                        : "Open setting",
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Request permission location'),
                  ),
                ],
              ),
            );
          }
        },
      )
    );
  }
}
