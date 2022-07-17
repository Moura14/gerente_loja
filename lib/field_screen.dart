import 'package:flutter/material.dart';

class FieldScreen extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChenged;
  FieldScreen(this.hint, this.icon, this.obscure, this.stream, this.onChenged);
  //const FieldScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snaphsot) {
        return TextField(
          onChanged: onChenged,
          decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pinkAccent)),
            contentPadding:
                EdgeInsets.only(left: 5, right: 30, bottom: 30, top: 30),
            errorText: snaphsot.hasError ? snaphsot.error : null,
          ),
          obscureText: obscure,
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }
}
