import 'package:glider/glider.dart';

abstract class CommerceInterface {}

class PortalCommerceAPI extends WebClient implements CommerceInterface {
  PortalCommerceAPI()
      : super(
          host: "commerce.portal.codera.tech",
          useHttps: true,
        );
}
