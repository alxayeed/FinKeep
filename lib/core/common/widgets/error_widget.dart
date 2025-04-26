import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorIndicatorWidget extends StatelessWidget {
  final String errorMessage;

  const ErrorIndicatorWidget({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DotLottieLoader.fromAsset("assets/lottie/error_cat.lottie",
            frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
          if (dotlottie != null) {
            return Lottie.memory(dotlottie.animations.values.single);
          } else {
            return Container();
          }
        }),
        const SizedBox(height: 10),
        Text(
          errorMessage,
          style: TextStyle(fontSize: 26, color: Colors.black54),
        ),
      ],
    );
  }
}
