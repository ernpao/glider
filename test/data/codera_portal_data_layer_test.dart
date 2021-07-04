import 'package:flutter_test/flutter_test.dart';
import 'package:glider/data/codera_portal_data_layer.dart';

void main() {
  final client = CoderaPortalClient();
  test("CoderaPortalAPI Index", () async {
    final response = await client.index().resolve();
    response.debug();
    assert(response.success);
  });

  test("CoderaPortalAPI Login", () async {
    final response = await client.login("ernpao", "Zero1928!").resolve();
    response.debug();
    assert(response.success);
  });

  test("CoderaPortalAPI Verify", () async {
    var response = await client.login("ernpao", "Zero1928!").resolve();
    final token = response.body.get("accessToken");
    print(token);
    response = await client.verify(token).resolve();
    response.debug();
    assert(response.success);
  });
}
