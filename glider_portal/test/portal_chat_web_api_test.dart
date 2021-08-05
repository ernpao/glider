import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glider_portal/glider_portal.dart';

void main() {
  test("Portal Chat", () async {});

  test("Portal Chat - Test Authenticate", () async {
    final api = ChatEngineAPI();
    const secret = "password";
    final response = await api.authenticate("ernpao", secret);
    assert(response.isSuccessful);
  });

  test("Portal Chat - Test Chat Engine Create and Delete User", () async {
    final api = ChatEngineAPI();

    const secret = "password";

    final response = await api.createUser(
      username: "test",
      secret: secret,
      firstName: "test",
      lastName: "user",
    );

    debugPrintSynchronously(response.bodyAsJson()?.prettify());
    assert(response.isSuccessful);

    final user = ChatUser(response.bodyAsJson()!);

    final authenticateResponse = await api.authenticate(user.username, secret);
    assert(authenticateResponse.isSuccessful);

    final deleteResponse = await api.deleteUser(user.id);
    debugPrintSynchronously(deleteResponse.bodyAsJson()?.prettify());
    assert(deleteResponse.isSuccessful);
  });

  test("Portal Chat - ChatMessage Parsing", () async {
    const chatMessageListString = ''
        '['
        ' {'
        '   "id": 941,'
        '     "sender": {'
        '     "username": "John_Doe",'
        '     "first_name": "John",'
        '     "last_name": "Doe",'
        '     "avatar": null,'
        '     "custom_json": {},'
        '     "is_online": false'
        '   },'
        ' "created": "2021-05-04 15:51:35.540919+00:00",'
        ' "attachments": [],'
        ' "sender_username": "John_Doe",'
        ' "text": "Hello world!",'
        ' "custom_json": {'
        '   "gif": "https://giphy.com/clips/ufc-4eZuG5kNYvDrGc6gYk"'
        '   }'
        ' }'
        ']';

    final messages = ChatMessage.parseList(chatMessageListString);
    final message = messages[0];

    assert(message.created.year == 2021);
    assert(message.text == "Hello world!");

    final sender = message.sender;
    assert(sender.isOnline == false);
    assert(sender.username == "John_Doe");
    assert(sender.firstName == "John");
    assert(sender.lastName == "Doe");
  });
  test("Portal Chat - ChatUser Parsing", () async {
    const userJsonString = ''
        '{'
        ' "username": "John_Doe",'
        ' "first_name": "John",'
        ' "last_name": "Doe",'
        ' "avatar": null,'
        ' "is_online": false'
        '}';

    final user = ChatUser.parse(userJsonString);
    assert(user.isOnline == false);
    assert(user.username == "John_Doe");
    assert(user.firstName == "John");
    assert(user.lastName == "Doe");
    assert(
      user.avatar == null,
    );
  });

  test("Portal Chat - ChatMessage Parsing", () async {
    const messageJsonString = ''
        '{'
        ' "id": 353,'
        ' "sender": {'
        '   "username": "wendy_walker",'
        '   "first_name": null,'
        '   "last_name": null,'
        '   "avatar": null,'
        '   "is_online": false'
        ' },'
        ' "created": "2021-01-28 02:45:27.747970+00:00",'
        ' "attachments": [],'
        ' "text": "Hello world!"'
        '}';

    final parsedMessage = ChatMessage.parse(messageJsonString);
    final parsedSender = parsedMessage.sender;
    assert(parsedMessage.id == 353);
    assert(parsedMessage.attachments.isEmpty);
    assert(parsedSender.username == "wendy_walker");
    assert(parsedSender.avatar == null);
  });
}
