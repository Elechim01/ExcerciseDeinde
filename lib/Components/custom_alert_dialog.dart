import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  String error = "";
  Future<void> Function() request;
  CustomAlertDialog({
    Key? key,
    required this.error,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Error\n${error.toString()}",
      ),
      actions: [
        TextButton(
            onPressed: () async {
              await request().then((value) {
                Navigator.of(context).pop();
              });
            },
            child: const Text("try again"))
      ],
    );
  }
}
