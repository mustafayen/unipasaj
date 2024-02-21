import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unipasaj/firebase_auth/sign_in_provider.dart';
import 'package:unipasaj/theme/app_theme.dart';
import 'firebase_options.dart';
import 'opening.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await EasyLocalization.ensureInitialized();
    runApp(EasyLocalization(
      child: MyApp(),
      supportedLocales: const [Locale('tr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr'),
    ));
  } catch (error) {
    print("Error initializing Firebase: $error");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmailSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: Home(),
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
      ),
    );
  }
}
