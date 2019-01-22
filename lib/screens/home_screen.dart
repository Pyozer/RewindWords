import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:reverse_audio/reverse_audio.dart';
import 'package:rewind_words/screens/play_screen.dart';
import 'package:rewind_words/utils/file.dart';
import 'package:rewind_words/utils/permissions.dart';
import 'package:rewind_words/utils/translation.dart';
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
    _askPermissions();
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

    if (!isAllOk) _showPermissionAlert();
    return isAllOk;
  }

  void _showPermissionAlert() {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(
        getString(context, StringKeys.permission_denied),
      ),
      action: SnackBarAction(
        label: getString(context, StringKeys.ask_again),
        onPressed: _askPermissions,
      ),
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

        await AudioRecorder.start(path: filePath, bitRate: 128000);

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
      Navigator.of(context).push(route);
    } catch (e) {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleK = widget.speakInReverse
        ? StringKeys.home_reverse_title
        : StringKeys.home_title;
    final descK = widget.speakInReverse
        ? StringKeys.home_reverse_desc
        : StringKeys.home_desc;
    final backK = widget.speakInReverse
        ? StringKeys.listen_again
        : StringKeys.record_again;

    return Screen(
      scaffoldKey: _scaffoldKey,
      title: getString(context, titleK),
      desc: getString(context, descK),
      child: Center(
        child: Column(
          children: [
            RecordButton(isRecording: _isRecording, onPressed: _onBtnPressed),
            const SizedBox(height: 32.0),
            Text(
              _isRecording
                  ? getString(context, StringKeys.recording)
                  : "",
            ),
          ],
        ),
      ),
      onBackPressed: widget.speakInReverse
          ? () {
              Navigator.of(context).pop();
            }
          : null,
      backText: getString(context, backK),
    );
  }
}
