part of 'widgets.dart';

class AnimatedTextField extends StatefulWidget {
  AnimatedTextField({Key? key,
    required this.textController,
    required this.show,
    required this.hintText, this.keyboardType = TextInputType
        .text, this.obscureText = false, this.fromRight = true})
      : super(key: key);

  final TextEditingController textController;
  final bool show;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool fromRight;

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
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
    _scaleAnimation = Tween<double>(begin: 0.0, end: 50.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(
        0.0, 0.8, curve: Curves.easeInOutQuint,
      ),),
    );
  }



  @override
  void didUpdateWidget(AnimatedTextField oldWidget) {
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
    );
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      height: _scaleAnimation.value,
      margin: EdgeInsets.symmetric(vertical: _scaleAnimation.value / 10, horizontal: 5.0),
      child: SlideTransition(
        position: _offsetAnimation,
        child: TextFormField(
          controller: widget.textController,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            hintText: widget.hintText,
          ),
        ),
      ),
    );
  }
}
