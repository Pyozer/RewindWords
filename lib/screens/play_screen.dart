import 'package:audioplayers/audioplayers.dart';
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

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animController;
  Tween _tween;
  Animation _animation;
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  int realPos = 1;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(duration: Duration(milliseconds: 10), vsync: this);

    _tween = Tween<double>(begin: 0.0, end: 1.0);
    _animation = _tween.animate(_animController)
      ..addListener(() => setState(() {}));

    _initAudioPlayer();
    _startPlayer();
  }

  @override
  void dispose() {
    if (_audioPlayer != null) _audioPlayer.release();
    _animController.dispose();
    super.dispose();
  }

  void _initAudioPlayer() {
    if (_audioPlayer != null) _audioPlayer.release();

    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    _audioPlayer.durationHandler = (Duration d) {
      if (_tween.end != d.inMilliseconds.toDouble()) {
        // If not already setup
        _animController.duration = d;
        _tween.begin = 0.0;
        _tween.end = d.inMilliseconds.toDouble();
      }
    };
    _audioPlayer.positionHandler = (Duration d) {
      realPos = d.inMilliseconds;
      if (!_animController.isAnimating || _animation.isDismissed)
        _animController.forward();
    };
    _audioPlayer.completionHandler = () {
      if (_isPlaying) _startPlayer();
    };
  }

  Future<void> _startPlayer() async {
    _animController.reset();

    String path = widget.playReverse
        ? await getReverseRecordFilePath()
        : await getRecordFilePath();

    _isPlaying = true; // setState do by animation
    _animController.forward();
    await _audioPlayer.play(path, isLocal: true);
  }

  void _stopPlayer() async {
    setState(() => _isPlaying = false);
    await _audioPlayer.pause();
    _animController.stop();
    _animController.animateTo(
      realPos.toDouble() / _tween.end,
      duration: Duration.zero,
    );
  }

  void _resumePlayer() {
    _isPlaying = true;
    _animController.forward();
    _audioPlayer.resume();
  }

  void _onRecordReverse() {
    _stopPlayer();
  }

  String _toFixed(double value) => (value / 1000).toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final progressStyle = Theme.of(context).textTheme.title;
    double value = (_animation.value / _tween.end);

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
                    onPressed: _isPlaying ? _stopPlayer : _resumePlayer,
                    icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                  Text(
                    _toFixed(_animation.value) + "/" + _toFixed(_tween.end),
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
              LinearProgressIndicator(
                value: realPos / _tween.end,
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
