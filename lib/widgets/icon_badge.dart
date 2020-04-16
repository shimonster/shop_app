import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  IconBadge(this.child, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned(
          right: 2,
          top: 2,
          child: Container(
            padding: EdgeInsets.all(3),
            constraints:
                BoxConstraints(minWidth: 18, minHeight: 18, maxHeight: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
            child: FittedBox(child: Text(value), alignment: Alignment.center,),
          ),
        )
      ],
    );
  }
}
