import 'package:flutter/material.dart';

import '../configs/app_colors.dart';
import '../configs/media_QSize.dart';

class MyButton extends StatelessWidget {
  final String buttonLabel;
  final Function()? onPressed;
  // final AssetImage img;
  const MyButton({
    required this.buttonLabel,
    required this.onPressed,
    // required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors.white,
        backgroundColor: AppColors.pPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(
            color: AppColors.pPurple,
          ),
        ),
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: 25.5 * 7 * MediaQSize.widthRefScale,
        height: 8.8 * 7 * MediaQSize.widthRefScale,
        child: Center(
          child: Text(
            buttonLabel,
            style: TextStyle(
              // color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20 * MediaQSize.heightRefScale,
            ),
          ),
        ),
      ),
    );
  }
}
