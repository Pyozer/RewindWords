import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void initState() {
    super.initState();
    _askPermissions();
  }

  void _askPermissions() async {
    final recordRes =
        await SimplePermissions.requestPermission(Permission.RecordAudio);
    final writeRes = await SimplePermissions.requestPermission(
        Permission.WriteExternalStorage);

    if (recordRes != PermissionStatus.authorized ||
        writeRes != PermissionStatus.authorized) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text("You must accept permissions !"),
        action: SnackBarAction(label: "Ask again", onPressed: _askPermissions),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 174, 56),
        Color.fromARGB(255, 255, 76, 99),
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );

    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.display2
        .copyWith(color: Colors.white, fontWeight: FontWeight.w700);

    final title = Text(
      'Rewind Words',
      style: titleStyle,
      textAlign: TextAlign.center,
    );

    final description = Text(
      'Speak a word, then you will speak this word in reverse after listen it !',
      style: textTheme.title.copyWith(color: Colors.white),
      textAlign: TextAlign.center,
    );

    return Container(
      padding: const EdgeInsets.all(48.0),
      decoration: const BoxDecoration(gradient: gradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 1, child: const SizedBox.shrink()),
          title,
          const SizedBox(height: 42.0),
          description,
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                width: 100.0,
                height: 100.0,
                child: RawMaterialButton(
                  fillColor: Colors.purple,
                  shape: const CircleBorder(),
                  elevation: 5.0,
                  child: const Icon(Icons.mic, color: Colors.white, size: 50.0),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
