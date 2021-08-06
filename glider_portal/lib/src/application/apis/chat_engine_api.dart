import 'package:flutter/foundation.dart';
import 'package:glider/glider.dart';

import 'web_interfaces/web_interfaces.dart';

@protected
mixin ChatEnginePaths {
  final String usersPath = "/users";
  String usersPathWithUserId(int userId) => "$usersPath/$userId/";

  late final String mePath = "$usersPath/me/";

  final String chatsPath = "/chats";
  String latestChatsPath(int chatCount) => "$chatsPath/latest/$chatCount";
  String chatsPathWithChatId(int chatId) => "$chatsPath/$chatId/";
  String chatsPathWithPeople(int chatId) => "$chatsPath/$chatId/people/";
  String chatsPathWithOthers(int chatId) => "$chatsPath/$chatId/others/";

  String typingPath(int chatId) => "$chatsPath/$chatId/typing/";

  String messagesPath(int chatId) => "$chatsPath/$chatId/messages";

  String messagesPathWithMessageId(int chatId, int messageId) {
    return "${messagesPath(chatId)}/$messageId";
  }

  String latestMessagesPath(int chatId, int chatCount) {
    return "${messagesPath(chatId)}/latest/$chatCount";
  }
}

@protected
mixin _RequestHelper {
  final String chatEngineProjectId = "ab2204ec-10bc-4807-9f61-ecf012787ced";

  static final _webClient = WebClient(
    host: "api.chatengine.io",
    useHttps: true,
  );

  T createUserRequest<T extends WebRequest>(
      String? path, String username, String secret) {
    final request = _webClient.createRequest<T>(path);
    request.withHeader("Project-ID", chatEngineProjectId);
    request.withHeader("User-Name", username);
    request.withHeader("User-Secret", secret);
    request.withJsonContentType();
    return request;
  }

  T createPrivateRequest<T extends WebRequest>(
    String? path,
    String privateKey,
  ) {
    final request = _webClient.createRequest<T>(path);
    request.withHeader("PRIVATE-KEY", privateKey);
    return request;
  }
}

class ChatEnginePrivateAPI
    with ChatEnginePaths, _RequestHelper
    implements AuthInterface, ChatEnginePrivateInterface {
  static const String _privateKey = "d243c478-85ad-49d5-80da-f4673bfda05d";

  @override
  Future<WebResponse> createUser({
    required String username,
    required String secret,
    String? firstName,
    String? lastName,
  }) {
    final request = createPrivateRequest<POST>(usersPath, _privateKey);

    final body = JSON()
      ..setProperty("username", username)
      ..setProperty("secret", secret);

    if (firstName != null) body.setProperty("first_name", firstName);
    if (lastName != null) body.setProperty("last_name", lastName);

    request.withBody(body);

    return request.send();
  }

  @override
  Future<WebResponse> getUser(int userId) {
    final request = createPrivateRequest<GET>(
      usersPathWithUserId(userId),
      _privateKey,
    );
    return request.send();
  }

  @override
  Future<WebResponse> getUsers() {
    final request = createPrivateRequest<GET>(usersPath, _privateKey);
    return request.send();
  }

  @override
  Future<WebResponse> deleteUser(int userId) {
    final request = createPrivateRequest<DELETE>(
      usersPathWithUserId(userId),
      _privateKey,
    );
    return request.send();
  }

  @override
  Future<WebResponse> authenticate(String username, String secret) {
    return createUserRequest<GET>(mePath, username, secret).send();
  }

  @override
  Future<WebResponse> logIn(
    String username,
    String password,
  ) =>
      authenticate(username, password);

  @override
  Future<WebResponse> signUp(
    String username,
    String password, {
    String? firstName,
    String? lastName,
  }) =>
      createUser(
        username: username,
        secret: password,
        firstName: firstName,
        lastName: lastName,
      );
}

