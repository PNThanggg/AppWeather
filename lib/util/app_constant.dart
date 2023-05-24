import 'dart:ui';

import '../assets/app_image.dart';

class AppConstant {
  static final availableLocales = [
    const Locale('vi', 'VN'),
    const Locale('en', 'US')
  ];

  static const double DEFAULT_LATITUDE = 21.028511;
  static const double DEFAULT_LONGITUDE = 105.804817;

  static const List listWMOCode = [
    {
      'code': 0,
      'desEN': 'Clear sky',
      'desVN': 'Bầu trời quang đãng',
      'image': AppImage.weather_00,
      'image2': AppImage.weather_00_n
    },
    {
      'code': 1,
      'desEN': 'Mainly clear',
      'desVN': 'Trời quang',
      'image': AppImage.weather_01,
      'image2': AppImage.weather_01_n
    },
    {
      'code': 2,
      'desEN': 'Partly cloudy',
      'desVN': 'Mây mù',
      'image': AppImage.weather_02,
      'image2': AppImage.weather_02_n
    },
    {
      'code': 3,
      'desEN': 'Overcast',
      'desVN': 'U ám',
      'image': AppImage.weather_03
    },
    {
      'code': 45,
      'desEN': 'Fog',
      'desVN': 'Sương mù',
      'image': AppImage.weather_45
    },
    {
      'code': 48,
      'desEN': 'Depositing rime fog',
      'desVN': 'Đọng sương',
      'image': AppImage.weather_00
    },
    {
      'code': 51,
      'desEN': 'Drizzle light',
      'desVN': 'Mưa phùn nhẹ',
      'image': AppImage.weather_51
    },
    {
      'code': 53,
      'desEN': 'Drizzle moderate',
      'desVN': 'Mưa phùn vừa',
      'image': AppImage.weather_53
    },
    {
      'code': 55,
      'desEN': 'Drizzle dense intensity',
      'desVN': 'Mưa phùn sai hạt',
      'image': AppImage.weather_55
    },
    {
      'code': 56,
      'desEN': 'Freezing Drizzle light',
      'desVN': 'Mưa phùn lạnh nhẹ',
      'image': AppImage.weather_00
    },
    {
      'code': 57,
      'desEN': 'Freezing Drizzle dense intensity',
      'desVN': 'Mưa phùn lạnh sai hạt',
      'image': AppImage.weather_00
    },
    {
      'code': 61,
      'desEN': 'Rain slight',
      'desVN': 'Mưa nhẹ',
      'image': AppImage.weather_61
    },
    {
      'code': 63,
      'desEN': 'Rain moderate',
      'desVN': 'Mưa vừa',
      'image': AppImage.weather_63
    },
    {
      'code': 65,
      'desEN': 'Rain heavy intensity',
      'desVN': 'Mưa to',
      'image': AppImage.weather_00
    },
    {
      'code': 66,
      'desEN': 'Freezing Rain light',
      'desVN': 'Mưa lạnh nhẹ',
      'image': AppImage.weather_66
    },
    {
      'code': 67,
      'desEN': 'Freezing Rain: heavy intensity',
      'desVN': 'Mưa lạnh: nặng hạt',
      'image': AppImage.weather_00
    },
    {
      'code': 71,
      'desEN': 'Snow fall slight',
      'desVN': 'Tuyết rơi nhẹ',
      'image': AppImage.weather_00
    },
    {
      'code': 73,
      'desEN': 'Snow fall moderate',
      'desVN': 'Tuyết rơi trung bình',
      'image': AppImage.weather_00
    },
    {
      'code': 75,
      'desEN': 'Snow fall heavy intensity',
      'desVN': 'Tuyết rơi nặng hạt',
      'image': AppImage.weather_00
    },
    {
      'code': 77,
      'desEN': 'Snow grains',
      'desVN': 'Tuyết rơi lớn',
      'image': AppImage.weather_00
    },
    {
      'code': 80,
      'desEN': 'Rain showers slight',
      'desVN': 'Mưa rào nhẹ',
      'image': AppImage.weather_00
    },
    {
      'code': 81,
      'desEN': 'Rain showers moderate',
      'desVN': 'Mưa rào trung bình',
      'image': AppImage.weather_00
    },
    {
      'code': 82,
      'desEN': 'Rain showers violent',
      'desVN': 'Mưa rào nặng hạt',
      'image': AppImage.weather_00
    },
    {
      'code': 85,
      'desEN': 'Snow showers slight',
      'desVN': 'Mưa tuyết nhẹ',
      'image': AppImage.weather_00
    },
    {
      'code': 86,
      'desEN': 'Snow showers heavy',
      'desVN': 'Mưa tuyết nặng hạt',
      'image': AppImage.weather_00
    },
    {
      'code': 95,
      'desEN': 'Thunderstorm',
      'desVN': 'Dông bão',
      'image': AppImage.weather_95
    },
    {
      'code': 96,
      'desEN': 'Thunderstorm with slight',
      'desVN': 'Giông bão nhẹ',
      'image': AppImage.weather_00
    },
    {
      'code': 99,
      'desEN': 'Thunderstorm with heavy hail',
      'desVN': 'Giông bão kèm mưa đá',
      'image': AppImage.weather_00
    },
  ];
}
