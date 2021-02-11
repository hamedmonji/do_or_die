import 'dart:math';
import 'dart:ui';

import 'package:do_or_die/data/models.dart';
import 'package:do_or_die/widgets/blur.dart';
import 'package:do_or_die/widgets/morph_input.dart';
import 'package:do_or_die/widgets/wrap_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MutablePath extends StatefulWidget {
  final PathData path;
  final ValueChanged<Task> onTaskCreated;
  final Widget Function(BuildContext context, Task taks, int index) builder;
  const MutablePath(
      {Key key,
      @required this.path,
      @required this.builder,
      @required this.onTaskCreated})
      : super(key: key);

  @override
  _MutablePathState createState() => _MutablePathState(path);
}

class _MutablePathState extends State<MutablePath>
    with SingleTickerProviderStateMixin {
  final PathData path;

  _MutablePathState(this.path);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      child: Blur(
        child: Container(
          child: WrapList(
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 8),
                child: Center(
                  child: MorphInput(
                    style: TextStyle(fontSize: 14),
                    expandedColor: Colors.primaries[
                        (widget.path.tasks.length + 1) %
                            Colors.primaries.length],
                    inputHint: "Enter tasks's name",
                    onSubmit: (value) {
                      if (value.isNotEmpty) {
                        widget.onTaskCreated(Task(value));
                      }
                    },
                  ),
                ),
              ),
              children: getTasks()),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24), bottomRight: Radius.circular(24))),
    );
  }

  List<Widget> getTasks() {
    return path.tasks.asMap().entries.map<Widget>((e) {
      final index = e.key;
      final task = e.value;
      return widget.builder(context, task, index);
    }).toList();
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
