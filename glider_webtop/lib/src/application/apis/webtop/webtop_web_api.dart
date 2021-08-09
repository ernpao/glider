import 'package:glider/glider.dart';

import 'webtop_interface.dart';

class WebtopWebAPI extends WsAPI implements WebtopInterface {
  WebtopWebAPI({
    required String host,
    required int port,
    required int socketPort,
  }) : super(
          host: host,
          httpPort: port,
          webSocketPort: socketPort,
          useHttps: false,
          useWss: false,
        );
}
