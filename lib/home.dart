import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _copyDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Future<void> _copyDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, 'store.db');
    final exit = await databaseExists(path);

    if (exit) {
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {}

      ByteData data = await rootBundle.load(join('assest', 'store.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      print('copy Data');
    }

    print('${openDatabase(path).then((value) async {
      List<Map<String, dynamic>> map = await value.query('quotes');

      print('---!!!!!!!!${map[1].toString()}');
    })}');
    await openDatabase(path);
  }
}
