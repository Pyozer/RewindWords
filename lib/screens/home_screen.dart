import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:reverse_audio/reverse_audio.dart';
import 'package:rewind_words/screens/play_screen.dart';
import 'package:rewind_words/utils/file.dart';
import 'package:rewind_words/utils/permissions.dart';
import 'package:rewind_words/widgets/record_btn.dart';
import 'package:rewind_words/widgets/screen.dart';
import 'package:simple_permissions/simple_permissions.dart';

class HomeScreen extends StatefulWidget {
  final bool speakInReverse;

  const HomeScreen({Key key, this.speakInReverse = false}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _askPermissions().then((isOk) {
      if (isOk && widget.speakInReverse) _startRecord();
    });
  }

  @override
  void dispose() {
    _stopRecord();
    super.dispose();
  }

  Future<bool> _askPermissions() async {
    final isAllOk = await requestPermissions(
      [Permission.RecordAudio, Permission.WriteExternalStorage],
    );

    if (!isAllOk) {
      _showPermissionAlert();
    }
    return isAllOk;
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
    if (!mounted) return;
    setState(() => _isRecording = false);

    String recordFile = await getRecordFilePath();
    String reversedFile = !widget.speakInReverse
        ? await getReverseRecordFilePath()
        : await getRReverseRecordFilePath();

    await deleteFile(reversedFile);

    try {
      await ReverseAudio.reverseFile(recordFile, reversedFile);

      final route = MaterialPageRoute(
        builder: (context) => PlayerScreen(isInReverse: widget.speakInReverse),
      );

      if (widget.speakInReverse)
        Navigator.of(context).pushReplacement(route);
      else
        Navigator.of(context).push(route);
    } catch (e) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: !widget.speakInReverse ? 'Rewind Words' : 'Speak reverse',
      desc: !widget.speakInReverse
          ? 'Speak a word, you will listen it after in reverse.'
          : 'Speak the word in reverse, you will listen it reverse after.',
      child: Center(
        child: RecordButton(
          isRecording: _isRecording,
          onPressed: _onBtnPressed,
        ),
      ),
      onBackPressed: widget.speakInReverse
          ? () {
              Navigator.of(context).pop();
            }
          : null,
    );
  }
}
