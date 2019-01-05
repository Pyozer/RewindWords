import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:reverse_audio/reverse_audio.dart';
import 'package:path_provider/path_provider.dart';

enum Status { WAITING, RECORDING, PLAYING, REVERSING, REVERSE_PLAYING }

const FILE_NAME = "rewindWordsRecord.m4a";
const FILE_NAME_R = "rewindWordsRecordReversed.m4a";

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Status _status = Status.WAITING;

  String _recordFilePath;
  String _recordReversedFilePath;

  AudioPlayer _audioPlayer;
  Duration _currentPosition = Duration(milliseconds: 0);

  Recording _recording = Recording();

  bool _isRecording = false;

  void initState() {
    super.initState();
    _initAudioPlayer();
    _updateFilesPath();
  }

  void _initAudioPlayer() {
    if (_audioPlayer != null) _audioPlayer.release();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    _audioPlayer.positionHandler = (Duration d) {
      setState(() => _currentPosition = d);
    };
  }

  void _updateStatus(Status status) {
    setState(() => _status = status);
  }

  Future<void> _updateFilesPath() async {
    Directory tempDir = Platform.isIOS
        ? await getTemporaryDirectory()
        : Directory("/storage/emulated/0");
    _recordFilePath = tempDir.path + '/' + FILE_NAME;
    _recordReversedFilePath = tempDir.path + '/' + FILE_NAME_R;
  }

  Future<void> _deleteFile(String path) async {
    File file = File(path);
    if (await file.exists()) await file.delete();
  }

  _startRecord() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        await _updateFilesPath();
        await _deleteFile(_recordFilePath);
        await _deleteFile(_recordReversedFilePath);

        await AudioRecorder.start(path: _recordFilePath);

        bool isRecording = await AudioRecorder.isRecording;
        setState(() => _isRecording = isRecording);
      } else {
        print("You must accept permissions");
      }
    } catch (e) {
      print(e);
    }
  }

  _stopRecord() async {
    //if (await AudioRecorder.isRecording) {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = File(recording.path);
    print("File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });

    _reverseSound();
    //}
  }

  void _reverseSound() async {
    try {
      _updateStatus(Status.REVERSING);
      await _deleteFile(_recordReversedFilePath);
      var result = await ReverseAudio.reverseFile(
        _recordFilePath,
        _recordReversedFilePath,
      );
      print(result);
      _updateStatus(Status.WAITING);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _startPlayer() async {
    _updateStatus(Status.PLAYING);
    print(_recordReversedFilePath);
    await _audioPlayer.play(_recordReversedFilePath, isLocal: true);
  }

  Future<void> _stopPlayer() async {
    await _audioPlayer.release();
    _updateStatus(Status.WAITING);
    _initAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_status.toString()),
            Text("Is Recording ? $_isRecording"),
            Text("File path of the record: ${_recording.path}"),
            Text("Format: ${_recording.audioOutputFormat}"),
            Text("Extension : ${_recording.extension}"),
            Text("Recording duration : ${_recording.duration.toString()}"),
            Text((_currentPosition.inMilliseconds / 1000).toStringAsFixed(1) +
                "sec"),
            RaisedButton(
              onPressed: !_isRecording ? _startRecord : null,
              child: Text("Enregistrer"),
            ),
            RaisedButton(
              onPressed: _isRecording ? _stopRecord : null,
              child: Text("Terminer"),
            ),
            RaisedButton(
              onPressed: _startPlayer,
              child: Text("Play"),
            ),
            RaisedButton(
              onPressed: _stopPlayer,
              child: Text("Stop"),
            ),
          ],
        ),
      ),
    );
  }
}
