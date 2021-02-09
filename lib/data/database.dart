import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'models.dart';

Future<AppData> initDatabaseIfNeeded() async {
  final database = await _getDatabaseFile();
  if (await database.exists()) {
    return _getAppDataFromDatabase(database);
  } else {
    await database.create(recursive: true);
    final appData = AppData([]);
    return _updateAppData(appData, database);
  }
}

Future<AppData> updateAppData(AppData appData) async {
  final database = await _getDatabaseFile();
  return _updateAppData(appData, database);
}

Future<AppData> getAppData() async {
  return _getAppDataFromDatabase(await _getDatabaseFile());
}

Future<File> _getDatabaseFile() async {
  final saveDir = await getApplicationDocumentsDirectory();
  final databaseFile = File(saveDir.path + '/data.txt');
  return databaseFile;
}

Future<AppData> _getAppDataFromDatabase(File database) async {
  final String lastData = await database.readAsString();
  final appData = AppData.fromJson(jsonDecode(lastData));
  return appData;
}

Future<AppData> _updateAppData(AppData appData, File database) async {
  final data = await appData.json();
  await database.writeAsString(data);
  return appData;
}

Future<AppData> addBoard(BoardData boardData) async {
  final appData = await getAppData();
  appData.boards.add(boardData);
  return await updateAppData(appData);
}

Future<BoardData> updateBoard(BoardData updatedBoard) async {
  final appData = await getAppData();
  final updatedBoards = appData.boards.map((board) {
    if (board.name == updatedBoard.name) {
      return updatedBoard;
    } else
      return board;
  }).toList();

  await updateAppData(AppData(updatedBoards));

  return updatedBoard;
}
