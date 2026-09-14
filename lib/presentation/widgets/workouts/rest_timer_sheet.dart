import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/constants.dart';

/// Opens the rest countdown timer as a bottom sheet.
void showRestTimerSheet(
  BuildContext context, {
  required int seconds,
  String? title,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => RestTimerSheet(seconds: seconds, title: title),
  );
}

/// Countdown timer for rest between sets: circular progress, pause/resume,
/// restart and +30s. Vibrates and auto-closes when the rest is over.
class RestTimerSheet extends StatefulWidget {
  final int seconds;
  final String? title;

  const RestTimerSheet({super.key, required this.seconds, this.title});

  @override
  State<RestTimerSheet> createState() => _RestTimerSheetState();
}

class _RestTimerSheetState extends State<RestTimerSheet> {
  late int _total;
  late int _remaining;
  Timer? _timer;
  bool _paused = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _total = widget.seconds;
    _remaining = widget.seconds;
    _start();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_paused || _done) return;
    if (!mounted) return;
    setState(() => _remaining--);
    if (_remaining <= 0) {
      _timer?.cancel();
      setState(() => _done = true);
      HapticFeedback.heavyImpact();
      // Second buzz shortly after, so it's noticeable mid-workout.
      Future.delayed(const Duration(milliseconds: 300), () {
        HapticFeedback.heavyImpact();
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  void _restart() {
    setState(() {
      _remaining = _total;
      _done = false;
      _paused = false;
    });
    _start();
  }

  void _addThirty() {
    setState(() {
      _total += 30;
      _remaining += 30;
      if (_done) {
        _done = false;
        _start();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _display {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 12, 24, MediaQuery.of(context).padding.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _done ? 'Rest complete!' : (widget.title ?? 'Rest'),
            style: AppTypography.h3,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _total == 0 ? 0 : _remaining / _total,
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  color: _done ? AppColors.mintDark : AppColors.pinkDark,
                  backgroundColor: AppColors.gray100,
                ),
                Center(
                  child: _done
                      ? Icon(PhosphorIcons.check(PhosphorIconsStyle.bold),
                          size: 56, color: AppColors.mintDark)
                      : Text(
                          _display,
                          style: AppTypography.h1.copyWith(
                            fontWeight: FontWeight.w800,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundButton(
                icon: PhosphorIcons.arrowCounterClockwise(),
                label: 'Restart',
                onTap: _restart,
              ),
              const SizedBox(width: 16),
              _RoundButton(
                icon: _paused ? PhosphorIcons.play() : PhosphorIcons.pause(),
                label: _paused ? 'Resume' : 'Pause',
                isPrimary: true,
                onTap: _done ? null : _togglePause,
              ),
              const SizedBox(width: 16),
              _RoundButton(
                icon: PhosphorIcons.plus(),
                label: '+30s',
                onTap: _addThirty,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  const _RoundButton({
    required this.icon,
    required this.label,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isPrimary ? 64 : 52,
            height: isPrimary ? 64 : 52,
            decoration: BoxDecoration(
              color: disabled
                  ? AppColors.gray100
                  : isPrimary
                      ? AppColors.pinkDark
                      : AppColors.pinkLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: disabled
                  ? AppColors.gray400
                  : isPrimary
                      ? AppColors.white
                      : AppColors.pinkDark,
              size: isPrimary ? 28 : 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.captionSmall),
        ],
      ),
    );
  }
}
