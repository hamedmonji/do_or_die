import 'dart:ui';

import 'package:do_or_die/data/database.dart';
import 'package:do_or_die/data/models.dart';
import 'package:do_or_die/widgets/blur.dart';
import 'package:flutter/material.dart';
import 'package:do_or_die/path/path.dart';

import '../colors.dart';

class Board extends StatefulWidget {
  final BoardData board;

  const Board({Key key, @required this.board}) : super(key: key);
  @override
  _BoardState createState() => _BoardState(board);
}

class _BoardState extends State<Board> {
  final BoardData board;

  _BoardState(this.board);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapUp: (details) {
        final x = details.globalPosition.dx;
        final y = details.globalPosition.dy;
        showMenu(
            context: context,
            position: RelativeRect.fromLTRB(x, y, x + 100, y + 40),
            items: [
              PopupMenuItem(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _saveBoard();
                  },
                  child: Text("Save"),
                ),
              )
            ]);
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/background.jpg"),
                          fit: BoxFit.cover)),
                ),
                _buildTodoPaths(constraints),
                _buildInProgressPath(constraints),
                _buildDonePath(constraints),
                _buildNewPath()
              ],
            );
          },
        ),
      ),
    );
  }

  Align _buildNewPath() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: NewPath(
          pathCreated: (value) {
            setState(() {
              board.paths.add(PathData(value));
              print(board.paths);
            });
          },
        ),
      ),
    );
  }

  Padding _buildDonePath(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: IntrinsicHeight(
          child: Container(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth / 3),
              child: RotatedBox(
                quarterTurns: 3,
                child: ScrollablePath(
                  path: board.paths
                      .firstWhere((path) => path.kind == PathKind.done),
                  onTaskTapped: (value) {},
                  builder: (BuildContext context, Task task, int index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CircleTaskView(
                          task: task,
                          color:
                              Colors.primaries[index % Colors.primaries.length],
                        ),
                      ),
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildInProgressPath(BoxConstraints constraints) {
    final inProgressPath =
        board.paths.firstWhere((path) => path.kind == PathKind.inProgress);
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Container(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth / 3),
              child: StackedPath(
                path: inProgressPath,
                builder: (BuildContext context, Task task, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        inProgressPath.tasks.remove(task);
                        board.paths
                            .firstWhere((path) => path.kind == PathKind.done)
                            .tasks
                            .add(task);
                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _buildTaskView(inProgressPath, task)),
                  );
                },
              )),
        ),
      ),
      onSecondaryTapUp: (details) {
        _showPathMenu(details, inProgressPath);
      },
    );
  }

  Widget _buildTodoPaths(BoxConstraints constraints) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var path
              in board.paths.where((path) => path.kind == PathKind.todo))
            IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  constraints: constraints.copyWith(
                      maxWidth:
                          path.style.expanded ? constraints.maxWidth / 3 : 70),
                  child: GestureDetector(
                    child: path.style.expanded
                        ? MutablePath(
                            path: path,
                            builder: (context, taks, index) {
                              return GestureDetector(
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: _buildTaskView(path, taks),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    path.tasks.remove(taks);
                                    board.paths
                                        .firstWhere((path) =>
                                            path.kind == PathKind.todo)
                                        .tasks
                                        .add(taks);
                                  });
                                },
                              );
                            },
                            onTaskCreated: (Task value) {
                              setState(() {
                                path.tasks.add(value);
                              });
                            },
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                updatePathStyle(
                                    path,
                                    PathStyle(
                                        expanded: !path.style.expanded,
                                        view: path.style.view));
                              });
                            },
                            child: HiddenPath(path: path),
                          ),
                    onSecondaryTapUp: (details) {
                      _showPathMenu(details, path);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  StatelessWidget _buildTaskView(PathData path, Task task) {
    return path.style.view == TaskView.circle
        ? CircleTaskView(
            task: task,
            color: Colors.pink,
          )
        : TitleTaskView(
            task: task,
          );
  }

  void _showPathMenu(TapUpDetails details, PathData path) {
    final x = details.globalPosition.dx;
    final y = details.globalPosition.dy;
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(x, y, x + 100, y + 40),
        items: <PopupMenuEntry>[
          PopupMenuItem(
            child: ElevatedButton(
              onPressed: () {
                updatePathStyle(
                    path,
                    PathStyle(
                        expanded: !path.style.expanded, view: path.style.view));
                Navigator.pop(context);
              },
              child: Text(path.style.expanded ? "Minimize" : "Expand"),
            ),
          ),
          PopupMenuItem(
            child: PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                      child: ElevatedButton(
                    child: Text("Circle"),
                    onPressed: () {
                      updatePathStyle(
                          path,
                          PathStyle(
                              expanded: path.style.expanded,
                              view: TaskView.circle));
                      Navigator.pop(context);
                    },
                  )),
                  PopupMenuItem(
                      child: ElevatedButton(
                    child: Text("Title"),
                    onPressed: () {
                      updatePathStyle(
                          path,
                          PathStyle(
                              expanded: path.style.expanded,
                              view: TaskView.title));
                      Navigator.pop(context);
                    },
                  ))
                ];
              },
              child: Text("Task Style"),
            ),
          )
        ]);
  }

  void updatePathStyle(PathData path, PathStyle newStyle) {
    setState(() {
      final index = board.paths.indexOf(path);
      board.paths.removeAt(index);
      board.paths.insert(
          index,
          PathData(path.name,
              kind: path.kind, tasks: path.tasks, style: newStyle));
    });
  }

  void _saveBoard() async {
    print('save board');
    updateBoard(board);
  }
}

class HiddenPath extends StatelessWidget {
  const HiddenPath({
    Key key,
    @required this.path,
  }) : super(key: key);

  final PathData path;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      child: Blur(
          child: RotatedBox(
        quarterTurns: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            path.name,
            style: TextStyle(fontSize: 14),
          ),
        ),
      )),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), bottomRight: Radius.circular(24))),
    );
  }
}

class NewPath extends StatefulWidget {
  final ValueChanged<String> pathCreated;
  final bool expanded;
  const NewPath({
    Key key,
    @required this.pathCreated,
    this.expanded = false,
  }) : super(key: key);

  @override
  _NewPathState createState() => _NewPathState();
}

class _NewPathState extends State<NewPath>
    with SingleTickerProviderStateMixin<NewPath> {
  bool _addPath = false;
  FocusNode focusNode = FocusNode();

  _NewPathState();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _addPath = !_addPath;
          focusNode.requestFocus();
        });
      },
      child: Container(
        height: 60,
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
            child: AnimatedSize(
              duration: Duration(milliseconds: 200),
              vsync: this,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.expanded ? 26.0 : 16),
                  child: !_addPath
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.expanded)
                              Text(
                                "New Path",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Color(0xff4B4B4B),
                                    fontWeight: FontWeight.w300),
                              ),
                            if (widget.expanded)
                              SizedBox(
                                width: 12,
                              ),
                            Icon(
                              Icons.add,
                              size: 40,
                              color: AppColors.colorPrimary,
                            )
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IntrinsicWidth(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.colorPrimary),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 30),
                                    child: TextField(
                                      focusNode: focusNode,
                                      onSubmitted: (value) {
                                        if (value != null && value.isNotEmpty) {
                                          widget.pathCreated(value);
                                        }
                                        setState(() {
                                          _addPath = false;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Enter path's name",
                                      ),
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Color(0xff4B4B4B),
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
            ),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24))),
      ),
    );
  }
}
