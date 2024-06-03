import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_logic_bloc.dart';
import 'game_screen.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class PermissionHandler {
  static const MethodChannel _channel =
      MethodChannel('com.impiia.power2/permission');

  static Future<void> requestPermission() async {
    await _channel.invokeMethod('requestPermission');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PermissionHandler.requestPermission();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameLogicCubit(),
      child: const MaterialApp(
        title: 'Power of 2',
        home: GameScreen(),
      ),
    );
  }
}
