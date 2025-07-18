import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/weather_warning.dart';

class WarningBanner extends StatefulWidget {
  final List<WeatherWarning> warnings;
  final bool show;
  final Animation<Offset> offsetAnimation;
  final Animation<double> fadeAnimation;
  final VoidCallback onClose;

  const WarningBanner({
    super.key,
    required this.warnings,
    required this.show,
    required this.offsetAnimation,
    required this.fadeAnimation,
    required this.onClose,
  });

  @override
  State<WarningBanner> createState() => _WarningBannerState();
}

class _WarningBannerState extends State<WarningBanner> {
  int _currentWarningIndex = 0;

  void _showPrevWarning() {
    setState(() {
      if (_currentWarningIndex > 0) {
        _currentWarningIndex--;
      }
    });
  }

  void _showNextWarning() {
    setState(() {
      if (_currentWarningIndex < widget.warnings.length - 1) {
        _currentWarningIndex++;
      }
    });
  }

  String formatPubTime(String pubTime) {
    try {
      final dt = DateTime.parse(pubTime).toLocal();
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    } catch (e) {
      return pubTime;
    }
  }

  @override
  void didUpdateWidget(covariant WarningBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果重新显示，重置索引
    if (widget.show && !oldWidget.show) {
      _currentWarningIndex = 0;
    }
    // 如果预警数量变化，重置索引
    if (widget.warnings.length != oldWidget.warnings.length) {
      _currentWarningIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    if (!widget.show || widget.warnings.isEmpty) return const SizedBox.shrink();
    final warning = widget.warnings[_currentWarningIndex];
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: widget.offsetAnimation,
        child: FadeTransition(
          opacity: widget.fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(28),
              color: colorScheme.surface,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16, top: 2),
                          child: Icon(Icons.warning_amber_rounded,
                              color: colorScheme.onSurfaceVariant, size: 36),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                warning.title,
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                warning.text,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${warning.sender}  ${formatPubTime(warning.pubTime)}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // 按钮单独一行，底部居中
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.warnings.length > 1)
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: _currentWarningIndex > 0
                                  ? _showPrevWarning
                                  : null,
                              tooltip: '上一条',
                            ),
                          if (widget.warnings.length > 1)
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: _currentWarningIndex <
                                      widget.warnings.length - 1
                                  ? _showNextWarning
                                  : null,
                              tooltip: '下一条',
                            ),
                          IconButton(
                            icon: Icon(Icons.close,
                                color: colorScheme.onSurfaceVariant),
                            onPressed: widget.onClose,
                            tooltip: '关闭',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
