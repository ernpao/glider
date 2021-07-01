import 'models.dart';

class SimpleJSON extends Mappable {
  final Map<String, dynamic> _content = {};
  void add(String key, dynamic value) => _content[key] = value;

  @override
  Map<String, dynamic> map() => _content;
}
