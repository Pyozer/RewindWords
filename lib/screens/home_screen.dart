import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:reverse_audio/reverse_audio.dart';
import 'package:rewind_words/screens/play_screen.dart';
import 'package:rewind_words/utils/file.dart';
import 'package:rewind_words/utils/permissions.dart';
import 'package:rewind_words/widgets/divided_view.dart';
import 'package:rewind_words/widgets/record_btn.dart';
import 'package:simple_permissions/simple_permissions.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  void _askPermissions() async {
    final isAllOk = await requestPermissions(
      [Permission.RecordAudio, Permission.WriteExternalStorage],
    );

    if (!isAllOk) {
      _showPermissionAlert();
    }
  }

  void _showPermissionAlert() {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text("You must accept permissions !"),
      action: SnackBarAction(label: "Ask again", onPressed: _askPermissions),
    ));
  }

  void _onBtnPressed() {
    if (_isRecording)
      _stopRecord();
    else
      _startRecord();
  }

  void _startRecord() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        final filePath = await getRecordFilePath();
        await deleteFile(filePath);

        await AudioRecorder.start(path: filePath);

        bool isRecording = await AudioRecorder.isRecording;
        setState(() => _isRecording = isRecording);
      } else {
        _showPermissionAlert();
      }
    } catch (e) {
      print(e);
    }
  }

  void _stopRecord() async {
    await AudioRecorder.stop();
    bool isRecording = await AudioRecorder.isRecording;
    setState(() => _isRecording = isRecording);

    String recordFile = await getRecordFilePath();
    String reversedFile = await getReverseRecordFilePath();

    await deleteFile(await getReverseRecordFilePath());

    try {
      await ReverseAudio.reverseFile(recordFile, reversedFile);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlayerScreen(playReverse: true)));
    } catch (e) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DividedView(
      title: 'Rewind Words',
      desc:
          'Speak something, after listen the result in reversed, you will speak it to listen the reverse reversed.',
      child: Center(
        child: RecordButton(
          isRecording: _isRecording,
          onPressed: _onBtnPressed,
        ),
      ),
    );
  }
}
