import 'package:flutter/material.dart';
import 'dart:io';
import "package:misskey/misskey_post.dart";
import 'package:url_launcher/url_launcher.dart';
import "package:misskey/gen/env.g.dart";
import 'package:image_picker/image_picker.dart';
// import "dart:io";
import 'package:flutter/foundation.dart';

final ImagePicker _picker = ImagePicker();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  bool _isPosting = false;
  int _counter = 0;
  Map<String, dynamic> _result = {}; // デフォルト値を設定
  XFile? _image; // 画像を格納する変数

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (_isPosting) // 投稿中なら表示
                const Text("投稿中..."),
              if (!_isPosting) // そうでなければ表示
                Text("投稿してね!!\n $_counter 回投稿したよ！"),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  maxLines: 5,
                  minLines: 1,
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "ここに文字を入れてね!!",
                  ),
                  onSubmitted: (value) async {
                    setState(() {
                      _isPosting = true;
                    });
                    // ロギングフレームワークを使用
                    debugPrint(value);
                    final result = await compute(postNote, {"text": value});
                    print(result);
                    setState(() {
                      _isPosting = false;
                      _counter++;
                    });
                    _controller.clear();
                    _image = null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _pickImage, //* 画像取得
                child: const Text('画像を選択'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // ボタンが押されたときの処理
                  setState(() {
                    _isPosting = true;
                  });
                  final value = _controller.text; //* controllerっていうやつから値を取得
                  if (_image != null) {
                    final file = File(_image!.path);
                    final result =
                        await compute(postNote, {"text": value, "file": file});

                    // final result = await postNote(value, file);
                    print(result);
                    setState(() {
                      _isPosting = false;
                      _counter++;
                      _result = result;
                    });
                    _controller.clear();
                    return;
                  }
                  debugPrint(value);
                  _result = await compute(postNote, {"text": value});
                  print(_result);
                  setState(() {
                    _isPosting = false;
                    _counter++;
                    _result;
                  });
                  _controller.clear();
                  _image = null;

                  // final result = await postNote(value);
                  // debugPrint(result);
                },
                child: const Text('送信'),
              ),
              if (_image != null) // 画像があれば表示
                Expanded(
                  child: Image.file(
                    File(_image!.path),
                    fit: BoxFit.contain, // 画像のフィット方法を指定
                  ),
                ), // File class使って画像を表示

              if (_result.isNotEmpty) // 結果があれば表示
                Column(
                  children: [
                    SelectableText("投稿したidは${_result["createdNote"]["id"]}です"),
                    IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () async {
                        final url = Uri.parse(
                            "${Env.server}/notes/${_result["createdNote"]["id"]}");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
