import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glider_portal/glider_portal.dart';

// final api = ChatEngineAPI(username: "ernpao@g.com", secret: "password");
final privateAPI = ChatEnginePrivateAPI();
final api = ChatEngineAPI(username: "ernpao@g.com", secret: "password");
void main() {
  test("Chat Engine API", () async {});

  test("Chat Engine API - Test Get, Create, and Delete Chats", () async {
    var chats = <Chat>[];

    WebResponse response = await api.createChat("Test Chat");
    assert(response.isSuccessful);

    response = await api.getMyChats();
    chats = Chat.chatListFromWebResponse(response);
    assert(chats.isNotEmpty);

    for (final chat in chats) {
      response = await api.sendChatMessage(chat.id, text: "Hello!");
      assert(response.isSuccessful);

      /// Only delete chats if it was created by
      /// the same user.
      if (chat.admin.username == api.username) {
        final response = await api.deleteChat(chat.id);
        assert(response.isSuccessful);
      }
    }
  });

  test("Chat Engine API - Test Authenticate", () async {
    final response = await privateAPI.authenticate("ernpao@g.com", "password");
    assert(response.isSuccessful);
  });

  test("Chat Engine API - Test Create and Delete User", () async {
    const secret = "password";

    final response = await privateAPI.createUser(
      username: "test-${DateTime.now().toIso8601String()}",
      secret: secret,
      firstName: "test",
      lastName: "user",
    );

    debugPrintSynchronously(response.bodyAsJson()?.prettify());
    assert(response.isSuccessful);

    final user = Person(response.bodyAsJson()!);

    final authenticateResponse =
        await privateAPI.authenticate(user.username, secret);
    assert(authenticateResponse.isSuccessful);

    final deleteResponse = await privateAPI.deleteUser(user.id);
    debugPrintSynchronously(deleteResponse.bodyAsJson()?.prettify());
    assert(deleteResponse.isSuccessful);
  });

  test("Chat Engine API - Message Parsing", () async {
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

    final messages = Message.parseList(chatMessageListString);
    final message = messages[0];

    assert(message.text == "Hello world!");

    final sender = message.sender;
    assert(sender.isOnline == false);
    assert(sender.username == "John_Doe");
    assert(sender.firstName == "John");
    assert(sender.lastName == "Doe");
  });
  test("Chat Engine API - Person Parsing", () async {
    const userJsonString = ''
        '{'
        ' "username": "John_Doe",'
        ' "first_name": "John",'
        ' "last_name": "Doe",'
        ' "avatar": null,'
        ' "is_online": false'
        '}';

    final user = Person.parse(userJsonString);
    assert(user.isOnline == false);
    assert(user.username == "John_Doe");
    assert(user.firstName == "John");
    assert(user.lastName == "Doe");
    assert(
      user.avatar == null,
    );
  });

  test("Chat Engine API - Get Chat Details", () async {
    WebResponse response = await api.createChat("This is a test chat");
    assert(response.isSuccessful);
    final newChat = Chat(response.bodyAsJson()!);
    response = await api.getChatDetails(newChat.id);
    final fetchedChat = Chat(response.bodyAsJson()!);
    assert(fetchedChat.title == newChat.title);
    assert(response.isSuccessful);
    response = await api.deleteChat(fetchedChat.id);
    assert(response.isSuccessful);
  });
}
