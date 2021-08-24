import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkService {
  Future<bool> hasConnection();
}

class NetworkServiceImpl extends NetworkService {
  static final _instance = NetworkServiceImpl._();
  NetworkServiceImpl._();
  factory NetworkServiceImpl() => _instance;

  @override
  Future<bool> hasConnection() async {
    final networkStatus = await Connectivity().checkConnectivity();
    if (networkStatus == ConnectivityResult.none) return false;
    return true;
  }
}
