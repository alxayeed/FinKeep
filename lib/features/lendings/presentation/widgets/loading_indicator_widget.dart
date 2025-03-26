import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final Color color;

  const LoadingIndicatorWidget({super.key, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
