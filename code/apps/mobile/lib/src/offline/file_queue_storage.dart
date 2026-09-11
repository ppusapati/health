/// Durable on-device storage for the offline queue.
///
/// Queued clinical work must survive the app being killed — a nurse who
/// recorded an observation in a basement with no signal has to find it there
/// when the app reopens (SRS-NFR-013).
///
/// Writes are atomic: the contents go to a temporary file which is then renamed
/// over the target. A process killed mid-write therefore leaves either the old
/// queue or the new one, never a truncated file that fails to parse and loses
/// everything.
library;

import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'operation_queue.dart';

/// File-backed queue storage.
class FileQueueStorage implements QueueStorage {
  FileQueueStorage({this.fileName = 'offline_queue.json'});

  /// Constructs storage rooted at an explicit directory. Used by tests, which
  /// have no platform channels and therefore no application documents path.
  FileQueueStorage.inDirectory(this._directory, {this.fileName = 'offline_queue.json'});

  /// Name of the queue file inside the storage directory.
  final String fileName;

  Directory? _directory;

  Future<File> _file() async {
    // Application support, not documents: the queue is internal state, not a
    // user-visible file, and on iOS documents can be exposed to the Files app.
    _directory ??= await getApplicationSupportDirectory();
    await _directory!.create(recursive: true);
    return File('${_directory!.path}/$fileName');
  }

  @override
  Future<String?> load() async {
    final file = await _file();
    if (!await file.exists()) return null;
    return file.readAsString();
  }

  @override
  Future<void> save(String contents) async {
    final file = await _file();
    final temporary = File('${file.path}.tmp');

    await temporary.writeAsString(contents, flush: true);
    await temporary.rename(file.path);
  }
}
