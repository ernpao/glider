import 'package:glider/glider.dart';

abstract class ContactsInterface {
  Future<WebResponse> getContacts();
  Future<WebResponse> searchForContact(String query);
}
