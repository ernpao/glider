/// A mixin that allows the object to call
/// the debug() method.
///
/// This converts the
/// calling object into a string (using
/// the toString() method). The resulting
/// string is logged to the to the debug
///  console using print().
mixin DebugConsoleLogging {
  /// Prints self to the debug console.
  void debug() => print(this.toString());
}
