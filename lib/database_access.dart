import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbAccess {
  static final String dbName = "sozluk.sqlite";
  static Future<Database> dbAcs() async {
    String dbPath = join(await getDatabasesPath(), dbName);
    if (await databaseExists(dbPath)) {
      print("veri tabani mevcut");
    } else {
      ByteData data = await rootBundle.load("lib/veritabani/$dbName");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
      print("Veri tabani kopyalandi");
    }
    return openDatabase(dbPath);
  }
}
