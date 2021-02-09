import 'package:do_or_die/data/database.dart';
import 'package:flutter/material.dart';

import 'data/models.dart';
import 'overview/overview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appData = await initDatabaseIfNeeded();
  runApp(MyApp(appData));
}

class MyApp extends StatelessWidget {
  final AppData appData;
  MyApp(this.appData);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BoardsOverView(
        appData,
      ),
    );
  }
}