class ChatEngineAPI
    with ChatEnginePaths, _RequestHelper
    implements ChatEngineInterface {
  ChatEngineAPI({
    required this.username,
    required this.secret,
  });

  @override
  String get projectId => chatEngineProjectId;

  @override
  final String secret;

  @override
  final String username;

  @override
  Future<WebResponse> addChatMember(int chatId, String usernameToAdd) =>
      createUserRequest<POST>("/chats/$chatId/people/", username, secret)
          .send();

  @override
  Future<WebResponse> createChat(String title, {bool isDirectChat = false}) {
    final body = JSON()
      ..setProperty("title", title)
      ..setProperty("is_direct_chat", isDirectChat);

    final post = createUserRequest<POST>(chatsPath, username, secret);
    post.withBody(body);

    return post.send();
  }

  @override
  Future<WebResponse> deleteChat(int chatId) => createUserRequest<DELETE>(
        chatsPathWithChatId(chatId),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getChatDetails(int chatId) => createUserRequest<GET>(
        chatsPathWithChatId(chatId),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getMyChats() => createUserRequest<GET>(
        chatsPath,
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getMyLatestChats(int chatCount) => createUserRequest<GET>(
        latestChatsPath(chatCount),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getMyLatestChatsBeforeTime(
    DateTime before,
    int chatCount,
  ) {
    final body = JSON()..setProperty("before", before.toIso8601String());
    final put = createUserRequest<PUT>(
      latestChatsPath(chatCount),
      username,
      secret,
    );
    put.withBody(body);
    return put.send();
  }

  @override
  Future<WebResponse> getOrCreateChat({
    String? title,
    List<String>? usernames,
    bool? isDirectChat,
  }) {
    final body = JSON();
    if (usernames != null) body.setProperty("usernames", usernames);
    if (title != null) body.setProperty("title", title);
    if (isDirectChat != null) body.setProperty("is_direct_chat", isDirectChat);

    final request = createUserRequest<PUT>(chatsPath, username, secret);
    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> updateChatDetails(
    int chatId, {
    String? newTitle,
    bool? isDirectChat,
  }) {
    final body = JSON();
    if (newTitle != null) body.setProperty("title", newTitle);
    if (isDirectChat != null) body.setProperty("is_direct_chat", isDirectChat);

    final request = createUserRequest<PATCH>(
      chatsPathWithChatId(chatId),
      username,
      secret,
    );

    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> getChatMembers(int chatId) {
    final request = createUserRequest<GET>(
      chatsPathWithPeople(chatId),
      username,
      secret,
    );
    return request.send();
  }

  @override
  Future<WebResponse> getOtherUsers(int chatId) {
    final request = createUserRequest<GET>(
      chatsPathWithOthers(chatId),
      username,
      secret,
    );
    return request.send();
  }

  @override
  Future<WebResponse> removeChatMember(int chatId, String usernameToRemove) {
    final body = JSON()..setProperty("username", usernameToRemove);
    final request = createUserRequest<PUT>(
      chatsPathWithPeople(chatId),
      username,
      secret,
    );
    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> searchOtherUsers(int chatId, String search) {
    final body = JSON()..setProperty("search", search);
    final request = createUserRequest<POST>(
      chatsPathWithOthers(chatId),
      username,
      secret,
    );
    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> deleteMessage(int chatId, int messageId) =>
      createUserRequest<DELETE>(
        messagesPathWithMessageId(chatId, messageId),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getChatMessages(int chatId) => createUserRequest<GET>(
        messagesPath(chatId),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getLatestChatMessages(int chatId, int chatCount) =>
      createUserRequest<GET>(
        latestMessagesPath(chatId, chatCount),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getMessageDetails(int chatId, int messageId) =>
      createUserRequest<GET>(
        messagesPathWithMessageId(chatId, messageId),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> readMessage(int chatId, int lastReadMessageId) {
    final body = JSON()..setProperty("last_read", lastReadMessageId);
    final request = createUserRequest<PATCH>(
      chatsPathWithPeople(chatId),
      username,
      secret,
    );
    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> sendChatMessage(
    int chatId, {
    String? text,
    List<String>? attachmentUrls,
    JSON? customJson,
  }) {
    final body = JSON();

    if (text != null) body.setProperty("text", text);
    if (attachmentUrls != null) {
      body.setProperty("attachment_urls", attachmentUrls);
    }
    if (customJson != null) body.setProperty("custom_json", customJson);

    final request = createUserRequest<POST>(
      messagesPath(chatId),
      username,
      secret,
    );

    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> updateMessageDetails(int chatId, int messageId,
      {String? newText}) {
    final body = JSON();

    if (newText != null) body.setProperty("text", newText);

    final request = createUserRequest<PATCH>(
      messagesPath(chatId),
      username,
      secret,
    );

    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> userIsTyping(int chatId) => createUserRequest<PATCH>(
        typingPath(chatId),
        username,
        secret,
      ).send();
}
