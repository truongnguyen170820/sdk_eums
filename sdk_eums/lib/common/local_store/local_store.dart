abstract class LocalStore {
  Future<bool> hasAuthenticated();

  Future setAccessToken(String accessToken);

  Future<String> getAccessToken();

  Future setLoggedAccount(dynamic account);

  Future<dynamic> getLoggedAccount();

  Future removeCredentials();

  Future<bool> containsKey(String key);

  Future<bool> removeKey(String key);

  Future<bool> clear();

  Future reload();

  Future saveCredentials(String accessToken, dynamic account);

  Future updateLoggedAccount(dynamic account);

  Future<bool> getSaveOrNotCredentials();

  Future<bool> getSaveAdver();

  Future setSaveAdver(bool status);
}
