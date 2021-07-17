import 'package:glider/glider.dart';

abstract class PortalOCRInterface extends WebClient {
  PortalOCRInterface()
      : super(
          host: "portal.codera.tech",
          useHttps: true,
        );
}

class PortalOCRAPI extends PortalOCRInterface {}
