import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class StringKeys {
  static const back = "back";
  static const play_title = "play_title";
  static const play_desc = "play_desc";
  static const play_reverse_desc = "play_reverse_desc";
  static const play_btn_speak = "play_btn_speak";
  static const retry = "retry";
  static const play_again = "play_again";
  static const record_again = "record_again";
  static const listen_again = "listen_again";
  static const recording = "recording";
  static const home_title = "home_title";
  static const home_reverse_title = "home_reverse_title";
  static const home_desc = "home_desc";
  static const home_reverse_desc = "home_reverse_desc";
  static const permission_denied = "permission_denied";
  static const ask_again = "ask_again";
}

String getString(BuildContext context, String key) {
  return FlutterI18n.translate(context, key);
}