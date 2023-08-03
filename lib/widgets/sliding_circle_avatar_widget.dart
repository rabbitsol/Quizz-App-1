import 'package:flutter/material.dart';

class SlidingCircleAvatar extends StatefulWidget {
  final String text;
  final AnimationController? animationController;

  SlidingCircleAvatar({
    super.key,
    required this.text,
    this.animationController,
  });

  @override
  _SlidingCircleAvatarState createState() => _SlidingCircleAvatarState();
}

class _SlidingCircleAvatarState extends State<SlidingCircleAvatar>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.animationController != null) {
      _slideAnimation = Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: widget.animationController!,
        curve: Curves.easeInOut,
      ));

      widget.animationController!.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.animationController != null
        ? SlideTransition(
            position: _slideAnimation,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(widget.text),
              ),
              title: Text(widget.text),
            ),
          )
        : ListTile(
            leading: CircleAvatar(
              child: Text(widget.text),
            ),
            title: Text(widget.text),
          );
  }
}
