import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  final bool isSuccess;
  final dynamic body;

  http.Response response;

  ApiResponse({
    required this.body,
    required this.isSuccess,
    required this.response,
  });
}

Future<ApiResponse> postService(String url, dynamic body) async {
  var request_body = jsonEncode(body);

  http.Response response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: request_body,
  );

  var reponseBody = response.statusCode == 200
      ? jsonDecode(response.body)
      : response.body;
  print(
    'URL: $url \n Payload: $request_body\n  \n Response Body:\n \t$reponseBody',
  );
  return ApiResponse(
    body: reponseBody,
    isSuccess: response.statusCode == 200,
    response: response,
  );
}

Future<ApiResponse> getService(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  var reponseBody = response.statusCode == 200
      ? jsonDecode(response.body)
      : response.body;
  return ApiResponse(
    body: reponseBody,
    isSuccess: response.statusCode == 200,
    response: response,
  );
}

Future<http.MultipartFile> getMultiParts(
  File file, [
  String name = 'image.png',
]) async {
  var image_bytes = await file.readAsBytes();

  return http.MultipartFile.fromBytes('image', image_bytes, filename: name);
}

postWithProgress({
  required String url,
  required dynamic body,
  required void Function(int, int) progressCallback,
  required void Function(dynamic) onComplete,
}) async {
  final dio = Dio();
  var request_body = jsonEncode(body);

  try {
    final response = await dio.post(
      url,
      data: request_body,
      options: Options(headers: {'Content-Type': 'application/json'}),
      onSendProgress: (count, total) {
        progressCallback(count, total);
      },
    );

    if (response.statusCode == 200) {
      onComplete(response.data);
    } else {
      throw Exception('Failed to post data');
    }
  } catch (e) {
    throw Exception('Failed to post data: $e');
  }
}

// insertScreen(int user_id, String screenName, int reference_id) async {
//   var body = {
//     "user_id": user_id,
//     "screen": screenName,
//     "reference_id": reference_id,
//   };
//   await postService(URL_SCREEN_RECORD, body);
// }
