/// An object that can be stringified.
abstract class Stringifiable {
  String stringify();

  @override
  String toString() => stringify();
}
