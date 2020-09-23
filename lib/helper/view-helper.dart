import 'package:flutter/material.dart';
import 'package:hello_flutter/helper/color-helper.dart';

class _ViewHelper {
  void pushView({BuildContext context, Widget view}) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return view;
        },
      ),
    );
  }

  void popView(BuildContext context) {
    Navigator.pop(context);
  }

  /**
   * actions : <Widget>[
      FlatButton(
        child: Text('Approve'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
   */
  Future<void> dialog({
    BuildContext context,
    String title,
    List<Widget> body,
    Function getAction,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: body,
            ),
          ),
          actions: getAction(context),
        );
      },
    );
  }

  void dialogClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> dialogPostAdd({
    BuildContext context,
    List<Widget> body,
    Function viewHandler,
    Function addMoreHandler,
  }) async {
    return ViewHelper.dialog(
      context: context,
      title: "Success",
      body: body,
      getAction: (_context) {
        return [
          FlatButton(
            child: Text('View'),
            onPressed: () {
              viewHandler(_context);
            },
          ),
          FlatButton(
            child: Text('Add More'),
            onPressed: () {
              addMoreHandler(_context);
            },
          ),
        ];
      },
    );
  }

  Future<void> dialogPostEdit({
    BuildContext context,
    List<Widget> body,
    Function gotItHandler,
  }) async {
    return ViewHelper.dialog(
      context: context,
      title: "Success",
      body: body,
      getAction: (_context) {
        return [
          FlatButton(
            child: Text('Got It!'),
            onPressed: () {
              gotItHandler(_context);
            },
          ),
        ];
      },
    );
  }

  void snackbar({
    BuildContext context,
    String text,
    String onPressedLabel,
    Function onPressed,
  }) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            }
          },
        ),
      ),
    );
  }

  Widget loading() {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          CircularProgressIndicator(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget emptyState({
    Widget body,
    String actionText,
    Function actionHandler,
  }) {
    return new Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          Icon(Icons.select_all, size: 100),
          SizedBox(height: 10),
          Text("Nothing To Show Here", style: TextStyle(fontSize: 20)),
          SizedBox(height: 30),
          new RaisedButton(
            color: Colors.teal[400],
            textColor: Colors.white,
            child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  actionText,
                  style: TextStyle(fontSize: 25),
                )),
            onPressed: actionHandler,
          )
        ],
      ),
    );
  }

  Widget titleSection({
    Function onPressed,
    Widget trail = const Text(""),
    String text,
    TextStyle textStyle,
    Widget subtextCustom,
    String subtext,
    TextStyle subtextStyle,
  }) {
    var textView = Text(
      text,
      style: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.bold,
        color: onPressed != null ? ColorHelper.BlueLink : ColorHelper.GreyText,
      ),
    );

    var subtextView;
    if (subtextCustom != null) {
      subtextView = subtextCustom;
    } else {
      subtextView = subtext == null
          ? const Text("")
          : Text(
              subtext,
              style: TextStyle(
                fontSize: 17,
                color: ColorHelper.GreyText,
              ).merge(subtextStyle),
            );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              onPressed != null
                  ? FlatButton(
                      padding: EdgeInsets.only(left: -10),
                      onPressed: onPressed,
                      child: textView,
                    )
                  : textView,
              trail,
            ],
          ),
          subtextView,
        ],
      ),
    );
  }
}

final ViewHelper = _ViewHelper();
