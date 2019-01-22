import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rewind_words/screens/home_screen.dart';
import 'package:rewind_words/utils/file.dart';
import 'package:rewind_words/utils/translation.dart';
import 'package:rewind_words/widgets/icon_btn.dart';
import 'package:rewind_words/widgets/screen.dart';

class PlayerScreen extends StatefulWidget {
  final bool isInReverse;

  const PlayerScreen({Key key, this.isInReverse = false}) : super(key: key);

  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _duration = 1.0;
  double _currentPos = 1.0;

  @override
  void initState() {
    super.initState();
    _initPlayer();
    _startPlayer();
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  void _initPlayer() {
    _isPlaying = false;
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);

    _audioPlayer.durationHandler = (Duration d) {
      setState(() => _duration = d.inMilliseconds.toDouble());
    };
    _audioPlayer.positionHandler = (Duration p) {
      if (!_isPlaying) _audioPlayer.release();
      setState(() => _currentPos = p.inMilliseconds.toDouble());
    };

    _audioPlayer.completionHandler = () async {
      if (_isPlaying) {
        setState(() => _currentPos = _duration);
        await Future.delayed(const Duration(milliseconds: 400));
        if (_isPlaying) _startPlayer();
      }
    };
  }

  Future<void> _disposePlayer() async {
    if (_audioPlayer == null) {
      await _audioPlayer.stop();
      await _audioPlayer.release();
      _audioPlayer = null;
    }
    _isPlaying = false;
  }

  Future<void> _startPlayer() async {
    if (!mounted || _audioPlayer == null) return;

    String path = !widget.isInReverse
        ? await getReverseRecordFilePath()
        : await getRReverseRecordFilePath();

    if (_isPlaying) await _audioPlayer.stop();

    final result = await _audioPlayer.play(path, isLocal: true);
    if (result == 1) setState(() => _isPlaying = true);
  }

  void _pause() async {
    if (!_isPlaying) return;
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _isPlaying = false);
  }

  void _stop() async {
    if (!_isPlaying) return;
    final result = await _audioPlayer.stop();
    if (result == 1) setState(() => _isPlaying = false);
  }

  void _resume() async {
    if (_isPlaying) return;
    if (_audioPlayer == null) _initPlayer();
    try {
      final result = await _audioPlayer.resume();
      if (result == 1) setState(() => _isPlaying = true);
    } catch (e) {
      _startPlayer();
    }
  }

  String _toFixed(double value) => (value / 1000).toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final progressStyle = Theme.of(context).textTheme.title;
    double value = _currentPos == 0 ? 0 : (_currentPos / _duration);

    final descKey = widget.isInReverse
        ? StringKeys.play_reverse_desc
        : StringKeys.play_desc;
    final backTextKey =
        widget.isInReverse ? StringKeys.retry : StringKeys.record_again;

    return Screen(
      title: getString(context, StringKeys.play_title),
      desc: getString(context, descKey),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SimpleIconBtn(
                onPressed: _isPlaying ? _pause : _resume,
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
            child: !widget.isInReverse
                ? Center(
                    child: RaisedButton(
                      color: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(color: Colors.white),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 32.0,
                      ),
                      child: Text(
                        getString(context, StringKeys.play_btn_speak),
                      ),
                      onPressed: () {
                        _stop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => HomeScreen(speakInReverse: true),
                        ));
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      onBackPressed: () {
        _disposePlayer();
        Navigator.of(context).pop();
      },
      backText: getString(context, backTextKey),
    );
  }
}
