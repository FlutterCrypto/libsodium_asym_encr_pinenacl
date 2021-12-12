import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {

  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localPrivateKeyFile async {
    final path = await localPath;
    return File('$path/curve25519prikey.txt');
  }

  Future<File> get localPublicKeyFile async {
    final path = await localPath;
    return File('$path/curve25519pubkey.txt');
  }

  Future<String> readDataPrivateKey() async {
    try {
      final file = await localPrivateKeyFile;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> readDataPublicKey() async {
    try {
      final file = await localPublicKeyFile;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeDataPrivateKey(String data) async {
    final file = await localPrivateKeyFile;
    return file.writeAsString("$data");
  }

  Future<File> writeDataPublicKey(String data) async {
    final file = await localPublicKeyFile;
    return file.writeAsString("$data");
  }

  Future<bool> filePrivateKeyExists() async {
    try {
      final file = await localPrivateKeyFile;
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<bool> filePublicKeyExists() async {
    try {
      final file = await localPublicKeyFile;
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}

