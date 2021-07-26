import 'package:glider/glider.dart';

abstract class PortalOcrInterface {}

class PortalOcrWebAPI extends WebClient implements PortalOcrInterface {
  PortalOcrWebAPI() : super(host: "portal.codera.tech", useHttps: true);
}
