import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'auth/models/authentication.dart';
import 'auth/models/user_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Authentication()),
        ChangeNotifierProvider(
          create: (context) => Loginauthentication(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(0xff075e54),
            accentColor: new Color(0xff25d366)),
        home: LoginPage(),
      ),
    );
  }
}
