import 'dart:convert';
import 'dart:io';

import 'package:the_movie_db/configuration/configuration.dart';
import 'package:the_movie_db/domain/api_client/api_client_exception.dart';
import 'package:the_movie_db/library/http_client/app_http_client.dart';

abstract class NetworkClient {
  Future<T> get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]);

  Future<T> post<T>(
    String path,
    T Function(dynamic json) parser,
    Map<String, dynamic> bodyParameters, [
    Map<String, dynamic>? urlParameters,
  ]);
}

class NetworkClientDefault implements NetworkClient {
  final AppHttpClient client;

  NetworkClientDefault(this.client);

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('${Configuration.host}$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  @override
  Future<T> get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    final url = _makeUri(path, parameters);

    try {
      final request = await client.getUrl(url);
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.networkError);
    } on ApiClientException {
      rethrow;
    } catch (error) {
      throw ApiClientException(ApiClientExceptionType.otherError);
    }
  }

  @override
  Future<T> post<T>(
    String path,
    T Function(dynamic json) parser,
    Map<String, dynamic> bodyParameters, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    try {
      final url = _makeUri(path, urlParameters);

      final request = await client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));

      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.networkError);
    } on ApiClientException {
      rethrow;
    } catch (error) {
      throw ApiClientException(ApiClientExceptionType.otherError);
    }
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if (response.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientException(ApiClientExceptionType.authError);
      } else if (code == 3) {
        throw ApiClientException(ApiClientExceptionType.sessionExpired);
      } else {
        throw ApiClientException(ApiClientExceptionType.otherError);
      }
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}
