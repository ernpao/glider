mixin WebHTTP {
  bool get usesHttps;

  /// Returns "http" or "https" based on the URI scheme being used.
  String get webScheme => usesHttps ? "https" : "http";
}

mixin WebHost {
  String get host;
}
