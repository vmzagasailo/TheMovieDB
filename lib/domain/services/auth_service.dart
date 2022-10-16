import 'package:the_movie_db/domain/api_client/account_api_client.dart';
import 'package:the_movie_db/domain/api_client/auth_api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';

abstract class AuthService {
  Future<bool> isAuth();

  Future<void> login(String login, String password);

  Future<void> logout();
}

class AuthServiceDefault implements AuthService {
  final AccountApiClient accountApiClient;
  final AuthApiClient authApiClient;
  final SessionDataProvider sessionDataProvider;

  const AuthServiceDefault({
    required this.accountApiClient,
    required this.authApiClient,
    required this.sessionDataProvider,
  });

  @override
  Future<bool> isAuth() async {
    final sessionId = await sessionDataProvider.getSessionId();
    final isAuth = sessionId != null;
    return isAuth;
  }

  @override
  Future<void> login(String login, String password) async {
    final sessionId = await authApiClient.auth(
      userName: login,
      password: password,
    );

    final accountId = await accountApiClient.getAccountInfo(sessionId);
    await sessionDataProvider.setSessionId(sessionId);
    await sessionDataProvider.setAccountId(accountId);
  }

  @override
  Future<void> logout() async {
    await sessionDataProvider.deleteSessionId();
    await sessionDataProvider.deleteAccountId();
  }
}
