import 'package:flutter/material.dart';

const kGradient = LinearGradient(
  colors: [Color(0xFF4776e6), Color(0xFF8e54e9)],
  begin: Alignment.topRight,
  end: Alignment.bottomRight,
);

class DividedView extends StatelessWidget {
  final Gradient gradient;
  final String title;
  final String desc;
  final Widget child;

  const DividedView({
    Key key,
    this.gradient = kGradient,
    @required this.title,
    this.desc = "",
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.display2.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    final mainTitle = Text(
      title,
      style: titleStyle,
      textAlign: TextAlign.center,
    );

    final description = Text(
      desc,
      style: textTheme.title,
      textAlign: TextAlign.center,
    );

    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  mainTitle,
                  const SizedBox(height: 42.0),
                  description,
                ],
              ),
            ),
            Expanded(flex: 4, child: child),
          ],
        ),
      ),
    );
  }
}
