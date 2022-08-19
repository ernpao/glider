import 'package:flutter/material.dart';
import 'package:hover/hover.dart';

class CustomSlider extends StatelessWidget {
  CustomSlider({
    Key? key,
    required this.onChanged,
    this.value = 0.0,
    this.min = 0.0,
    this.max = 1.0,
    this.color,
    this.height = 350,
  })  : assert(min < max),
        assert(value >= min),
        assert(value <= max),
        super(key: key);

  final Function(double value) onChanged;
  final double value;
  final double max;
  final double min;
  final Color? color;
  final double height;

  /// Slider size

  static const double _width = 50;

  /// Slider track constants

  static const double _trackWidth = 20;
  static const _trackLeft = (_width - _trackWidth) / 2;
  static const _trackRadius = Radius.circular(_trackWidth / 2);

  /// Slider thumb constants

  static const double _thumbSize = 40;
  static const _thumbSizeHalf = _thumbSize / 2;
  static const _thumbLeft = (_width - _thumbSize) / 2;
  static const _thumbRadius = BorderRadius.all(Radius.circular(_thumbSizeHalf));
  static const _thumbShadow = [
    BoxShadow(blurRadius: 6, offset: Offset(2, 2), color: Colors.black54)
  ];

  /// Slider position constants

  late final double _maxSliderPos = height - _thumbSize;
  late final double _sliderPos = (value / max) * _maxSliderPos;
  late final Color _sliderColor = color ?? Colors.blue;

  double? _calculateNewVal(BuildContext context, double? dy) {
    if (dy != null) {
      final scrHeight = Hover.getScreenHeight(context);
      double newVal = (value - _scaleDeltaY(scrHeight, dy)).roundToDouble();
      if (min <= value && value <= max) {
        // debugPrint("Slider updated (within limits): $newValue (Delta: $delta)");
        return newVal;
      }
    }
    return null;
  }

  /// Simply scale the delta based on the screen and widget height.
  /// Probably a better implementation would be to scale the
  /// delta based on velocity.

  double _scaleDeltaY(double screenHeight, double dy) {
    return dy * screenHeight / height;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: _width,
        height: height,
        child: Stack(
          children: [
            Positioned(bottom: 0, left: _trackLeft, child: _trackBackground),
            Positioned(bottom: 0, left: _trackLeft, child: _trackForeground),
            Positioned(
              left: _thumbLeft,
              bottom: _sliderPos,
              child: _buildTrackThumb(context),
            )
          ],
        ),
      ),
    );
  }

  late final Widget _trackBackground = Container(
    decoration: const BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.all(_trackRadius),
    ),
    width: _trackWidth,
    height: height,
  );

  late final Widget _trackForeground = Container(
    decoration: BoxDecoration(
      color: _sliderColor,
      borderRadius: _thumbRadius,
    ),
    width: _trackWidth,
    height: _sliderPos + _thumbSizeHalf,
  );

  Widget _buildTrackThumb(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (e) {
        final val = _calculateNewVal(context, e.primaryDelta);
        if (val != null) onChanged(val.clamp(min, max));
      },
      child: Container(
        height: _thumbSize,
        width: _thumbSize,
        decoration: BoxDecoration(
          color: _sliderColor,
          boxShadow: _thumbShadow,
          borderRadius: _thumbRadius,
        ),
      ),
    );
  }
}
