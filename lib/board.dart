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
                child: AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  vsync: this,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: !_addCourse
                          ? Center(
                              child: Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.colorPrimary),
                                    borderRadius: BorderRadius.circular(46)),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextField(
                                  autofocus: true,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: "Course name",
                                  ),
                                  onSubmitted: (value) {},
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xff4B4B4B),
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            )),
                ),
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
