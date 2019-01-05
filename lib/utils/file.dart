import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rewind_words/constants.dart';

Future<void> deleteFile(String path) async {
  File file = File(path);
  if (await file.exists()) await file.delete();
}

Future<String> getRecordFilePath() async {
  Directory dir = await getTemporaryDirectory();
  return join(dir.path, FILE_NAME);
}

Future<String> getReverseRecordFilePath() async {
  Directory dir = await getTemporaryDirectory();
  return join(dir.path, FILE_NAME_R);
}
