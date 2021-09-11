extension DefaultTimeOut<T> on Future<T> {
  Future<T> get withDefaultTimeOut => this.timeout(Duration(seconds: 15));
}
