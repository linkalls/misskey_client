import 'package:flutter/material.dart';
import "package:misskey/misskey_post.dart";
import 'package:url_launcher/url_launcher.dart';
import "package:misskey/gen/env.g.dart";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_isPosting) // 登校中なら表示
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
                  final result = await postNote(value);
                  print(result);
                  setState(() {
                    _isPosting = false;
                    _counter++;
                  });
                  _controller.clear();
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // ボタンが押されたときの処理
                setState(() {
                  _isPosting = true;
                });
                final value = _controller.text; //* controllerっていうやつから値を取得
                debugPrint(value);
                _result = await postNote(value);
                print(_result);
                setState(() {
                  _isPosting = false;
                  _counter++;
                  _result;
                });
                _controller.clear();

                // final result = await postNote(value);
                // debugPrint(result);
              },
              child: const Text('送信'),
            ),
            if (_result.isNotEmpty) // 結果があれば表示
              Column(
                children: [
                  SelectableText("投稿したidは${_result["createdNote"]["id"]}です"),
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () {
                      launchUrl(Uri.parse(
                          "${Env.server}/notes/${_result["createdNote"]["id"]}"));
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
