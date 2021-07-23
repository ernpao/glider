import 'package:glider/glider.dart';

abstract class OcrInterface {}

class OcrWebClient extends WebClient implements OcrInterface {
  OcrWebClient() : super(host: "portal.codera.tech", useHttps: true);
}
