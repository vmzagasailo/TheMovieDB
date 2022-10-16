import 'package:the_movie_db/library/secure_storage/secure_storage.dart';

abstract class _Keys {
  static const sessionId = 'session-id';
  static const accountId = 'account-id';
}

abstract class SessionDataProvider {
  Future<String?> getSessionId();
  Future<void> setSessionId(String value);
  Future<void> deleteSessionId();
  Future<int?> getAccountId();
  Future<void> setAccountId(int value);
  Future<void> deleteAccountId();
}

class SessionDataProviderDefault implements SessionDataProvider {
  final SecureStorage secureStorage;

  const SessionDataProviderDefault(this.secureStorage);

  @override
  Future<String?> getSessionId() => secureStorage.read(key: _Keys.sessionId);

  @override
  Future<void> setSessionId(String value) =>
      secureStorage.write(key: _Keys.sessionId, value: value);

  @override
  Future<void> deleteSessionId() => secureStorage.delete(key: _Keys.sessionId);

  @override
  Future<int?> getAccountId() async {
    final id = await secureStorage.read(key: _Keys.accountId);
    return id != null ? int.tryParse(id) : null;
  }

  @override
  Future<void> setAccountId(int value) =>
      secureStorage.write(key: _Keys.accountId, value: value.toString());

  @override
  Future<void> deleteAccountId() => secureStorage.delete(key: _Keys.accountId);
}
