class LocalAuthService {
  const LocalAuthService();

  static const _validUsername = 'Admin';
  static const _validPassword = 'Admin';

  bool authenticate({required String username, required String password}) {
    return username == _validUsername && password == _validPassword;
  }
}
