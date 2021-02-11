import 'package:flutter/material.dart';

class HorizontalWrapList extends StatelessWidget {
  final List<Widget> children;
  final Widget leading;
  const HorizontalWrapList({Key key, this.leading, @required this.children})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          if (leading != null) leading,
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class VerticalWrapList extends StatelessWidget {
  final List<Widget> children;
  final Widget leading;
  const VerticalWrapList({Key key, this.leading, @required this.children})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
