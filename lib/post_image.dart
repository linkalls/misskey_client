import "package:dio/dio.dart";
import 'package:misskey/gen/env.g.dart';
import "package:http_parser/http_parser.dart";
import 'dart:io';
import 'package:image/image.dart' as img;

Future<dynamic> postImageId(String imagePath) async {
  print("postImageId");
  final server = Env.server;
  final token = Env.token; // トークンを取得
  final dio = Dio();

  // 画像の拡張子を確認し、必要に応じて変換
  String newPath = imagePath;
  if (imagePath.endsWith('.jpeg') || imagePath.endsWith('.jpg')) {
    final image = img.decodeImage(File(imagePath).readAsBytesSync()); // 画像を読み込む
    if (image != null) {
      newPath = imagePath.replaceAll(RegExp(r'\.jpe?g$'), '.png'); // 拡張子を変換
      File(newPath).writeAsBytesSync(img.encodePng(image));
    }
  }

  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(
      newPath,
      contentType: MediaType('multipart', 'form-data'), // コンテンツタイプを設定
    ),
  });
  try {
    final response = await dio.post<Map<String, dynamic>>(
      "$server/api/drive/files/create",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to upload image");
    }

    print(response.data!["id"]);
    return response.data!["id"];
  } on DioException catch (e) {
    print("DioException: ${e.message}");
    return "";
  }
}
