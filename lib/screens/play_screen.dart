import 'dart:async';
import 'dart:math';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:rewind_words/utils/file.dart';
import 'package:rewind_words/widgets/divided_view.dart';
import 'package:rewind_words/widgets/icon_btn.dart';
import 'package:rewind_words/widgets/record_btn.dart';

class PlayerScreen extends StatefulWidget {
  final bool playReverse;

  const PlayerScreen({Key key, this.playReverse}) : super(key: key);

  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  FlutterSound _audioPlayer;
  StreamSubscription _playerSubscription;

  bool _isPlaying = false;
  double _duration = 1.0;
  double _currentPos = 1.0;

  @override
  void initState() {
    super.initState();
    _startPlayer();
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  Future<void> _disposePlayer() async {
    try {
      if (_playerSubscription != null) _playerSubscription.cancel();
      if (_audioPlayer != null || _isPlaying) await _audioPlayer.stopPlayer();
    } catch (e) {
      print(e);
    }
    _audioPlayer = null;
    _playerSubscription = null;
  }

  Future<void> _startPlayer() async {
    String path = await getReverseRecordFilePath();

    await _disposePlayer(); // Kill player

    _audioPlayer = FlutterSound();
    await _audioPlayer.startPlayer(path);
    _isPlaying = true;

    _playerSubscription = _audioPlayer.onPlayerStateChanged.listen((e) {
      if (e != null && _isPlaying) {
        setState(() {
          _currentPos =
              min(e.currentPosition, e.duration); // Fix currPos > duration
          _duration = e.duration;
        });
      } else if (_isPlaying) {
        _startPlayer();
      }
    });
  }

  void _pausePlayer() async {
    setState(() => _isPlaying = false);
    await _audioPlayer.pausePlayer();
  }

  void _resumePlayer() async {
    try {
      _isPlaying = true;
      await _audioPlayer.resumePlayer();
    } catch (e) {
      _startPlayer();
    }
  }

  void _onRecordReverse() {
    _pausePlayer();
  }

  String _toFixed(double value) => (value / 1000).toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final progressStyle = Theme.of(context).textTheme.title;
    double value = (_currentPos / _duration);

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        DividedView(
          title: "Words reversed",
          desc: "Listen your words in reverse and try to say it",
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SimpleIconBtn(
                    onPressed: _isPlaying ? _pausePlayer : _resumePlayer,
                    icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                  Text(
                    _toFixed(_currentPos) + "/" + _toFixed(_duration),
                    style: progressStyle,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              LinearProgressIndicator(
                value: value,
                valueColor: const AlwaysStoppedAnimation(Colors.white),
                backgroundColor: Colors.black26,
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: RecordButton(onPressed: _onRecordReverse),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.chevron_left, size: 50.0),
            ),
          ),
        ),
      ],
    );
  }
}
