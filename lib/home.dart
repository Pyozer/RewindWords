import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:ffmpeg/ffmpeg.dart';

enum Status { WAITING, RECORDING, PLAYING, REVERSING, REVERSE_PLAYING }

const FILE = '/storage/emulated/0/default.m4a';
const RFILE = '/storage/emulated/0/default_reverse.m4a';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Status _status = Status.WAITING;

  AudioPlayer _audioPlayer;
  Duration _currentPosition = new Duration(milliseconds: 0);

  Recording _recording = new Recording();
  bool _isRecording = false;

  void initState() {
    super.initState();
    _audioPlayer = new AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    _audioPlayer.positionHandler = (Duration d) {
      setState(() => _currentPosition = d);
    };
  }

  void _updateStatus(Status status) {
    setState(() => _status = status);
  }

  Future<void> _deleteFile(String path) async {
    File file = File(path);
    if (await file.exists()) await file.delete();
  }

  _startRecord() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        await _deleteFile(FILE);

        await AudioRecorder.start(path: FILE);

        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = Recording(duration: Duration(), path: "");
          _isRecording = isRecording;
        });
      } else {
        print("You must accept permissions");
      }
    } catch (e) {
      print(e);
    }
  }

  _stopRecord() async {
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
  }

  void _reverseSound() async {
    _updateStatus(Status.REVERSING);
    await _deleteFile(RFILE);
    print(await Ffmpeg.execute("ffmpeg -i $FILE -af areverse $RFILE -y"));
    _updateStatus(Status.WAITING);
  }

  Future<void> _startPlayer() async {
    await _stopPlayer();
    _updateStatus(Status.PLAYING);
    await _audioPlayer.play(RFILE, isLocal: true);
  }

  Future<void> _stopPlayer() async {
    _updateStatus(Status.WAITING);
    await _audioPlayer.release();
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
              onPressed: _startRecord,
              child: Text("Enregistrer"),
            ),
            RaisedButton(
              onPressed: _stopRecord,
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
