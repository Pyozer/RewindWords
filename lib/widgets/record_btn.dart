import 'package:flutter/material.dart';

const btnSize = 90.0;
const micIcon = Icon(Icons.mic, size: btnSize / 2, color: Colors.white);

class RecordButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onPressed;

  const RecordButton(
      {Key key, @required this.onPressed, this.isRecording = false})
      : super(key: key);

  Widget _buildStaticBtn() {
    return Container(
      width: btnSize,
      height: btnSize,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 4.0),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: micIcon,
    );
  }

  Widget _buildListeningBtn() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox(
          width: btnSize,
          height: btnSize,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
        micIcon
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50.0),
        onTap: onPressed,
        child: isRecording ? _buildListeningBtn() : _buildStaticBtn(),
      ),
    );
  }
}
