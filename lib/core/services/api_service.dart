import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/typedef.dart';

abstract class BaseApiService {
  Future<void> get({required String url, String? serverAccessToken});
  Future<SDMap> post({
    required String url,
    required SDMap? body,
    String? serverAccessToken,
    bool needBaseUrl = true,
  });
}

class ApiService implements BaseApiService {
  const ApiService({required String baseUrl}) : _baseUrl = baseUrl;

  final String _baseUrl;

  @override
  Future<void> get({required String url, String? serverAccessToken}) async {
    final uri = Uri.parse(_baseUrl + url);

    final res = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessToken',
      },
    );

    try {
      if (res.statusCode == 200) {
        debugPrint('Request was successfull.');
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<SDMap> post({
    required String url,
    required SDMap? body,
    String? serverAccessToken,
    bool needBaseUrl = true,
  }) async {
    final uri = Uri.parse(needBaseUrl ? _baseUrl + url : url);

    final res = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessToken',
      },
    );

    try {
      if (res.statusCode == 200) {
        debugPrint('Notification Sent Successfully.');
        return jsonDecode(res.body) as SDMap;
      }

      return {'message': 'No Data found.', 'statusCode': res.statusCode};
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    }
  }
}
