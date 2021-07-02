library codera_portal_domain;

import 'package:flutter_with_serverless/data/src/data_layer.dart';

class CoderaPortalUser with EmailAddress {
  final String username;
  final String email;
  final String accessToken;
  CoderaPortalUser(
    this.username,
    this.email,
    this.accessToken,
  );
}
