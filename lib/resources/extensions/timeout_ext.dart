extension DefaultTimeOut<T> on Future<T> {
  Future<T> withDefaultTimeOut() => this.timeout(Duration(seconds: 20));
}
