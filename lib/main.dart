import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tamoi/router/locations.dart';
import 'package:tamoi/screens/start_screen.dart';
import 'package:tamoi/screens/home_screen.dart';
import 'package:tamoi/screens/splash_screen.dart';
import 'package:tamoi/states/user_notifier.dart';
import 'package:tamoi/states/user_provider.dart';
import 'package:tamoi/utils/logger.dart';

final UserNotifier _userNotifier = UserNotifier();

final _router = GoRouter(
    routes: [
      GoRoute(name: "home", path: "/", builder: (context, state) => HomeScreen()),
      GoRoute(name: "auth", path: "/auth", builder: (context, state) => StartScreen()),
    ],
    refreshListenable: _userNotifier,
    redirect: (context, state) {
      // final currentPath = state.subloc == '/auth';
      final currentPath = state.matchedLocation.contains('/auth');
      // final userState = _userNotifier.user;
      // const userState = null;
      const userState = 'make main paging...';

      if (userState == null && !currentPath) {
        return '/auth';
      }
      if (userState != null && currentPath) {
        return "/";
      }
      return null;
    });

void main() {
  logger.d('start logger');
  Provider.debugCheckInvalidValueType = null; // provider 사용 시
  // provicer 데이터가 변경이 될 깨 변경된 것에 따라 하위 위젯의 모양을 상태에 맞게 변경해서 전달해주기 위해서 사용.
  // 숫자를 바꾸는건 pageController가 알아서 핸들링을 하고 pageController Object는 변경될 것이 없음.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 300), () => 100),
        builder: (context, snapshot) {
          return AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: _splashLoadingWidget(snapshot));
        });
  }

  StatelessWidget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      logger.d('error occur while loading.');
      return const Text('error occur.');
    } else if (snapshot.hasData) {
      return const TamoiApp();
    } else {
      return const SplashScreen();
    }
  }
}

class TamoiApp extends StatelessWidget {
  const TamoiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      // providers: [
      //   // ChangeNotifierProvider<UserNotifier>.value(value: _userNotifier)
      // ],
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp.router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        theme: ThemeData(
            fontFamily: 'Jalnan',
            primarySwatch: Colors.amber,
            hintColor: Colors.grey[350],
            textTheme: TextTheme(
              labelLarge: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.black87, fontSize: 15),
              bodyMedium: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              primary: Colors.white,
              minimumSize: Size(48, 48),
            )),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 2,
              titleTextStyle: TextStyle(color: Colors.black87),
              actionsIconTheme: IconThemeData(color: Colors.black87),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                // backgroundColor: Colors.black87, //Bar의 배경색
                selectedItemColor: Colors.black87, //선택 안된 아이템의 색상
                unselectedItemColor: Colors.black54 //선택된 아이템의 색상
                )),
      ),
    );
  }
}
