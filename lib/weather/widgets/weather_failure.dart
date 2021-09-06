import 'package:flutter/material.dart';

class WeatherFailure extends StatelessWidget {
  final Exception exception;

  const WeatherFailure({Key? key, required this.exception}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ErrorWidget(exception);
  }
}
