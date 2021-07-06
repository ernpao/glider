import '../data/webtop_data_layer.dart';

class Webtop {
  final WebtopClient api = WebtopClient(
    host: "192.168.100.191",
    port: 6767,
    socketPort: 6868,
  );
}
