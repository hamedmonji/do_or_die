import 'dart:math';

import 'package:do_or_die/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class MorphInput extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  final String inputHint;
  final Color color;
  final Color expandedColor;
  final bool persitent;

  const MorphInput({
    Key key,
    @required this.style,
    @required this.onSubmit,
    @required this.inputHint,
    this.color = Colors.pink,
    this.expandedColor = Colors.black,
    this.persitent = false,
  }) : super(key: key);

  final TextStyle style;

  @override
  _MorphInputState createState() => _MorphInputState();
}

class _MorphInputState extends State<MorphInput> {
  bool _expanded = false;
  final FocusNode focusNode = FocusNode();
  double itemSize = 100;
  double initialSize;
  final TextEditingController inputController = TextEditingController();
  @override
  void initState() {
    super.initState();
    initialSize = textSize(widget.inputHint, widget.style);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
          focusNode.requestFocus();
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 46,
        constraints: BoxConstraints(
            maxHeight: 46,
            minHeight: 46,
            minWidth: 46,
            maxWidth: !_expanded ? 46 : max(itemSize, initialSize) + 70),
        child: _expanded
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: TextField(
                    focusNode: focusNode,
                    controller: inputController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.inputHint,
                    ),
                    onChanged: (value) {
                      setState(() {
                        itemSize = textSize(value, widget.style);
                      });
                    },
                    onSubmitted: (value) {
                      widget.onSubmit(value);
                      if (widget.persitent && value.isNotEmpty) {
                        inputController.clear();
                        return;
                      }
                      setState(() {
                        _expanded = false;
                      });
                    },
                    style: widget.style,
                  ),
                ),
              )
            : null,
        decoration: BoxDecoration(
            border: Border.all(
                color: _expanded ? widget.expandedColor : widget.color),
            borderRadius: BorderRadius.circular(46)),
      ),
    );
  }
}
