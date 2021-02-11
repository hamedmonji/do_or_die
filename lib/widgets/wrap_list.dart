import 'package:flutter/material.dart';

class WrapList extends StatelessWidget {
  final List<Widget> children;
  final Widget leading;
  const WrapList({Key key, this.leading, this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          leading,
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
