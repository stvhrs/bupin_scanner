import 'package:Bupin/Home.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent
));

  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]);
  
  return runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
          appBarTheme:
              const AppBarTheme(actionsIconTheme: IconThemeData(color: Colors.white)),
          fontFamily: 'Nunito',
          textTheme: const TextTheme(titleMedium: TextStyle(fontFamily: "Nunito")),
          scaffoldBackgroundColor: const Color.fromRGBO(70, 89, 166, 1),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color.fromRGBO(236, 180, 84, 1),
              primary: const Color.fromRGBO(70, 89, 166, 1))),
      home:  const Home()));
        
    
}
