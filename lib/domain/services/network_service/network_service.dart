import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notifications/export.dart';

abstract class NetworkService {
  Future<bool> hasConnection();
  Future<String?> hasNetworkError();
}

class NetworkServiceImpl extends NetworkService {
  static final _instance = NetworkServiceImpl._();
  NetworkServiceImpl._();
  factory NetworkServiceImpl() => _instance;

  @override
  Future<bool> hasConnection() async {
    final networkStatus = await _getNetworkStatus();
    if (networkStatus != ConnectivityResult.none)
      return await _isNetworkWorking();

    return false;
  }

  Future<bool> _isNetworkWorking() async {
    try {
      final res = await Dio(BaseOptions(connectTimeout: 10000))
          .get(Api.connectionTestHost);
      if (res.statusCode == 200) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<ConnectivityResult> _getNetworkStatus() async {
    return await Connectivity().checkConnectivity();
  }

  @override
  Future<String?> hasNetworkError() async {
    final status = await _getNetworkStatus();
    final isConnectionEstablished = await _isNetworkWorking();
    if (status == ConnectivityResult.none)
      return "Please try to enable Data Network";
    else if (!isConnectionEstablished)
      return "Something went wrong, Please check your internet connection";
  }
}
