import 'package:flutter_test/flutter_test.dart';
import 'package:prueba/features/auth/data/local_auth_service.dart';

void main() {
  const authService = LocalAuthService();

  test('acepta las credenciales configuradas', () {
    final result = authService.authenticate(
      username: 'Admin',
      password: 'Admin',
    );

    expect(result, isTrue);
  });

  test('rechaza credenciales incorrectas', () {
    final result = authService.authenticate(
      username: 'admin',
      password: 'Admin',
    );

    expect(result, isFalse);
  });
}
