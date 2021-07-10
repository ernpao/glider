import 'package:flutter_test/flutter_test.dart';
import 'package:glider_models/glider_models.dart';

void main() {
  test("Glider Models Mixins Test - DateTimeFormatter", () async {
    print(m.formatDateTime(DateTime.now()));
    print(m.formatTime(DateTime.now()));
    print(m.formatDate(DateTime.now()));
  });

  test("Glider Models Mixins Test - EnumToString", () async {
    assert(m.enumToString(SampleEnum.enum1) == "enum1");
    assert(m.enumToString(SampleEnum.enum2) == "enum2");
  });
}

/// Instance of the MixinsTester class.
final MixinsTester m = MixinsTester(
  email: "test@email.com",
  mobileNumber: "09123456789",
);

enum SampleEnum {
  enum1,
  enum2,
}

/// A class with all the mixins for testing purposes.
class MixinsTester
    with
        DateTimeFormatter,
        EmailAddress,
        MobileNumber,
        DebugConsoleLogging,
        EnumToString {
  @override
  final String email;

  @override
  final String mobileNumber;

  MixinsTester({
    required this.email,
    required this.mobileNumber,
  });
}
