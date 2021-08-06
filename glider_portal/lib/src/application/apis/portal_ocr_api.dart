import 'package:glider/glider.dart';

abstract class OcrInterface {}

class PortalOcrAPI extends WebClient implements OcrInterface {
  PortalOcrAPI() : super(host: "portal.codera.tech", useHttps: true);
}
