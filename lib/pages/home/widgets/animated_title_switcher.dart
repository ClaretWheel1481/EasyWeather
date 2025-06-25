import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedTextSwitcher extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const AnimatedTextSwitcher({
    super.key,
    required this.text,
    this.style,
  });

  @override
  State<AnimatedTextSwitcher> createState() => _AnimatedTextSwitcherState();
}

enum _SwitchStep { fadeOut, fadeIn }

class _AnimatedTextSwitcherState extends State<AnimatedTextSwitcher> {
  String? _oldText;
  String _currentText = '';
  _SwitchStep _step = _SwitchStep.fadeIn;

  static const int _overlap = 30;
  static const Duration _animDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _currentText = widget.text;
  }

  @override
  void didUpdateWidget(covariant AnimatedTextSwitcher oldWidget) {
    if (oldWidget.text != widget.text) {
      _oldText = _currentText; // 保存当前显示的文本作为旧文本
      _currentText = widget.text; // 更新当前文本
      _step = _SwitchStep.fadeOut;
      setState(() {});
      final oldChars = _oldText?.characters.toList() ?? [];
      final totalOut =
          _overlap * (oldChars.length - 1) + _animDuration.inMilliseconds;
      final interval = (totalOut * 0.8).toInt(); // 0.8倍时就切换
      Future.delayed(Duration(milliseconds: interval), () {
        if (mounted) {
          setState(() {
            _step = _SwitchStep.fadeIn;
            _oldText = null;
          });
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _buildFadeChar(String char, bool isIn, Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: isIn ? 0.0 : 1.0, end: isIn ? 1.0 : 0.0),
      duration: _animDuration,
      curve: Curves.ease,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((isIn ? 20 : -20) * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildAnimatedChars(List<String> chars, bool isIn) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(chars.length, (i) {
        return FutureBuilder(
          future: Future.delayed(Duration(
              milliseconds: _overlap * (isIn ? i : (chars.length - i - 1)))),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Opacity(
                opacity: isIn ? 0.0 : 1.0,
                child: Text(chars[i], style: widget.style),
              );
            }
            return _buildFadeChar(
                chars[i], isIn, Text(chars[i], style: widget.style));
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> newChars = _currentText.characters.toList();
    final List<String>? oldChars = _oldText?.characters.toList();

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        if (_step == _SwitchStep.fadeOut && oldChars != null)
          _buildAnimatedChars(oldChars, false),
        if (_step == _SwitchStep.fadeIn) _buildAnimatedChars(newChars, true),
      ],
    );
  }
}
