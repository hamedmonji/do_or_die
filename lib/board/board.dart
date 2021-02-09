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
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var path in board.paths)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Path(
                        path: path,
                        taskToInProgress: (value) {
                          setState(() {
                            board.inProgress.tasks.add(value);
                          });
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: GestureDetector(
                      onLongPress: () => _saveBoard(),
                      child: NewPath(
                        expanded: board.paths.isEmpty,
                        pathCreated: (String newPath) {
                          setState(() {
                            board.paths.add(PathData(newPath));
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            InProgressPath(path: board.inProgress),
            Spacer()
          ],
        ),
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
