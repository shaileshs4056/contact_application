import 'package:flutter/material.dart';
import 'package:contact_number_demo/values/colors.dart';

class CustomDotsIndicator extends StatelessWidget {
  final int currentIndex;
  final int index;

  const CustomDotsIndicator({
    required this.currentIndex,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 4,
      width: currentIndex == index ? 60 : 25,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color:
            currentIndex == index ? AppColor.primaryColor : AppColor.osloGray,
      ),
    );
  }
}
