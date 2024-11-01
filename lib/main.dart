import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_names/services/services.dart';
import 'package:band_names/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => SocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': ( _ ) => const HomeScreen(),
          'status': ( _ ) => const StatusScreen()
        },
      ),
    );
  }
}