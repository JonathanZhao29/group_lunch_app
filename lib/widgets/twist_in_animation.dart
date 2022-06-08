part of 'widgets.dart';

class TappableTwistInAnimation extends StatefulWidget {
  const TappableTwistInAnimation(
      {required this.child, this.onTap, this.size, Key? key})
      : super(key: key);

  final Widget child;
  final Function? onTap;
  final double? size;

  @override
  State<TappableTwistInAnimation> createState() =>
      _TappableTwistInAnimationState();
}


class _TappableTwistInAnimationState extends State<TappableTwistInAnimation> {
  double _animationValue = 0.0;

  void _animate() {
    if(!this.mounted) return;
    setState(() {
      _animationValue = _animationValue < 0.5 ? 1.0 : 0.1;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(milliseconds: 1000));
      _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _animate();
          widget.onTap?.call();
        },
        child: Container(
            width: widget.size ?? 100,
            height: widget.size ?? 100,
            color: Theme.of(context).canvasColor,
            // color: Colors.green,
            child: AnimatedScale(
              scale: _animationValue,
              duration: const Duration(seconds: 2),
              curve: Curves.elasticOut,
              child: AnimatedRotation(
                turns: _animationValue,
                duration: const Duration(seconds: 2),
                child: widget.child,
                curve: Curves.elasticOut,
              ),
            )));
  }
}
