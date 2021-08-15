import 'package:glider_models/glider_models.dart';

import 'person.dart';

typedef ActivitiesModel = List<ActivityModel>;

abstract class ActivityModel {
  PersonModel get person;

  /// ID of the last message read
  /// by the `person` in the chat
  int get lastRead;
}

typedef Activities = List<Activity>;

/// A representation of a person's activity
/// (i.e. last read message) in a [Chat].
class Activity implements ActivityModel {
  Activity(this.data);

  final JSON data;

  @override
  int get lastRead => data.getProperty<int>(_kLastRead)!;

  @override
  Person get person =>
      Person.fromMap(data.getProperty<KeyValueStore>(_kPerson)!);

  factory Activity.parse(String string) => Activity(JSON.parse(string));

  static Activities parseList(String string) =>
      fromJsonList(JSON.parseList(string));

  static List<Activity> fromJsonList(List<JSON> jsonArray) =>
      jsonArray.map((json) => Activity(json)).toList();

  static const _kPerson = "person";
  static const _kLastRead = "last_read";
}
