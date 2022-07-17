import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {
  final _controller = TextEditingController();
  //const AddSizeDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _controller),
            Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(_controller.text);
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.pinkAccent),
                    )))
          ],
        ),
      ),
    );
  }
}
