import 'dart:ui';

import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: NewPath(),
        ),
      ),
    );
  }
}

class NewPath extends StatefulWidget {
  const NewPath({
    Key key,
  }) : super(key: key);

  @override
  _NewPathState createState() => _NewPathState();
}

class _NewPathState extends State<NewPath>
    with SingleTickerProviderStateMixin<NewPath> {
  bool _addPath = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _addPath = !_addPath;
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
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: !_addPath
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "New Path",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Color(0xff4B4B4B),
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.pinkAccent,
                            )
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Enter path's name",
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
    );
  }
}
