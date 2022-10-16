import 'package:the_movie_db/configuration/configuration.dart';
import 'package:the_movie_db/domain/api_client/network_client.dart';

abstract class AuthApiClient {
  Future<String> auth({
    required String userName,
    required String password,
  });
}

class AuthApiClientDefault implements AuthApiClient {
  final NetworkClient networkClient;

  const AuthApiClientDefault(this.networkClient);

  @override
  Future<String> auth({
    required String userName,
    required String password,
  }) async {
    final token = await _makeToken();
    final validateToken = await _validateUser(
        userName: userName, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validateToken);

    return sessionId;
  }

  Future<String> _makeToken() async {
    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = networkClient.get('/authentication/token/new', parser,
        <String, dynamic>{'api_key': Configuration.apiKey});
    return result;
  }

  Future<String> _validateUser({
    required String userName,
    required String password,
    required String requestToken,
  }) async {
    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final bodyParameters = <String, dynamic>{
      'username': userName,
      'password': password,
      'request_token': requestToken
    };
    final result = networkClient.post(
      '/authentication/token/validate_with_login',
      parser,
      bodyParameters,
      <String, dynamic>{'api_key': Configuration.apiKey},
    );

    return result;
  }

  Future<String> _makeSession({required String requestToken}) async {
    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
      return sessionId;
    }

    final bodyParameters = <String, dynamic>{
      'request_token': requestToken,
    };
    final result = networkClient.post(
      '/authentication/session/new',
      parser,
      bodyParameters,
      <String, dynamic>{'api_key': Configuration.apiKey},
    );

    return result;
  }
}
