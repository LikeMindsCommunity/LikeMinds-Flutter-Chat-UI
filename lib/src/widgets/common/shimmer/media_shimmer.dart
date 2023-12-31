import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LMMediaShimmer extends StatelessWidget {
  const LMMediaShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black12,
      child: Container(
        color: Colors.white,
        width: screenSize.width,
        height: screenSize.width,
      ),
    );
  }
}
