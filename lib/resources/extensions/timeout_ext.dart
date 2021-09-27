
///Default Timeout extention for API's
extension DefaultTimeOut<T> on Future<T> {
  ///Default TimeoutExtention wiht 15 seconds
  Future<T> get withDefaultTimeOut => this.timeout(Duration(seconds: 15));
}
