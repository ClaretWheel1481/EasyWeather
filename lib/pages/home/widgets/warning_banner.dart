import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/weather_warning.dart';

class WarningBanner extends StatefulWidget {
  final List<WeatherWarning> warnings;
  final VoidCallback onClose;

  const WarningBanner({
    super.key,
    required this.warnings,
    required this.onClose,
  });

  @override
  State<WarningBanner> createState() => _WarningBannerState();
}

class _WarningBannerState extends State<WarningBanner>
    with TickerProviderStateMixin {
  int _currentWarningIndex = 0;

  void _showPrevWarning() {
    if (_currentWarningIndex > 0) {
      setState(() {
        _currentWarningIndex--;
      });
    }
  }

  void _showNextWarning() {
    if (_currentWarningIndex < widget.warnings.length - 1) {
      setState(() {
        _currentWarningIndex++;
      });
    }
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
    if (widget.warnings.length != oldWidget.warnings.length) {
      _currentWarningIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final warning = widget.warnings[_currentWarningIndex];

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.errorContainer.withValues(alpha: 0.08),
                  colorScheme.errorContainer.withValues(alpha: 0.04),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: colorScheme.onErrorContainer,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              warning.title,
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              warning.text,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${warning.sender} • ${formatPubTime(warning.pubTime)}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.6),
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.warnings.length > 1)
                        Text(
                          '${_currentWarningIndex + 1} / ${widget.warnings.length}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      Row(
                        children: [
                          if (widget.warnings.length > 1) ...[
                            IconButton(
                              onPressed: _currentWarningIndex > 0
                                  ? _showPrevWarning
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                              style: IconButton.styleFrom(
                                foregroundColor: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _currentWarningIndex <
                                      widget.warnings.length - 1
                                  ? _showNextWarning
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                              style: IconButton.styleFrom(
                                foregroundColor: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          IconButton(
                            onPressed: widget.onClose,
                            icon: const Icon(Icons.close),
                            style: IconButton.styleFrom(
                              foregroundColor: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
