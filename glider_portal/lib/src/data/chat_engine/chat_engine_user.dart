import 'package:glider/glider.dart';

import 'person.dart';

class ChatEngineUser extends Person with Secret implements AuthenticatedUser {
  ChatEngineUser(JSON data, this.secret) : super(data);

  @override
  final String secret;
}
