import 'package:glider_portal/glider_portal.dart';

import 'app_authentication_state.dart';

class ChatEngineAuthFlow
    extends AppAuthenticationStateBase<ChatEngineActiveUser> {
  ChatEngineAuthFlow() : super(authInterface: ChatEngineAPI());

  @override
  ChatEngineActiveUser createAuthenticatedUser(
    JSON responseBody,
    String secret,
  ) {
    return ChatEngineActiveUser(responseBody, secret);
  }

  @override
  ChatEngineActiveUser loadStoredUser(String encodedUserData, String secret) {
    final json = JSON.parse(encodedUserData);
    return ChatEngineActiveUser(json, secret);
  }

  @override
  String encodeUserForStorage(ChatEngineActiveUser user) => user.data.encode();

  @override
  String createErrorMessageOnFailedAuth(WebResponse failedLoginResponse) {
    return failedLoginResponse.bodyAsJson()!.getProperty<String>("detail")!;
  }

  @override
  String exceptionToErrorMessageString(Object error) {
    return error.toString();
  }
}
