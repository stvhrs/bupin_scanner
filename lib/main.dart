import 'package:Bupin/Home.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  return runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(

          fontFamily: 'Nunito',
          textTheme: TextTheme(titleMedium: TextStyle(fontFamily: "Nunito")),
          scaffoldBackgroundColor: Color.fromRGBO(70, 89, 166, 1),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Color.fromRGBO(236, 180, 84, 1),
              primary: Color.fromRGBO(70, 89, 166, 1))),
      home: Home()));
}
