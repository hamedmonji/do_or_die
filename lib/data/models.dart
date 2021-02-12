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

  BoardData(this.name, this.paths);

  BoardData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        paths = (json['paths'] as List<dynamic>)
            .map((path) => PathData.fromJson(path))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'paths': paths,
    };
  }
}

class PathData {
  final String name;
  List<Task> tasks;
  final PathStyle style;
  final PathKind kind;

  PathData(this.name,
      {this.tasks, this.style = const PathStyle(), this.kind = PathKind.todo}) {
    if (tasks == null) tasks = [];
  }

  PathData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        style = PathStyle.fromJson(json['style']) ?? PathStyle(),
        kind = PathKind.values[json['kind']],
        tasks = (json['tasks'] as List<dynamic>)
            .map((task) => Task.fromJson(task))
            .toList();

  Map<String, dynamic> toJson() {
    return {'name': name, 'tasks': tasks, 'style': style, 'kind': kind.index};
  }

  PathData.inProgress({PathStyle style = const PathStyle()})
      : name = 'in progress',
        style = style,
        kind = PathKind.inProgress,
        tasks = [];
  PathData.done({PathStyle style = const PathStyle()})
      : name = 'done',
        style = style,
        kind = PathKind.done,
        tasks = [];
}

enum PathKind { todo, inProgress, done }

class PathStyle {
  final bool expanded;
  final TaskView view;

  const PathStyle({this.expanded = true, this.view = TaskView.circle});

  PathStyle.fromJson(Map<String, dynamic> json)
      : expanded = json['expanded'],
        view = TaskView.values[json['view']];

  Map<String, dynamic> toJson() {
    return {
      'expanded': expanded,
      'view': view.index,
    };
  }
}

enum TaskView { circle, title }

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
