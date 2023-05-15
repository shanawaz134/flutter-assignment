import 'package:flutter/material.dart';

import 'package:flutter_assignment/add_task.dart';
import 'package:flutter_assignment/main.dart';
import 'package:flutter_assignment/mainscreen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/' :
        return  MaterialPageRoute(
            builder: (_)=> const MyHomePage()
        );
      case '/main_screen' :
        return MaterialPageRoute(
            builder: (_)=> const MainScreen()
        ) ;
      case '/add_task' :
        return MaterialPageRoute(
            builder: (_)=> const AddTaskScreen()
        ) ;
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ));
    }
  }
}