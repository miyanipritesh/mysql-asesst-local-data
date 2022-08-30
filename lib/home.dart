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
  late Database data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _copyDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Quotes>>(
        future: _copyDatabase(),
        builder: (context, snapshot) {
          print('-----------${snapshot.data!.length}');
          // print('-----------${_copyDatabase}');
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Text(snapshot.data![index].body);
              },
            );
          }
          return Center(
            child: Text('no data found'),
          );
        },
      ),
    );
  }

  Future<List<Quotes>> _copyDatabase() async {
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

      print('---!!!!!!!!${map[1]['body'].toString()}');
    })}');

    Database data = await openDatabase(path);
    final List<Map<String, dynamic>> maps = await data.query('quotes');

    return maps.map((e) => Quotes.fromJson(e)).toList();

    // return List.generate(maps.length, (i)  {
    //   return Quotes(
    //     // id: maps[i]['id'],
    //     position: maps[i]['position'],
    //     body: maps[i]['body'],
    //     author_id: maps[i]['author_id'],
    //     category_id: maps[i]['category_id'],
    //     is_favorite: maps[i]['is_favorite'],
    //     is_new: maps[i]['is_new'],
    //   );
    // });
  }

  // Future<List<Quotes>> quotes() async {
  //   final List<Map<String, dynamic>> maps = await data.query('quotes');
  //   return List.generate(maps.length, (i) {
  //     return Quotes(
  //       id: maps[i]['id'],
  //       position: maps[i]['position'],
  //       body: maps[i]['body'],
  //       authorId: maps[i]['authorId'],
  //       categoryId: maps[i]['categoryId'],
  //       isFavorite: maps[i]['isFavorite'],
  //       isNew: maps[i]['isNew'],
  //     );
  //   });
  // }
}

class Quotes {
  final int? id;
  final int author_id;
  final int category_id;
  final String body;
  final int is_new;
  final int is_favorite;
  final int position;
  Quotes({
    required this.author_id,
    required this.category_id,
    required this.body,
    this.id,
    required this.is_new,
    required this.is_favorite,
    required this.position,
  });

  factory Quotes.fromJson(Map<String, dynamic> json) => Quotes(
        id: json['_id'],
        position: json['position'],
        author_id: json['author_id'],
        category_id: json['category_id'],
        body: json['body'],
        is_new: json['is_new'],
        is_favorite: json['is_favorite'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'author_id': author_id,
        'category_id': category_id,
        'body': body,
        'is_new': is_new,
        'is_favorite': is_favorite,
        'position': position
      };
}
