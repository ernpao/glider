import 'package:flutter_test/flutter_test.dart';
import 'package:glider_portal/glider_portal.dart';

void main() {
  final client = PortalWebAPI();
  test("Portal API Index", () async {
    final response = await client.index();
    assert(response.success);
  });

  test("Portal API Login", () async {
    final response = await client.login("ernpao", "Zero1928!");
    assert(response.isSuccessful);
  });

  test("Portal API Verify", () async {
    var response = await client.login("ernpao", "Zero1928!");
    assert(response.isSuccessful);
    final user = JSON.copyAs<PortalUser>(response.body, PortalUser());
    final token = user.accessToken;
    response = await client.verify(token);
    assert(response.isSuccessful);
  });
}
