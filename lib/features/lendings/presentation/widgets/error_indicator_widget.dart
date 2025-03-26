import 'package:flutter/material.dart';

class ErrorIndicatorWidget extends StatelessWidget {
  final String message;

  const ErrorIndicatorWidget({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.redAccent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
