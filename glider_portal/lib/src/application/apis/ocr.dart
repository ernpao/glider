import 'package:glider/glider.dart';

abstract class OcrInterface {}

class OcrWebAPI extends WebClient implements OcrInterface {
  OcrWebAPI() : super(host: "portal.codera.tech", useHttps: true);
}
