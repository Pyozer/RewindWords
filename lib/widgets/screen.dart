import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:rewind_words/widgets/divided_view.dart';

class Screen extends StatelessWidget {
  final String title;
  final String desc;
  final Widget child;
  final VoidCallback onBackPressed;
  final String backText;
  final GlobalKey scaffoldKey;

  const Screen({
    Key key,
    @required this.title,
    @required this.desc,
    @required this.child,
    this.onBackPressed,
    this.backText,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          DividedView(title: title, desc: desc, child: child),
          onBackPressed != null
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                    child: GestureDetector(
                      onTap: onBackPressed,
                      child: Row(
                        children: [
                          const Icon(Icons.chevron_left, size: 50.0),
                          Text(
                            (backText ?? FlutterI18n.translate(context, 'back'))
                                .toUpperCase(),
                            style: const TextStyle(fontSize: 18.0),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
