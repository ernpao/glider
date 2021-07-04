import 'package:flutter_test/flutter_test.dart';
import 'package:glider/data/src/models/mixins.dart';

void main() {
  test("Data Layer Mixins Test - DateTimeFormatter", () async {
    print(m.formatDateTime(DateTime.now()));
    print(m.formatTime(DateTime.now()));
    print(m.formatDate(DateTime.now()));
  });
}

final MixinsTester m = MixinsTester(
  email: "test@email.com",
  mobileNumber: "09123456789",
);

/// A class with all the mixins for testing purposes.
class MixinsTester
    with DateTimeFormatting, EmailAddress, MobileNumber, DebugConsoleLogging {
  @override
  final String email;

  @override
  final String mobileNumber;

  MixinsTester({
    required this.email,
    required this.mobileNumber,
  });
}
