import 'package:test_ease/api_constants/token_role.dart';
import 'package:test_ease/providers/base_view_model.dart';

class TokenProvider extends BaseViewModel {
  TokenRole _role = TokenRole();

  String? _tokenRole;
  String? get tokenRole => _tokenRole;

  Future<void> loadRole() async {
    await runWithLoader(() async {
    _tokenRole = await _role.getTokenRole();
    });
  }
}
