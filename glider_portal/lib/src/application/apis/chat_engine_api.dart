import 'package:flutter/foundation.dart';
import 'package:glider_portal/glider_portal.dart';

class ChatEnginePrivateAPI
    with _ChatEnginePaths, _RequestHelper
    implements AuthInterface, ChatEnginePrivateInterface {
  static const _privateKey = "d243c478-85ad-49d5-80da-f4673bfda05d";

  @override
  Future<WebResponse> createUser({
    required String username,
    required String secret,
    String? firstName,
    String? lastName,
  }) {
    final request = _createPrivateRequest<POST>(_usersPath, _privateKey);

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
    final request = _createPrivateRequest<GET>(
      _usersPathWithUserId(userId),
      _privateKey,
    );
    return request.send();
  }

  @override
  Future<WebResponse> getUsers() {
    final request = _createPrivateRequest<GET>(_usersPath, _privateKey);
    return request.send();
  }

  @override
  Future<WebResponse> deleteUser(int userId) {
    final request = _createPrivateRequest<DELETE>(
      _usersPathWithUserId(userId),
      _privateKey,
    );
    return request.send();
  }

  @override
  Future<WebResponse> authenticate(String username, String secret) {
    return _createUserRequest<GET>(_mePath, username, secret).send();
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
  String get projectId => _projectId;

  @override
  final String secret;

  @override
  final String username;

  @override
  Future<WebResponse> addChatMember(int chatId, String usernameToAdd) =>
      _createUserRequest<POST>("/chats/$chatId/people/", username, secret)
          .send();

  @override
  Future<WebResponse> createChat(String title, {bool isDirectChat = false}) {
    final body = JSON()
      ..setProperty("title", title)
      ..setProperty("is_direct_chat", isDirectChat);

    final post = _createUserRequest<POST>(_chatsPath, username, secret);
    post.withBody(body);

    return post.send();
  }

  @override
  Future<WebResponse> deleteChat(int chatId) => _createUserRequest<DELETE>(
        _chatsPathWithChatId(chatId),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getChatDetails(int chatId) => _createUserRequest<GET>(
        _chatsPathWithChatId(chatId),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getMyChats() => _createUserRequest<GET>(
        _chatsPath,
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getMyLatestChats(int chatCount) =>
      _createUserRequest<GET>(
        _latestChatsPath(chatCount),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getMyLatestChatsBeforeTime(
    DateTime before,
    int chatCount,
  ) {
    final body = JSON()..setProperty("before", before.toIso8601String());
    final put = _createUserRequest<PUT>(
      _latestChatsPath(chatCount),
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

    final request = _createUserRequest<PUT>(_chatsPath, username, secret);
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

    final request = _createUserRequest<PATCH>(
      _chatsPathWithChatId(chatId),
      username,
      secret,
    );

    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> getChatMembers(int chatId) {
    final request = _createUserRequest<GET>(
      _chatsPathWithPeople(chatId),
      username,
      secret,
    );
    return request.send();
  }

  @override
  Future<WebResponse> getOtherUsers(int chatId) {
    final request = _createUserRequest<GET>(
      _chatsPathWithOthers(chatId),
      username,
      secret,
    );
    return request.send();
  }

  @override
  Future<WebResponse> removeChatMember(int chatId, String usernameToRemove) {
    final body = JSON()..setProperty("username", usernameToRemove);
    final request = _createUserRequest<PUT>(
      _chatsPathWithPeople(chatId),
      username,
      secret,
    );
    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> searchOtherUsers(int chatId, String search) {
    final body = JSON()..setProperty("search", search);
    final request = _createUserRequest<POST>(
      _chatsPathWithOthers(chatId),
      username,
      secret,
    );
    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> deleteMessage(int chatId, int messageId) =>
      _createUserRequest<DELETE>(
        _messagesPathWithMessageId(chatId, messageId),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getChatMessages(int chatId) => _createUserRequest<GET>(
        _messagesPath(chatId),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getLatestChatMessages(int chatId, int chatCount) =>
      _createUserRequest<GET>(
        _latestMessagesPath(chatId, chatCount),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> getMessageDetails(int chatId, int messageId) =>
      _createUserRequest<GET>(
        _messagesPathWithMessageId(chatId, messageId),
        username,
        secret,
      ).send();

  @override
  Future<WebResponse> readMessage(int chatId, int lastReadMessageId) {
    final body = JSON()..setProperty("last_read", lastReadMessageId);
    final request = _createUserRequest<PATCH>(
      _chatsPathWithPeople(chatId),
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

    final request = _createUserRequest<POST>(
      _messagesPath(chatId),
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

    final request = _createUserRequest<PATCH>(
      _messagesPath(chatId),
      username,
      secret,
    );

    request.withBody(body);
    return request.send();
  }

  @override
  Future<WebResponse> userIsTyping(int chatId) => _createUserRequest<PATCH>(
        _typingPath(chatId),
        username,
        secret,
      ).send();
}

class ChatEngineWebSocket with _RequestHelper, Secret, Username {
  ChatEngineWebSocket({
    required this.username,
    required this.secret,
    this.onEditChatEvent,
    this.onTypingEvent,
  });

  @override
  final String secret;

  @override
  final String username;

  late final _socket = WsSocket(
    host: _baseUrl,
    useWss: true,
    path: "/person/",
  );

  final void Function(int chatId, String username)? onTypingEvent;
  final void Function(Chat chat)? onEditChatEvent;

  void close() {
    _socket.closeSocket();
  }

  void begin() {
    if (_socket.isClosed) {
      _socket.withParameter("publicKey", _projectId);
      _socket.withParameter("username", username);
      _socket.withParameter("secret", secret);
      debugPrint("Opening Chat Engine socket...");
      _socket.openSocket();
    }

    if (_socket.hasNoListener) {
      _socket.listen(
        WebSocketJsonListener(
          onDataReceived: (json) {
            final message = ChatEngineSocketEvent(json);
            final action = message.action;

            switch (action) {
              case ChatEngineSocketEvent.actionLoginError:
                debugPrint("Chat Engine Socket login error:");
                debugPrint("Socket URI: ${_socket.uri}");
                debugPrint("Socket Query: ${_socket.query}");
                debugPrint(
                  "Socket Query Parameters: ${_socket.queryParameters}",
                );
                break;
              case ChatEngineSocketEvent.actionEditChat:
                final chat = Chat(message.data);
                onEditChatEvent?.call(chat);
                break;
              case ChatEngineSocketEvent.actionIsTyping:
                final personTyping =
                    message.data.getProperty<String>("person")!;
                if (username != personTyping) {
                  final chatId = message.data.getProperty<int>("id")!;
                  onTypingEvent?.call(chatId, personTyping);
                }
                break;
              default:
                break;
            }
          },
          onError: (error) {
            debugPrint("Chat Engine Socket Error: ${error.toString()}");
            debugPrint("Socket URI: ${_socket.uri}");
          },
          onDone: () {
            debugPrint("Chat Engine Socket Done Event.");
          },
        ),
        reopenOnDone: true,
      );
    }

    debugPrint("Chat Engine socket initialized!");
  }
}

class ChatEngineSocketEvent {
  ChatEngineSocketEvent(this._eventData);

  /// The JSON received from the socket.
  /// Contains an `action` property
  /// that describes the type of message
  /// received and a `data` property which
  /// is the payload of the message.
  final JSON _eventData;

  JSON get data {
    final jsonMap = _eventData.getProperty<Map>(_dataKey)!;

    return JSON.fromDynamicMap(jsonMap);
  }

  String get action => _eventData.getProperty<String>(_actionKey)!;

  bool get isLoginErrorAction => action == actionLoginError;
  bool get isTypingAction => action == actionIsTyping;
  bool get isEditChatAction => action == actionEditChat;

  static const _dataKey = "data";
  static const _actionKey = "action";
  static const actionIsTyping = "is_typing";
  static const actionEditChat = "edit_chat";
  static const actionNewMessage = "new_message";
  static const actionDeleteChat = "delete_chat";
  static const actionLoginError = "login_error";
}

@protected
mixin _ChatEnginePaths {
  final String _usersPath = "/users";
  String _usersPathWithUserId(int userId) => "$_usersPath/$userId/";

  late final String _mePath = "$_usersPath/me/";

  final String _chatsPath = "/chats/";
  String _latestChatsPath(int chatCount) => "/chats/latest/$chatCount";
  String _chatsPathWithChatId(int chatId) => "/chats/$chatId/";
  String _chatsPathWithPeople(int chatId) => "/chats/$chatId/people/";
  String _chatsPathWithOthers(int chatId) => "/chats/$chatId/others/";

  String _typingPath(int chatId) => "/chats/$chatId/typing/";

  String _messagesPath(int chatId) => "/chats/$chatId/messages/";

  String _messagesPathWithMessageId(int chatId, int messageId) {
    return "${_messagesPath(chatId)}$messageId/";
  }

  String _latestMessagesPath(int chatId, int chatCount) {
    return "${_messagesPath(chatId)}latest/$chatCount/";
  }
}

@protected
mixin _RequestHelper {
  static const _chatEngineIoUrl = "api.chatengine.io";
  String get _baseUrl => _chatEngineIoUrl;

  static const _chatEngineIoProjectId = "ab2204ec-10bc-4807-9f61-ecf012787ced";
  String get _projectId => _chatEngineIoProjectId;

  static final _webClient = WebClient(
    host: _chatEngineIoUrl,
    useHttps: true,
  );

  T _createUserRequest<T extends WebRequest>(
      String? path, String username, String secret) {
    final request = _webClient.createRequest<T>(path);
    request.withHeader("Project-ID", _projectId);
    request.withHeader("User-Name", username);
    request.withHeader("User-Secret", secret);
    request.withJsonContentType();
    return request;
  }

  T _createPrivateRequest<T extends WebRequest>(
    String? path,
    String privateKey,
  ) {
    final request = _webClient.createRequest<T>(path);
    request.withHeader("PRIVATE-KEY", privateKey);
    request.withJsonContentType();
    return request;
  }
}
