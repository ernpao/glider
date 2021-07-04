import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_serverless/domain/codera_portal_domain_layer.dart';

void main() {
  final api = CoderaPortal();
  test("CoderaPortal Login", () async {
    final user = await api.login("ernpao", "Zero1928!");
    user?.debug();
    assert(user != null);
    assert(user?.username == "ernpao");
  });
}
