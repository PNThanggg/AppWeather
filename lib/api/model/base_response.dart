import 'package:dio/dio.dart';

class BaseResponse<T extends BaseResponseData> {
  var code;
  dynamic data;
  dynamic rawData;
  String? message;
  bool? result;

  Response? dioResponse;

  BaseResponse({
    this.code,
    this.data,
    this.rawData,
    this.message,
    this.result,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, Function? create) {
    return BaseResponse<T>(
      code: json['code'],
      rawData: json['rawData'],
      data: create != null ? create(json['data']) : json['data'],
      message: json['message'] as String,
      result: json['result'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'data': data.toJson,
        'message': message,
        'result': result,
      };
}

abstract class BaseResponseData {
  Map<String, dynamic> toJson();
}
