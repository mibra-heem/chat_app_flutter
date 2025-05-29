import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/typedef.dart';

abstract class BaseApiService {
  Future<void> get({required String url, SSMap? headers});
  Future<void> post({
    required String url,
    required DataMap? body,
    required String? serverAccessToken,
    bool needBaseUrl = false,
  });
}

class ApiClient implements BaseApiService {
  const ApiClient({required String baseUrl}) : _baseUrl = baseUrl;

  final String _baseUrl;

  @override
  Future<void> get({required String url, SSMap? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<DataMap> post({
    required String url,
    required DataMap? body,
    required String? serverAccessToken,
    bool needBaseUrl = false,
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
        return jsonDecode(res.body) as DataMap;
      }

      return {'message': 'No Data found.', 'statusCode': res.statusCode};
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    }
  }
}
