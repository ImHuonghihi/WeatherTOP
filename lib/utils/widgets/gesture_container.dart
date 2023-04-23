import 'package:flutter/cupertino.dart';

class GestureContainer extends GestureDetector {
  // constructor of GestureContain which is a subclass of Container
  GestureContainer({
    Key? key,
    required Widget child,
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    GestureDragUpdateCallback? onHorizontalDragUpdate,
    GestureDragUpdateCallback? onVerticalDragUpdate,
    GestureDragEndCallback? onHorizontalDragEnd,
    GestureDragEndCallback? onVerticalDragEnd,
    AlignmentGeometry alignment = Alignment.center,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry transformAlignment = Alignment.center,
    Clip clipBehavior = Clip.none,
  }) : super(
            key: key,
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongPress,
            onHorizontalDragUpdate: onHorizontalDragUpdate,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onHorizontalDragEnd: onHorizontalDragEnd,
            onVerticalDragEnd: onVerticalDragEnd,
            child: Container(
              alignment: alignment,
              padding: padding,
              color: color,
              decoration: decoration,
              foregroundDecoration: foregroundDecoration,
              width: width,
              height: height,
              constraints: constraints,
              margin: margin,
              transform: transform,
              transformAlignment: transformAlignment,
              clipBehavior: clipBehavior,
              child: child,
            ));

  // turn container into a gesture detector
  GestureContainer.fromContainer(
    Container container, {
    Key? key,
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    GestureDragUpdateCallback? onHorizontalDragUpdate,
    GestureDragUpdateCallback? onVerticalDragUpdate,
    GestureDragEndCallback? onHorizontalDragEnd,
    GestureDragEndCallback? onVerticalDragEnd,
  }) : super(
          key: key,
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onHorizontalDragUpdate: onHorizontalDragUpdate,
          onVerticalDragUpdate: onVerticalDragUpdate,
          onHorizontalDragEnd: onHorizontalDragEnd,
          onVerticalDragEnd: onVerticalDragEnd,
          child: container,
        );

    // turn into gesture detector constrainted box
  GestureContainer.constrainedBox({
    Key? key,
    required Widget child,
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    GestureDragUpdateCallback? onHorizontalDragUpdate,
    GestureDragUpdateCallback? onVerticalDragUpdate,
    GestureDragEndCallback? onHorizontalDragEnd,
    GestureDragEndCallback? onVerticalDragEnd,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
  }) : super(
          key: key,
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onHorizontalDragUpdate: onHorizontalDragUpdate,
          onVerticalDragUpdate: onVerticalDragUpdate,
          onHorizontalDragEnd: onHorizontalDragEnd,
          onVerticalDragEnd: onVerticalDragEnd,
          child: ConstrainedBox(
            constraints: constraints!,
            child: Container(
              margin: margin,
              child: child,
            ),
          ),
        );
}
