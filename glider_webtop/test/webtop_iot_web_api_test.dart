import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glider_webtop/glider_webtop.dart';

void main() {
  final api = IotWebAPI(
    host: "192.168.100.191",
    port: 6767,
    socketPort: 6868,
  );

  test("Get WsData Senders", () async {
    var result = await api.getWsDataSenders();

    for (var res in result) {
      debugPrint(res);
    }
  });
}
