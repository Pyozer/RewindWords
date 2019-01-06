import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rewind_words/utils/constants.dart';

Future<void> deleteFile(String path) async {
  File file = File(path);
  if (await file.exists()) await file.delete();
}

Future<String> getFilePath(String filename) async {
  Directory dir = await getTemporaryDirectory();
  return join(dir.path, filename);
}

Future<String> getRecordFilePath() async => await getFilePath(FILE_NAME);
Future<String> getReverseRecordFilePath() async => getFilePath(FILE_NAME_R);
Future<String> getRReverseRecordFilePath() async => getFilePath(FILE_NAME_RR);
