class MyHttpException implements Exception {
  String message;

  MyHttpException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString();
  }
}
