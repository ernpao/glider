import 'package:flutter_test/flutter_test.dart';
import 'package:glider_codera/glider_codera.dart';

void main() {
  final client = CoderaPortalClient();
  test("CoderaPortalAPI Index", () async {
    final response = await client.index();
    assert(response.success);
  });

  test("CoderaPortalAPI Login", () async {
    final response = await client.login("ernpao", "Zero1928!");
    assert(response.success);
  });

  test("CoderaPortalAPI Verify", () async {
    var response = await client.login("ernpao", "Zero1928!");
    final token = response.body.get("accessToken");
    response = await client.verify(token).resolve();
    assert(response.success);
  });
}
