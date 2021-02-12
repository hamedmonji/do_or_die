import 'dart:ui';

import 'package:do_or_die/board/board.dart';
import 'package:do_or_die/data/database.dart';
import 'package:do_or_die/data/models.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class BoardsOverView extends StatefulWidget {
  final AppData appData;
  BoardsOverView(this.appData);

  @override
  _BoardsOverViewState createState() => _BoardsOverViewState(appData);
}

class _BoardsOverViewState extends State<BoardsOverView> {
  AppData _appData;

  _BoardsOverViewState(this._appData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    height: 250,
                    margin: const EdgeInsets.all(64),
                    child: ListView.builder(
                      itemCount: _appData.boards.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            width: 250,
                            height: 250,
                            child: Card(
                              child: Center(
                                  child: Text(_appData.boards[index].name)),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Board(
                                    board: _appData.boards[index],
                                  ),
                                ));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 64.0),
                  child: New(
                    inputHint: 'Enter Boards name',
                    title: 'New Board',
                    expanded: false,
                    itemCreated: (String value) async {
                      _appData = await _createBoard(value);
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.jpg"),
                  fit: BoxFit.cover))),
    );
  }

  Future<AppData> _createBoard(String value) async {
    return await addBoard(
        BoardData(value, [PathData.inProgress(), PathData.done()]));
  }
}

class New extends StatefulWidget {
  final ValueChanged<String> itemCreated;
  final String title;
  final String inputHint;
  final bool expanded;
  const New({
    Key key,
    @required this.itemCreated,
    @required this.title,
    @required this.inputHint,
    this.expanded = false,
  }) : super(key: key);

  @override
  _NewState createState() => _NewState(itemCreated);
}

class _NewState extends State<New> with SingleTickerProviderStateMixin<New> {
  bool _addItem = false;
  FocusNode focusNode = FocusNode();
  final ValueChanged<String> itemCreated;

  _NewState(this.itemCreated);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _addItem = !_addItem;
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
                  child: !_addItem
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.expanded)
                              Text(
                                widget.title,
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
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.colorPrimary),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 30),
                                    child: TextField(
                                      focusNode: focusNode,
                                      onSubmitted: (value) {
                                        if (value != null && value.isNotEmpty) {
                                          itemCreated(value);
                                        }
                                        setState(() {
                                          _addItem = false;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: widget.inputHint,
                                      ),
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Color(0xff4B4B4B),
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
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
