import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:roomnew/screens/landing.dart';
import 'package:roomnew/screens/signup.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {

   WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();
 
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:
        Color.fromARGB(255, 0, 0, 0), // navigation bar color
    statusBarColor: Colors.pink, // status bar color
  ));
  await Hive.initFlutter();



  await Hive.openBox("room8");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room8 Social Room',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat'),
      home: const MyHomePage(title: 'Room8 Social Room'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool? loggedIn;

  @override
  Widget build(BuildContext context) {
    if (Hive.box("room8").get("loggedIn") != null) {
      loggedIn = Hive.box("room8").get("loggedIn");
    }
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: '',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: loggedIn == true
          ? const Landing(title: 'Room8 Social Room')
          : const Signup(title: 'Room8 Social Room - Signup'),
    );
  }
}
