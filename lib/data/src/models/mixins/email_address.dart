import 'package:hover/widgets.dart';

/// A mixin that gives an object the
/// [email] string property.
mixin EmailAddress {
  String get email;
  bool get emailIsValid =>
      HoverFluentValidator().validateAsEmail().validate(email) == null;
}
