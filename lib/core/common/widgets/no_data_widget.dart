import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DotLottieLoader.fromAsset("assets/lottie/no_data.lottie",
            frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
          if (dotlottie != null) {
            return Lottie.memory(dotlottie.animations.values.single);
          } else {
            return Container();
          }
        }),
        const SizedBox(height: 10),
        Text(
          'No data found.',
          style: TextStyle(fontSize: 26, color: Colors.black54),
        ),
      ],
    );
  }
}
