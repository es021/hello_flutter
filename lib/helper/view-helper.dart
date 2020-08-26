import 'package:flutter/material.dart';

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
}

final ViewHelper = _ViewHelper();
