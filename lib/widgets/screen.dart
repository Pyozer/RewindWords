import 'package:flutter/material.dart';
import 'package:rewind_words/widgets/divided_view.dart';
import 'package:rewind_words/widgets/icon_btn.dart';

class Screen extends StatelessWidget {
  final String title;
  final String desc;
  final Widget child;
  final VoidCallback onBackPressed;

  const Screen({
    Key key,
    this.title,
    this.desc,
    this.onBackPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        DividedView(title: title, desc: desc, child: child),
        onBackPressed != null
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                  child: SimpleIconBtn(
                    icon: Icons.chevron_left,
                    onPressed: onBackPressed,
                    size: 50.0,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
