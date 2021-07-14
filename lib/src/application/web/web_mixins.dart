/// A mixin used to give an object an HTTP scheme (http or https).
mixin WebHttpScheme {
  bool get withHttps;

  /// Returns "http" or "https" based on the URI scheme being used.
  String get webScheme => withHttps ? "https" : "http";
}

/// A mixin used to give an object a web host property.
mixin WebHost {
  /// Name/IP address of the host server.
  String get host;
}
