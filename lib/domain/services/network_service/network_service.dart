import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notifications/export.dart';

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
    if (networkStatus != ConnectivityResult.none) {
      try {
        final res = await Dio(BaseOptions(connectTimeout: 10000))
            .get(Api.connectionTestHost);
        if (res.statusCode == 200) return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
