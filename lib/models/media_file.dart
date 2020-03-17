import 'dart:io';

import 'package:meta/meta.dart';

class MediaFile {
  final String fileName;
  final File file;
  final MediaType fileType;

  MediaFile(
      {@required this.fileName, @required this.file, @required this.fileType});
}

enum MediaType { audio, video }
