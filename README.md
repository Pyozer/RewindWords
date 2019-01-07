# Rewind Words

Rewind Words is a Flutter game app, the goal is to try to speak in reverse and listen the result reversed, so in normal.
This game is funny because what you say in reverse is funny when it's reversed.

Actions steps:

**You:** Speak something, a single word (easy) or sentence (difficult)
  
**App:** Reverse what you said
  
**You:** Listen the result until you are ready

**You:** Speak the word/sentance in reverse
  
**App:** Reverse what you said in reverse
  
**You:** Listen what you say in reverse put in reversed.

## Libraries

- audio_recorder (https://github.com/mmcc007/audio_recorder)
- audioplayers
- reverse_audio (https://github.com/Pyozer/reverse_audio)
- path_provider
- simple_permissions

The lib 'reverse_audio' is a plugin that I made, who use FFMPEG for Android and a 'simple' algo (thanks to StackOverflow) for iOS.

## Demo

<img src="https://i.ibb.co/R0VC8Z4/demo.gif" width="400" alt="Demo of the app"/>