import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rewind_words/utils/file.dart';
import 'package:rewind_words/widgets/divided_view.dart';

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

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _tween = Tween<double>(begin: 0.0, end: 0.0);
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
    _audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
    _audioPlayer.durationHandler = (Duration d) {
      _animController.duration = d;
      _tween.begin = 0.0;
      _tween.end = d.inMilliseconds.toDouble();
    };
    _audioPlayer.positionHandler = (Duration d) {
      if (!_animController.isAnimating || _animation.isDismissed)
        _animController.forward();
    };
    _audioPlayer.completionHandler = () {
      _animController.reset();
      _startPlayer(); // Loop
    };
  }

  Future<void> _startPlayer() async {
    String path = widget.playReverse
        ? await getRecordFilePath()
        : await getRecordFilePath();
    await _audioPlayer.play(path, isLocal: true);
  }

  String _toFixed(double value) {
    return (value / 1000).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    double value = (_animation.value / _tween.end);

    final progressStyle = Theme.of(context).textTheme.title;

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        DividedView(
          title: "Words reversed",
          desc: "Listen your words in reverse and try to say it",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _toFixed(_animation.value) + "/" + _toFixed(_tween.end),
                style: progressStyle,
                textAlign: TextAlign.end,
              ),
              LinearProgressIndicator(
                value: value,
                valueColor: const AlwaysStoppedAnimation(Colors.white),
                backgroundColor: Colors.black26,
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
