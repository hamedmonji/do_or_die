import 'dart:math';
import 'dart:ui';

import 'package:do_or_die/data/models.dart';
import 'package:do_or_die/widgets/blur.dart';
import 'package:do_or_die/widgets/morph_input.dart';
import 'package:do_or_die/widgets/wrap_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef TaskBuilder = Widget Function(
    BuildContext context, Task task, int index);

class MutablePath extends StatefulWidget {
  final PathData path;
  final ValueChanged<Task> onTaskCreated;
  final TaskBuilder builder;
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
  final ScrollController scrollController = ScrollController();
  _MutablePathState(this.path);

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    return Container(
      clipBehavior: Clip.antiAlias,
      child: Blur(
        child: Container(
          child: HorizontalWrapList(
              controller: scrollController,
              leading: Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 8, top: 8, bottom: 8),
                child: Center(
                  child: MorphInput(
                    style: TextStyle(fontSize: 14),
                    persitent: true,
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

class StackedPath extends StatelessWidget {
  final PathData path;
  final TaskBuilder builder;
  final double maxWidth;
  StackedPath(
      {Key key,
      @required this.path,
      @required this.builder,
      this.maxWidth = 80})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sublistCount = path.tasks.length == 0
            ? 1
            : ((path.tasks.length + 1) / (constraints.maxWidth / 80)).ceil();
        print(sublistCount);
        final eachPartialitmeCount = constraints.maxWidth ~/ maxWidth;

        final lists = Iterable<int>.generate(sublistCount)
            .toList()
            .asMap()
            .entries
            .map((e) {
          final index = e.key;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildPartialPath(
                constraints,
                path.tasks.sublist(
                    index * eachPartialitmeCount,
                    min((index + 1) * eachPartialitmeCount,
                        path.tasks.length))),
          );
        }).toList();

        return IntrinsicWidth(child: VerticalWrapList(children: lists));
      },
    );
  }

  Widget _buildPartialPath(BoxConstraints constraints, List<Task> tasks) {
    return IntrinsicWidth(
      child: ScrollablePath(
          path: PathData(path.name, tasks: tasks), builder: builder),
    );
  }
}

class ScrollablePath extends StatelessWidget {
  final PathData path;
  final ValueChanged<Task> onTaskTapped;
  final TaskBuilder builder;
  final ScrollController _controller = ScrollController();

  ScrollablePath(
      {Key key, @required this.path, this.onTaskTapped, @required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    return Container(
      clipBehavior: Clip.antiAlias,
      child: Blur(
          child: HorizontalWrapList(
        controller: _controller,
        children: path.tasks.asMap().entries.map((e) {
          final index = e.key;
          final task = e.value;
          return builder(context, task, index);
        }).toList(),
      )),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(24))),
    );
  }
}

class TitleTaskView extends StatelessWidget {
  final Task task;
  final Color color;

  const TitleTaskView({Key key, @required this.task, this.color})
      : super(key: key);
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

class CubeTaskView extends StatelessWidget {
  final Color color;
  final Task task;

  const CubeTaskView({Key key, @required this.task, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {},
      child: Center(
        child: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(24))),
        ),
      ),
    );
  }
}
