class StatusError implements Exception {
  String cause;

  StatusError(this.cause);
}
