import 'package:glider/glider.dart';

abstract class ChatEnginePrivateInterface {
  // Users (Private API - requires private key)

  /// This request creates a user belonging to the Project with this Private Key.
  ///
  /// AUTH: These are private API calls. You must authenticate as project admin by setting the PRIVATE-KEY header.
  Future<WebResponse> createUser({
    required String username,
    required String firstName,
    required String lastName,
    required String secret,
  });

  /// This request fetches all the users who belong to a Project matching this Private Key.
  ///
  /// AUTH: These are private API calls. You must authenticate as project admin by setting the PRIVATE-KEY header.
  Future<WebResponse> getUsers();

  // User Details (Private API - requires private key)

  /// This request fetches the user with an ID matching {{user_id}} in the route.
  ///
  /// AUTH: These are private API calls. You must authenticate as project admin by setting the PRIVATE-KEY header
  Future<WebResponse> getUser(int userId);

  /// This request allows you to delete the user with an ID matching {{user_id}} in the route.
  ///
  /// AUTH: These are private API calls. You must authenticate as project admin by setting the PRIVATE-KEY header.
  Future<WebResponse> deleteUser(int userId);

  // My Details (Authenticate)

  /// This request lets your check if your authentication headers are correct and will return the user's data (status == 200) if so.
  Future<WebResponse> authenticate(String username, String secret);
}

abstract class ChatEngineInterface {
  String get username;
  String get secret;
  String get projectId;

  // My Chats

  /// This request creates a new chat, sets you as admin and a member, then returns the newly created chat object.
  Future<WebResponse> createChat(
    String title, {
    bool isDirectChat = false,
  });

  /// This request returns a list of all the chats you belong to.
  Future<WebResponse> getMyChats();

  /// This request gets or creates a chat between the authenticated user and the respective usernames in the `usernames` field.
  ///
  /// You can also add an optional `title` parameter which will match against the chat title too.

  /// If a new chat is created, the "is_direct_chat" field will be applied too, making it a group or direct chat accordingly.
  Future<WebResponse> getOrCreateChat({
    String? title,
    List<String>? usernames,
    bool isDirectChat = false,
  });

  /// This request will get the n latest chats where n is {{chat_count}}.
  ///
  /// Latest is determined by last created message or chat creation time (if no messages yet).
  Future<WebResponse> getMyLatestChats(String username, String secret);

  /// This request takes a "before" date-time attribute, and a {{chat_count}} in the URL route,
  /// and will get the n latest chats before the specified time.
  ///
  /// Latest is determined by last created message or chat creation time (if no messages yet).
  Future<WebResponse> getMyLatestChatsBeforeTime(
    DateTime before, {
    int? count,
  });

  // Chat Details
  // The "Chat Details" requests let you view a chat, update its content, and delete it.
  // PERMISSIONS: You must be involved in the chat to Get and Patch. You must be the chat admin to Delete it.
  // AUTH: You must authenticate as a user belonging to a project by setting PROJECT-ID, USER-NAME and USER-SECRET headers.

  ///This request fetches and returns a chat object's data.
  Future<WebResponse> getChatDetails(int chatId);

  /// This request partially updates and returns a chat's data.
  Future<WebResponse> updateChatDetails(
    int chatId, {
    String? title,
    bool isDirectChat = false,
  });

  /// This message deletes and returns the deleted chat's data.
  Future<WebResponse> deleteChat(int chatId);

  /// Chat Members

  /// This request adds a User object as a chat member to the Chat with id {{chat_id}}.
  Future<WebResponse> addChatMember(int chatId, String usernameToAdd);

  /// This request fetches and returns the User members within the chat {{chat_id}}
  Future<WebResponse> getChatMembers(int chatId);

  /// This request removes a Chat Member from the Chat with ID {{ chat_id }}
  Future<WebResponse> removeChatMember(int chatId, String usernameToRemove);

  /// This request fetches and returns the User members NOT in the chat {{chat_id}}
  /// This request is useful for finding other users to add as chat members.
  Future<WebResponse> getOtherUsers(int chatId);

  Future<WebResponse> searchOtherUsers(int chatId, String search);

  // Messages

  /// This request creates (i.e. sends) a chat message. The message sets this user as Sender and Chat as {{chat_id}}.
  Future<WebResponse> sendChatMessage(
    int chatId, {
    String? text,
    List<String>? attachmentUrls,
    JSON? customJson,
  });

  /// This request fetches and returns all the messages in belonging to Chat ID: {{chat_id}}.
  Future<WebResponse> getChatMessages(int chatId);

  /// This request will get the n latest chat messages in this chat where n is {{chat_count}} and the chat of interest is determined by {{chat_id}}.
  ///
  /// Latest is determined by the creation time of each message.
  Future<WebResponse> getLatestChatMessages(int chatId, int chatCount);

  // Message Details

  /// This request fetches and returns the chat message data belonging to chat {{chat_id}} with a Message ID: {{message_id}}
  Future<WebResponse> getMessageDetails(int chatId, int messageId);

  /// This request partially updates chat message belonging to chat {{chat_id}} with Message ID: {{message_id}}
  Future<WebResponse> updateMessageDetails(
    int chatId,
    int messageId, {
    String? newText,
  });

  /// This request deletes the chat message belonging to chat {{chat_id}} with Message ID: {{message_id}}
  Future<WebResponse> deleteMessage(int chatId, int messageId);

  /// This request sets the Chat Member's last read message as Message {{ message_id }}.
  ///
  /// Message with {{ message_id }} must belong to chat with ID {{ chat_id }}
  Future<WebResponse> readMessage(int chatId, int lastReadMessageId);

  /// This request notifies the server that the user is not typing. This will notify other chat members the user is currently typing.
  Future<WebResponse> userIsTyping(int chatId);
}
