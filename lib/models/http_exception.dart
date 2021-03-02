import 'package:flutter/foundation.dart';

class HttpException implements Exception {
  final String exceptionMessage;

  HttpException(this.exceptionMessage);

  @override
  String toString() {
    // TODO: implement toString
    return exceptionMessage;
    //return super.toString();
  }
}
