/// An object that represents the result of an operation where
/// [success] indicates if the operation was successful.
///
/// The [message] attribute can provided by the operation
/// in the case it needs to pass a message.
abstract class Result {
  Result({
    required this.isSuccessful,
    this.message,
  });

  /// Indicates if the operation returning this [Result] object was successful.
  final bool isSuccessful;

  /// A message provided by the operation to describe
  /// this [Result] object.
  final String? message;

  bool get isNotSuccessful => !isSuccessful;

  /// Indicates if this [Result] object contains a message from the
  /// operation.
  bool get withMessage => message != null;

  @override
  String toString() =>
      "$runtimeType is${isSuccessful ? " " : " not "}successful. Message: $message";
}
