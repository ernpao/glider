import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_serverless/data/codera_portal_data_layer.dart';

void main() {
  final api = CoderaPortalClient();
  test("CoderaPortalAPI Index", () async {
    final response = await api.index().resolve();
    response.debug();
    assert(response.success);
  });

  test("CoderaPortalAPI Login", () async {
    final response = await api.login("ernpao", "Zero1928!").resolve();
    response.debug();
    assert(response.success);
  });

  test("CoderaPortalAPI Verify", () async {
    var response = await api.login("ernpao", "Zero1928!").resolve();
    final token = response.body.get("accessToken");
    print(token);
    response = await api.verify(token).resolve();
    response.debug();
    assert(response.success);
  });
}
