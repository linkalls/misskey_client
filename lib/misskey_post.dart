import "package:dio/dio.dart";
import "package:misskey/gen/env.g.dart";
import "package:misskey/post_image.dart";

Future<Map<String, dynamic>> postNote(String text, [file]) async {
  try {
    print(file == null ? "text only" : "text and image");
    final env = Env.token;
    final server = Env.server;
    final dio = Dio();

    if (file == null) {
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
    } else {
      final imageId = await postImageId(file.path);
      print("$imageId");
      final result = await dio.post("$server/api/notes/create",
          data: {
            "text": text,
            "fileIds": [imageId],
          },
          options: Options(headers: {
            "content-type": "application/json",
            "Authorization": "Bearer $env",
          }));
      print("Posted! $text and $imageId");
      return result.data;
    }
  } catch (e) {
    print(e);
    return {"error": e};
  }
}
