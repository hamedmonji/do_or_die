import 'dart:math';
import 'dart:ui';

import 'package:do_or_die/data/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../colors.dart';

class Path extends StatefulWidget {
  final PathData path;
  final ValueChanged<Task> taskToInProgress;
  const Path({Key key, @required this.path, this.taskToInProgress})
      : super(key: key);

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
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 8),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        widget.taskToInProgress(
                                            path.tasks[index]);
                                        path.tasks.removeAt(index);
                                        listKey.currentState.removeItem(
                                            index,
                                            (context, animation) =>
                                                SizeTransition(
                                                  axis: Axis.horizontal,
                                                  axisAlignment: 1,
                                                  sizeFactor: animation,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Center(
                                                      child: Container(
                                                        height: 46,
                                                        width: 46,
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                    .primaries[
                                                                index %
                                                                    Colors
                                                                        .primaries
                                                                        .length],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        66)),
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                      },
                                      child: Container(
                                        height: 46,
                                        width: 46,
                                        decoration: BoxDecoration(
                                            color: Colors.primaries[index %
                                                Colors.primaries.length],
                                            borderRadius:
                                                BorderRadius.circular(66)),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                widget.taskToInProgress(path.tasks[index]);
                                path.tasks.removeAt(index);
                                listKey.currentState.removeItem(
                                    index,
                                    (context, animation) => SizeTransition(
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
                                                        index %
                                                            Colors.primaries
                                                                .length],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            66)),
                                              ),
                                            ),
                                          ),
                                        ));
                              },
                              child: SizeTransition(
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

class InProgressPath extends StatelessWidget {
  final PathData path;
  final ValueChanged<Task> onTaskTapped;
  InProgressPath({Key key, @required this.path, this.onTaskTapped})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sublistCount = path.tasks.length == 0
            ? 1
            : ((path.tasks.length + 1) / (constraints.maxWidth / 80)).ceil();
        print(sublistCount);
        return Center(
          child: ListView.builder(
            itemCount: sublistCount,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final eachPartialitmeCount = constraints.maxWidth ~/ 80;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: _buildPartialPath(
                    constraints,
                    path.tasks.sublist(
                        index * eachPartialitmeCount,
                        min((index + 1) * eachPartialitmeCount,
                            path.tasks.length))),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPartialPath(BoxConstraints constraints, List<Task> tasks) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 84, minWidth: 80),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              constraints: BoxConstraints(
                  minHeight: 84,
                  maxHeight: 84,
                  minWidth: 84,
                  maxWidth: min(
                      constraints.maxWidth,
                      tasks.isEmpty
                          ? 84
                          : 84 + (80 * tasks.length.toDouble()))),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      itemCount: tasks.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (onTaskTapped != null)
                              onTaskTapped(path.tasks[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Container(
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                    color: Colors.primaries[
                                        index % Colors.primaries.length],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                              ),
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                    )
                  ],
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24))),
        ),
      ],
    );
  }
}

class ScrollablePath extends StatelessWidget {
  final PathData path;
  final ValueChanged<Task> onTaskTapped;
  final ScrollController _controller = ScrollController();

  ScrollablePath({Key key, @required this.path, this.onTaskTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    return Container(
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          constraints: BoxConstraints(
              maxHeight: max(54 * (path.tasks.length.toDouble() + 1), 54)),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
          child: Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(
              itemCount: path.tasks.length,
              controller: _controller,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (onTaskTapped != null) onTaskTapped(path.tasks[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleTaskView(
                      task: path.tasks[index],
                      color: Colors.primaries[index % Colors.primaries.length],
                    ),
                  ),
                );
              },
              scrollDirection: Axis.vertical,
            ),
          ),
        ),
      ),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(24))),
    );
  }
}

class TitleTaskView extends StatelessWidget {
  final Task task;
  final Color color;

  const TitleTaskView({Key key, this.task, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(task.name),
      ),
    );
  }
}

class CircleTaskView extends StatelessWidget {
  final Color color;
  final Task task;

  const CircleTaskView({Key key, @required this.task, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {},
      child: Center(
        child: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(24))),
        ),
      ),
    );
  }
}
