import 'package:catalog_app/models/usermodel.dart';
import 'package:catalog_app/pages/cart.dart';
import 'package:catalog_app/pages/forgot_password.dart';
import 'package:catalog_app/pages/user_info.dart';
import 'package:catalog_app/pages/profile_settings.dart';
import 'package:catalog_app/pages/update_email.dart';
import 'package:catalog_app/pages/settings.dart';
import 'package:catalog_app/pages/sign_up.dart';
import 'package:catalog_app/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => UserModel())
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const LoginPage(),
        themeMode: context.watch<ThemeProvider>().getTheme
            ? ThemeMode.dark
            : ThemeMode.light,
        theme: Themes.light(),
        darkTheme: Themes.dark(),
        debugShowCheckedModeBanner: false,
        routes: {
          Routes.cart: (context) => const Cart(),
          Routes.home: (context) => HomePage(),
          Routes.signup: (context) => const Signup(),
          Routes.settings: (context) => const Settings(),
          Routes.updateEmail: (context) => UpdateEmail(),
          Routes.profileSettings: (context) => const ProfileSettings(),
          Routes.forgotPassword: (context) => ForgotPassword(),
          Routes.userInfo: (context) => UserInfo()
        });
  }
}
