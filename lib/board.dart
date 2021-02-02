import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final List<String> paths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var path in paths)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Path(path),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: NewPath(
                  expanded: paths.isEmpty,
                  pathCreated: (String newPath) {
                    setState(() {
                      paths.add(newPath);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Path extends StatefulWidget {
  final String path;
  Path(this.path);

  @override
  _PathState createState() => _PathState();
}

class _PathState extends State<Path> with SingleTickerProviderStateMixin {
  bool _addCourse = false;
  FocusNode focusNode = FocusNode();
  GlobalKey<AnimatedListState> listKey = GlobalKey();

  final List<String> items = [];
  double itemSize = 100;
  double initialSize;
  TextStyle style = TextStyle(
      fontSize: 22, color: Color(0xff4B4B4B), fontWeight: FontWeight.w300);
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
                            duration: Duration(milliseconds: 300),
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
                                          items.add(value);
                                          listKey.currentState
                                              .insertItem(items.length - 1);
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
                                        ? Colors.primaries[(items.length + 1) %
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
                          initialItemCount: items.length,
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
                                    hintText: "Enter path's name",
                                  ),
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xff4B4B4B),
                                      fontWeight: FontWeight.w300),
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
