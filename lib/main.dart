import 'dart:developer';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Functions/OneSignalWeb.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/configure_ws.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

// final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
//   return LocaleNotifier();
// });

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

 Future<void> clearCacheOnStartup() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear cached data
}   

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(defaultPresentSound: true, defaultPresentBadge: true, defaultPresentAlert: true);

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await clearCacheOnStartup();
  
  runApp(
    ProviderScope(
      child: MyApp()
    )
  );
}

class MyApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    log(newLocale.toString());
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);    
    if(newLocale.toString() == 'ar'){
      state?.setTheme(ThemeData(fontFamily: arabicFontFamily));
    }
    else{
      state?.setTheme(ThemeData(fontFamily: englishFontFamily));
    }
    
  }

}

class _MyAppState extends ConsumerState<MyApp> {
  Locale? _locale;
  ThemeData? _theme;

  static const String oneSignalAppId = "e17aafef-af94-4ed5-b729-c74c74ff5547";

  Future<void> initPlatformState() async {
    OneSignal.initialize(oneSignalAppId);
    OneSignal.Notifications.requestPermission(true);
  }

   @override
  void initState() {
    super.initState();
    if(!kIsWeb){
      initPlatformState();
    }
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  setTheme(ThemeData theme) {
    setState(() {
      _theme = theme;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    // final currentLocale = ref.watch(localeProvider); // Watch the current locale
    // Accessing the provider here to establish the WebSocket connection at app startup
    // ref.read(websocketProvider).connect(ref);
    return Sizer(builder: ((context, orientation, deviceType) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: [
        //   Locale('en'), // English
        //   Locale('ar'), // Arabic
        // ],
        theme: _theme,
        locale: _locale,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      );
    }));
  }
}
