import 'package:flutter_test/flutter_test.dart';
import 'package:glider_portal/glider_portal.dart';

void main() {
  final api = PortalAuthWebAPI();
  test("Portal API Index", () async {
    final result = await api.index();
    assert(result.isSuccessful);
  });

  test("Portal API Login", () async {
    // Test valid user login - should be successful
    var response = await api.logIn("ernpao", "Zero1928!");
    assert(response.isSuccessful);

    // Test invalid user login - should be unsuccessful
    response = await api.logIn("", "");
    assert(response.isNotSuccessful);
  });

  test("Portal API Verify", () async {
    var response = await api.logIn("ernpao", "Zero1928!");
    var body = response.bodyAsJson;
    assert(response.isSuccessful);

    final user = PortalUserParser().parseFrom<JSON>(body);

    final token = user.accessToken;
    response = await api.verify(token);
    assert(response.isSuccessful);
  });
}
