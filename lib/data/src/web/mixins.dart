/// A mixin used to give an object an HTTP scheme (http or https).
mixin WebHTTP {
  bool get usesHttps;

  /// Returns "http" or "https" based on the URI scheme being used.
  String get webScheme => usesHttps ? "https" : "http";
}

/// A mixin used to give an object a web host property.
mixin WebHost {
  String get host;
}
