import "package:dio/dio.dart";
import "package:misskey/gen/env.g.dart";

Future<Map<String, dynamic>> postNote(String text) async {
  try {
    final env = Env.token;
    final server = Env.server;
    final dio = Dio();

    //* textのみの投稿
    final result = await dio.post("$server/api/notes/create",
        data: {
          "text": text,
        },
        options: Options(headers: {
          //* 全部がdataにかけるわけじゃないので注意
          "Authorization": "Bearer $env",
          "Content-Type": "application/json",
          // "Content-Type": "multipart/form-data",
        }));
    print("Posted! $text");
    return result.data;
  } catch (e) {
    print(e);
    return {"error": e};
  }
}
