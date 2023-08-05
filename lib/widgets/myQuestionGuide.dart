import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/configs/media_QSize.dart';
import 'package:tinnitus_quizs/quiz_models/PsqiAns.dart';

import '../configs/app_colors.dart';

typedef MyOnTap = void Function(double position);

class QuestionGuide extends StatelessWidget {
  final int totalQuestions;
  final int farthestAnsweredQuestion;
  final int currentQuestion;
  final MyOnTap? myOnTap;
  final bool isPSQI;

  const QuestionGuide(
      {required this.totalQuestions,
      required this.farthestAnsweredQuestion,
      required this.currentQuestion,
      this.myOnTap,
      required this.isPSQI});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16 * MediaQSize.widthRefScale, //小方块间距
      runSpacing: 8 * MediaQSize.heightRefScale,
      children: List.generate(totalQuestions, (index) {
        Color color = AppColors.lightblue; // 默认颜色为淡蓝色

        if (index <= farthestAnsweredQuestion) {
          color = AppColors.lPurple; // 已作答题目的淡紫色
        }

        if (index == currentQuestion) {
          return _buildCurrentQuestionBox(index + 1, color);
        } else {
          return _buildQuestionBox(index + 1, color); //未作答
        }
      }),
    );
  }

//当前题 一律没有标记
  Widget _buildCurrentQuestionBox(int questionNumber, Color color) {
    return GestureDetector(
      onTap: () {
        // 当前题目点击事件
        // 编写跳转逻辑或其他所需操作
        print('点击了当前题目 $questionNumber');
      },
      child: Container(
        width: 35 * MediaQSize.widthRefScale,
        height: 35 * MediaQSize.widthRefScale,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0) * MediaQSize.widthRefScale,
        ),
        child: Center(
          child: Text(
            isPSQI
                ? PSQIRelatedStruct.getPsqiHeadStr(questionNumber - 1)
                : "$questionNumber",
            style: TextStyle(
                color: AppColors.pPurple,
                fontWeight: FontWeight.bold,
                fontSize: 18 * MediaQSize.widthRefScale),
          ),
        ),
      ),
    );
  }

// 已作答和未作答的一起
  Widget _buildQuestionBox(int questionNumber, Color color) {
    return GestureDetector(
      onTap: () {
        // 其他已作答题目点击事件
        // 编写所需操作，例如弹出提示或禁用点击

        print('点击了题目 $questionNumber');
        myOnTap!(questionNumber.toDouble());
      },
      child: Stack(
        children: [
          Container(
            width: 35 * MediaQSize.widthRefScale,
            height: 35 * MediaQSize.widthRefScale,
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(8.0) * MediaQSize.widthRefScale,
            ),
            child: Center(
              child: Text(
                isPSQI
                    ? PSQIRelatedStruct.getPsqiHeadStr(questionNumber - 1)
                    : "$questionNumber",
                style: TextStyle(
                    color: (questionNumber <= farthestAnsweredQuestion + 1)
                        ? AppColors.pPurple
                        : Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 15 * MediaQSize.widthRefScale),
              ),
            ),
          ),
          // 只有已作答的才有对勾标记
          if (questionNumber <= farthestAnsweredQuestion + 1)
            //⭕和√
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 12.0 * MediaQSize.widthRefScale,
                height: 12.0 * MediaQSize.widthRefScale,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.purple,
                    width: 1 * MediaQSize.widthRefScale,
                  ),
                ),
                child: Icon(
                  Icons.check,
                  size: 10.0 * MediaQSize.widthRefScale,
                  color: Colors.purple,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
