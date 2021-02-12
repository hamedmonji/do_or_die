import 'dart:convert';

class AppData {
  final List<BoardData> boards;

  AppData(this.boards);

  AppData.fromJson(Map<String, dynamic> json)
      : boards = (json['boards'] as List<dynamic>)
            .map((board) => BoardData.fromJson(board))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'boards': boards,
    };
  }

  Future<String> json() async {
    return jsonEncode(this);
  }
}

class BoardData {
  final String name;
  final List<PathData> paths;
  final PathData inProgress;
  final PathData done;

  BoardData(this.name, this.paths, this.inProgress, this.done);

  BoardData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        paths = (json['paths'] as List<dynamic>)
            .map((path) => PathData.fromJson(path))
            .toList(),
        inProgress = PathData.fromJson(json['inProgress']),
        done = PathData.fromJson(json['done']);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'paths': paths,
      'inProgress': inProgress,
      'done': done,
    };
  }
}

class PathData {
  final String name;
  List<Task> tasks;
  final bool expanded;

  PathData(this.name, {this.tasks, this.expanded = true}) {
    if (tasks == null) tasks = [];
  }

  PathData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        expanded = json['expanded'] ?? true,
        tasks = (json['tasks'] as List<dynamic>)
            .map((task) => Task.fromJson(task))
            .toList();

  Map<String, dynamic> toJson() {
    return {'name': name, 'tasks': tasks, 'expanded': expanded};
  }

  PathData.inProgress()
      : name = 'in progress',
        expanded = true,
        tasks = [];
  PathData.done()
      : name = 'done',
        expanded = true,
        tasks = [];
}

class Task {
  final String name;
  final TaskState completionStatus;

  Task(this.name, {this.completionStatus = TaskState.todo});

  Task.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        completionStatus = TaskState.values[json['state']];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'state': completionStatus.index,
    };
  }
}

enum TaskState { todo, inProgress, done }
