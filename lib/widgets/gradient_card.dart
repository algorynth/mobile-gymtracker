import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool isGlass;

  const GradientCard({
    Key? key,
    required this.child,
    this.gradient,
    this.padding,
    this.onTap,
    this.isGlass = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isGlass ? null : (gradient ?? AppColors.cardGradient),
        color: isGlass ? AppColors.glassWhite : null,
        borderRadius: BorderRadius.circular(20),
        border: isGlass
            ? Border.all(color: AppColors.glassBorder, width: 1)
            : Border.all(color: AppColors.darkBorder.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );

    if (isGlass) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: content,
        ),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

class AnimatedGradientCard extends StatefulWidget {
  final Widget child;
  final Gradient gradient;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AnimatedGradientCard({
    Key? key,
    required this.child,
    required this.gradient,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedGradientCard> createState() => _AnimatedGradientCardState();
}

class _AnimatedGradientCardState extends State<AnimatedGradientCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        padding: widget.padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (widget.gradient.colors.first).withOpacity(_isPressed ? 0.2 : 0.4),
              blurRadius: _isPressed ? 10 : 20,
              offset: Offset(0, _isPressed ? 3 : 8),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
