import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/configs/app_colors.dart';

import '../configs/media_QSize.dart';

class MyButton extends StatelessWidget {
  final String buttonLabel;
  final Function()? onPressed;

  const MyButton({
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: AppColors.lightgray,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).disabledColor,
          ),
        ),
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      onPressed: onPressed,
      child: Text(
        buttonLabel,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w700,
          fontSize: 20 * MediaQSize.heightRefScale,
        ),
      ),
    );
  }
}
