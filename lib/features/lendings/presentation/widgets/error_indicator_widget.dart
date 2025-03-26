import 'package:flutter/material.dart';

class ErrorIndicatorWidget extends StatelessWidget {
  final String message;

  const ErrorIndicatorWidget({super.key, required this.message});

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
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
