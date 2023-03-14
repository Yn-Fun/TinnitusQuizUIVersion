import 'dart:math';

import 'package:flutter/material.dart';

import '../configs/media_QSize.dart';

/// Folding Cell Widget
class FoldingCell extends StatefulWidget {
  const FoldingCell.create(
      {Key? key,
      required this.frontWidget,
      required this.innerWidget,
      this.cellSize = const Size(100.0, 100.0),
      this.unfoldCell = false,
      this.skipAnimation = false,
      this.padding =
          const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 10),
      this.animationDuration = const Duration(milliseconds: 500),
      this.borderRadius = 0.0,
      this.onOpen,
      this.onClose})
      : assert(frontWidget != null),
        assert(innerWidget != null),
        assert(cellSize != null),
        assert(unfoldCell != null),
        assert(skipAnimation != null),
        assert(padding != null),
        assert(animationDuration != null),
        assert(borderRadius != null && borderRadius >= 0.0),
        super(key: key);

  // Front widget in folded cell
  final Widget? frontWidget;

  /// Inner widget in unfolded cell
  final Widget? innerWidget;

  /// Size of cell
  final Size? cellSize;

  /// If true cell will be unfolded when created, if false cell will be folded when created
  final bool? unfoldCell;

  /// If true cell will fold and unfold without animation, if false cell folding and unfolding will be animated
  final bool? skipAnimation;

  /// Padding around cell
  final EdgeInsetsGeometry? padding;

  /// Animation duration
  final Duration? animationDuration;

  /// Rounded border radius
  final double? borderRadius;

  /// Called when cell fold animations completes
  final VoidCallback? onOpen;

  /// Called when cell unfold animations completes
  final VoidCallback? onClose;

  @override
  FoldingCellState createState() => FoldingCellState();
}

class FoldingCellState extends State<FoldingCell>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: widget.animationDuration);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.onOpen != null) widget.onOpen!();
      } else if (status == AnimationStatus.dismissed) {
        if (widget.onClose != null) widget.onClose!();
      }
    });

    if (widget.unfoldCell == true) {
      _animationController.value = 1;
      _isExpanded = true;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final angle = _animationController.value * pi;
          final cellWidth = widget.cellSize?.width;
          final cellHeight = widget.cellSize?.height;

          return Padding(
            padding: widget.padding!,
            child: Container(
              color: Colors.transparent,
              // color: Colors.red,//调试用

              width: cellWidth,
              // height: cellHeight! + (cellHeight * _animationController.value),//动态容器
              height: _isExpanded
                  ? cellHeight! + (cellHeight * _animationController.value)
                  : //后期修改的：假的家的高度[修改处]
                  max(cellHeight! + (cellHeight * _animationController.value),
                      130 * MediaQSize.heightRefScale),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(widget.borderRadius!),
                        topRight: Radius.circular(widget.borderRadius!)),
                    child: SizedBox(
                      width: cellWidth,
                      height: cellHeight,
                      child: OverflowBox(
                        minHeight: cellHeight,
                        maxHeight: cellHeight * 2, //内页1
                        alignment: Alignment.topCenter,
                        child: ClipRect(
                          child: Align(
                            heightFactor: 0.5,
                            alignment: Alignment.topCenter,
                            child: widget.innerWidget, //内页1
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(angle),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(pi),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(widget.borderRadius!),
                            bottomRight: Radius.circular(widget.borderRadius!)),
                        child: SizedBox(
                          width: cellWidth,
                          height: cellHeight, //内页高度2
                          child: OverflowBox(
                            minHeight: cellHeight,
                            maxHeight: cellHeight * 2,
                            alignment: Alignment.topCenter,
                            child: ClipRect(
                              child: Align(
                                heightFactor: 0.5,
                                alignment: Alignment.bottomCenter,
                                child: widget.innerWidget, //内页2
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(angle),
                    child: Opacity(
                      opacity: angle >= 1.5708 ? 0.0 : 1.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(widget.borderRadius!),
                            topRight: Radius.circular(widget.borderRadius!)),
                        child: SizedBox(
                          // width: angle >= 1.5708 ? 0.0 : cellWidth,
                          // height: angle >= 1.5708 ? 0.0 : cellHeight, //动态的高度
                          width: angle >= 1.5708 ? 0.0 : cellWidth,
                          height:
                              angle >= 1.5708 ? 0.0 : cellWidth, //动态的高度（外壳的）
                          child: widget.frontWidget, //外页高度改掉
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void toggleFold() {
    if (_isExpanded) {
      if (widget.skipAnimation == true) {
        _animationController.value = 0;
      } else {
        _animationController.reverse();
      }
    } else {
      if (widget.skipAnimation == true) {
        _animationController.value = 1;
      } else {
        _animationController.forward();
      }
    }
    _isExpanded = !_isExpanded;
  }
}
