import 'package:glider/glider.dart';

import 'web_interfaces/web_interfaces.dart';

mixin _ChatEnginePaths {
  final String usersPath = "/users";
  String userPathWithUserId(int userId) => "$usersPath/$userId/";
  final String mePath = "/users/me/";
  final String chatsPath = "/chats";
}

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
    return request;
  }

  T createPrivateRequest<T extends WebRequest>(
      String? path, String privateKey) {
    final request = _webClient.createRequest<T>(path)
      ..withHeader("PRIVATE-KEY", privateKey);
    return request;
  }
}

class ChatEnginePrivateAPI
    with _ChatEnginePaths, _RequestHelper
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

    request.withBody(
      JSON()
        ..setProperty("username", username)
        ..setProperty("first_name", firstName)
        ..setProperty("last_name", lastName)
        ..setProperty("secret", secret),
    );

    request.withJsonContentType();
    return request.send();
  }

  @override
  Future<WebResponse> getUser(int userId) {
    final request =
        createPrivateRequest<GET>(userPathWithUserId(userId), _privateKey);
    return request.send();
  }

  @override
  Future<WebResponse> getUsers() {
    final request = createPrivateRequest<GET>(usersPath, _privateKey);
    return request.send();
  }

  @override
  Future<WebResponse> deleteUser(int userId) {
    final request =
        createPrivateRequest<DELETE>(userPathWithUserId(userId), _privateKey);
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
    with _ChatEnginePaths, _RequestHelper
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
  Future<WebResponse> addChatMember(int chatId, String usernameToAdd) {
    // TODO: implement addChatMember
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> createChat(String title, {bool isDirectChat = false}) {
    // TODO: implement createChat
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> deleteChat(int chatId) {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> getChatDetails(int chatId) {
    // TODO: implement getChatDetails
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> getMyChats() {
    // TODO: implement getMyChats
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> getMyLatestChats(String username, String secret) {
    // TODO: implement getMyLatestChats
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> getMyLatestChatsBeforeTime(DateTime before,
      {int? count}) {
    // TODO: implement getMyLatestChatsBeforeTime
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> getOrCreateChat({
    String? title,
    List<String>? usernames,
    bool isDirectChat = false,
  }) {
    // TODO: implement getOrCreateChat
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> updateChatDetails(int chatId,
      {String? title, bool isDirectChat = false}) {
    // TODO: implement updateChatDetails
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> getChatMembers(int chatId) {
    // TODO: implement getChatMembers
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> getOtherUsers(int chatId) {
    // TODO: implement getOtherUsers
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> removeChatMember(int chatId, String usernameToRemove) {
    // TODO: implement removeChatMember
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> searchOtherUsers(int chatId, String search) {
    // TODO: implement searchOtherUsers
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> deleteMessage(int chatId, int messageId) {
    // TODO: implement deleteMessage
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> getChatMessages(int chatId) {
    // TODO: implement getChatMessages
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> getLatestChatMessages(int chatId, int chatCount) {
    // TODO: implement getLatestChatMessages
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> getMessageDetails(int chatId, int messageId) {
    // TODO: implement getMessageDetails
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> readMessage(int chatId, int lastReadMessageId) {
    // TODO: implement readMessage
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> sendChatMessage(int chatId,
      {String? text, List<String>? attachmentUrls, JSON? customJson}) {
    // TODO: implement sendChatMessage
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> updateMessageDetails(int chatId, int messageId,
      {String? newText}) {
    // TODO: implement updateMessageDetails
    throw UnimplementedError();
  }

  @override
  Future<WebResponse> userIsTyping(int chatId) {
    // TODO: implement userIsTyping
    throw UnimplementedError();
  }
}
