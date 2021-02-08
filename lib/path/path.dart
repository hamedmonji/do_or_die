import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../colors.dart';

class Path extends StatefulWidget {
  final PathData path;

  const Path({Key key, @required this.path}) : super(key: key);

  @override
  _PathState createState() => _PathState(path);
}

class _PathState extends State<Path> with SingleTickerProviderStateMixin {
  bool _addCourse = false;
  FocusNode focusNode = FocusNode();
  GlobalKey<AnimatedListState> listKey = GlobalKey();
  final PathData path;
  double itemSize = 100;
  double initialSize;
  TextStyle style = TextStyle(
      fontSize: 22, color: Color(0xff4B4B4B), fontWeight: FontWeight.w300);

  _PathState(this.path);
  @override
  void initState() {
    super.initState();
    initialSize = _textSize("Item name", style);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _addCourse = !_addCourse;
          focusNode.requestFocus();
        });
      },
      child: Row(
        children: [
          Container(
            height: 60,
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
                child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: 46,
                            constraints: BoxConstraints(
                                maxHeight: 46,
                                minHeight: 46,
                                minWidth: 46,
                                maxWidth: !_addCourse
                                    ? 46
                                    : max(itemSize, initialSize) + 80),
                            child: _addCourse
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 30),
                                    child: Center(
                                      child: TextField(
                                        focusNode: focusNode,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Item name",
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            itemSize = _textSize(value, style);
                                          });
                                        },
                                        onSubmitted: (value) {
                                          path.tasks.add(Task(value));
                                          listKey.currentState.insertItem(
                                              path.tasks.length - 1);
                                          setState(() {
                                            _addCourse = false;
                                          });
                                        },
                                        style: style,
                                      ),
                                    ),
                                  )
                                : null,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: _addCourse
                                        ? Colors.primaries[
                                            (path.tasks.length + 1) %
                                                Colors.primaries.length]
                                        : AppColors.colorPrimary),
                                borderRadius: BorderRadius.circular(46)),
                          ),
                        ),
                        AnimatedList(
                          key: listKey,
                          reverse: true,
                          itemBuilder: (context, index, animation) {
                            if (index == 0) {
                              return SizeTransition(
                                axis: Axis.horizontal,
                                axisAlignment: 1,
                                sizeFactor: animation,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Center(
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.primaries[
                                              index % Colors.primaries.length],
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(24),
                                              bottomRight:
                                                  Radius.circular(24))),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return SizeTransition(
                              axis: Axis.horizontal,
                              axisAlignment: 1,
                              sizeFactor: animation,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: Container(
                                    height: 46,
                                    width: 46,
                                    decoration: BoxDecoration(
                                        color: Colors.primaries[
                                            index % Colors.primaries.length],
                                        borderRadius:
                                            BorderRadius.circular(66)),
                                  ),
                                ),
                              ),
                            );
                          },
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          initialItemCount: path.tasks.length,
                        )
                      ],
                    )),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24))),
          ),
        ],
      ),
    );
  }

  double _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }
}

class DataSource {
  final List<PathData> paths = [];
  List<PathData> getPaths() => paths;
}

class Task {
  final String name;
  final CourseState completionStatus;

  Task(this.name, {this.completionStatus = CourseState.todo});
}

class PathData {
  final String name;
  List<Task> tasks;

  PathData(this.name, {this.tasks}) {
    if (tasks == null) tasks = [];
  }
}

enum CourseState { todo, inProgress, done }
