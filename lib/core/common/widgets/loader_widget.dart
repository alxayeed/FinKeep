import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DotLottieLoader.fromAsset("assets/lottie/loader_cat.lottie",
        frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
      if (dotlottie != null) {
        return Lottie.memory(dotlottie.animations.values.single);
      } else {
        return Container();
      }
    });
  }
}
