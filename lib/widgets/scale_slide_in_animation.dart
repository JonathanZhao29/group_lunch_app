part of 'widgets.dart';

class ScaleSlideInAnimation extends StatefulWidget {
  ScaleSlideInAnimation({Key? key,
    required this.child,
    required this.show, this.fromRight = true})
      : super(key: key);

  final Widget child;
  final bool show;
  final bool fromRight;

  @override
  State<ScaleSlideInAnimation> createState() => _ScaleSlideInAnimationState();
}

class _ScaleSlideInAnimationState extends State<ScaleSlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _offsetAnimation =
        Tween<Offset>(begin: Offset(widget.fromRight ? 1.1 : -1.1, 0.0), end: Offset.zero).animate(
            CurvedAnimation(parent: _controller, curve: Interval(
              0.10, 1.0, curve: Curves.elasticInOut,
            )));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 70).animate(
      CurvedAnimation(parent: _controller, curve: Interval(
        0.0, 0.8, curve: Curves.easeInOutQuint,
      ),),
    );
  }



  @override
  void didUpdateWidget(ScaleSlideInAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show) {
      _controller.forward();
    } else {
      _controller.stop();
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.show) {
      _controller.forward();
    }
      return AnimatedBuilder(
      animation: _controller,
      builder: _buildAnimation,
        child: widget.child,
    );
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      height: _scaleAnimation.value,
      margin: EdgeInsets.symmetric(vertical: _scaleAnimation.value / 10, horizontal: 5.0),
      child: SlideTransition(
        position: _offsetAnimation,
        // child: _scaleAnimation.value > 25 ? child : SizedBox(height: _scaleAnimation.value, width: double.infinity,),
        child: child,
      ),
    );
  }
}
