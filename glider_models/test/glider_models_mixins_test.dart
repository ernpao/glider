import 'package:flutter_test/flutter_test.dart';
import 'package:glider_models/glider_models.dart';

void main() {
  test("Glider Models Mixins Test - DateTimeFormatter", () async {
    const String sampleTime = "2021-07-10 20:36:16.716579";
    final DateTime dt = DateTime.parse(sampleTime);
    assert(m.formatTime(dt) == "8:36:16 PM");
    assert(m.formatDate(dt) == "July 10, 2021");
    assert(m.formatDateTime(dt) == "July 10, 2021 8:36:16 PM");
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
    with DateTimeFormatter, EmailAddress, MobileNumber, EnumToString {
  @override
  final String email;

  @override
  final String mobileNumber;

  MixinsTester({
    required this.email,
    required this.mobileNumber,
  });
}
