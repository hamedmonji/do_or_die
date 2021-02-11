import 'dart:ui';

import 'package:do_or_die/data/database.dart';
import 'package:do_or_die/data/models.dart';
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
    return Scaffold(
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
              Container(
                constraints:
                    constraints.copyWith(maxWidth: constraints.maxWidth / 3),
                child: IntrinsicWidth(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var path in board.paths)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: MutablePath(
                              path: path,
                              builder: (context, taks, index) {
                                return GestureDetector(
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: TitleTaskView(
                                        task: taks,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      path.tasks.remove(taks);
                                      board.inProgress.tasks.add(taks);
                                    });
                                  },
                                );
                              },
                              onTaskCreated: (Task value) {
                                setState(() {
                                  path.tasks.add(value);
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      constraints:
                          BoxConstraints(maxWidth: constraints.maxWidth / 3),
                      child: StackedPath(
                        path: board.inProgress,
                        builder: (BuildContext context, Task task, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                board.inProgress.tasks.remove(task);
                                board.done.tasks.add(task);
                              });
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: CubeTaskView(
                                    task: task,
                                    color: Colors.primaries[
                                        index % Colors.primaries.length],
                                  ),
                                )),
                          );
                        },
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IntrinsicHeight(
                    child: Container(
                        constraints:
                            BoxConstraints(maxWidth: constraints.maxWidth / 3),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: ScrollablePath(
                            path: board.done,
                            onTaskTapped: (value) {},
                            builder:
                                (BuildContext context, Task task, int index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CircleTaskView(
                                    task: task,
                                    color: Colors.primaries[
                                        index % Colors.primaries.length],
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: NewPath(
                    pathCreated: (value) {},
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _saveBoard() async {
    print('save board');
    updateBoard(board);
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
  _NewPathState createState() => _NewPathState(pathCreated);
}

class _NewPathState extends State<NewPath>
    with SingleTickerProviderStateMixin<NewPath> {
  bool _addPath = false;
  FocusNode focusNode = FocusNode();
  final ValueChanged<String> pathCreated;

  _NewPathState(this.pathCreated);

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
                                          pathCreated(value);
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
