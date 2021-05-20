import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pixell_app/network/rest_ds.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  bool apiStatusCodeCheck(int statusCode) {
    if (statusCode < 200 || statusCode == 500 || json == null) {
      return false;
    }

    return true;
  }

  Future<dynamic> get(String url, headersMy) {
    return http.get(url, headers: headersMy).then((http.Response response) {
      final String res = utf8.decode(response.bodyBytes); //response.body;
      final int statusCode = response.statusCode;

      if (!apiStatusCodeCheck(statusCode)) {
        return null;
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> postRaw(String url, bodyData, {Map headers, encoding}) {
    //encode Map to JSON
    var body = json.encode(bodyData);

    return http
        .post(url,
            body: body,
            headers: {"Content-Type": "application/json"},
            encoding: encoding)
        .then((http.Response response) {
      final String res = utf8.decode(response.bodyBytes); //response.body;
      final int statusCode = response.statusCode;

      if (!apiStatusCodeCheck(statusCode)) {
        return null;
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> postRawWithLoginToken(String url, String login_token, bodyData,
      {Map headers, encoding}) {
    //encode Map to JSON
    var body = json.encode(bodyData);

    return http
        .post(url,
            body: body,
            headers: {
              "Content-Type": "application/json",
              RestDatasource().KEY_Authorization:
                  RestDatasource().KEY_token_with_space + login_token
            },
            encoding: encoding)
        .then((http.Response response) {
      final String res = utf8.decode(response.bodyBytes); //response.body;
      final int statusCode = response.statusCode;

      if (!apiStatusCodeCheck(statusCode)) {
        return null;
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> deleteParams(String url,String login_token, {Map headers, body, encoding}) {
    return http.delete(url,
      headers: {
        "Content-Type": "application/json",
        RestDatasource().KEY_Authorization:
        RestDatasource().KEY_token_with_space + login_token
      },).then(
        (http.Response response) {
      final String res = utf8.decode(response.bodyBytes); //response.body;
      final int statusCode = response.statusCode;

      if (!apiStatusCodeCheck(statusCode)) {
        return null;
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> putRaw(String url, login_token, bodyData,
      {Map headers, encoding}) {
    //encode Map to JSON
    var body = json.encode(bodyData);

    print("DATAFORCALL" + body);

    return http
        .put(url,
            body: body,
            headers: {
              "Content-Type": "application/json",
              RestDatasource().KEY_Authorization:
                  RestDatasource().KEY_token_with_space + login_token
            },
            encoding: encoding)
        .then((http.Response response) {
      final String res = utf8.decode(response.bodyBytes); //response.body;
      final int statusCode = response.statusCode;

      if (!apiStatusCodeCheck(statusCode)) {
        return null;
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = utf8.decode(response.bodyBytes); //response.body;
      final int statusCode = response.statusCode;

      if (!apiStatusCodeCheck(statusCode)) {
        return null;
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> postImage(String url, File imageFile, bool thumbnail, void onProgressChange(double value)) async {

    final imageUploadRequest = MultipartRequest('POST', Uri.parse(url), onProgress: (int bytes, int total) {
      final progress = bytes / total;
      onProgressChange(progress);
    });

    imageUploadRequest.fields[RestDatasource().KEY_thumbnail] = thumbnail ? "true" : "false";

    var multipartFile = await MultipartFile.fromPath(
        RestDatasource().KEY_file, imageFile.path);
    imageUploadRequest.files.add(multipartFile);

    return imageUploadRequest.send().then((http.StreamedResponse response) {
      return http.Response.fromStream(response).then((http.Response response) {
        final String res = utf8.decode(response.bodyBytes); //response.body;
        final int statusCode = response.statusCode;
        if (!apiStatusCodeCheck(statusCode)) {
          return null;
        }

        return _decoder.convert(res);
      });
    });
  }

  Future<Map<String, dynamic>> postMultiPartSignup(
      String url,
      File imageFile,
      String first_name,
      String last_name,
      String email,
      String mobile_no,
      String country_code,
      String password,
      String password_confirmation) async {
    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(url));

    /*final mimeTypeData = lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath(RestDatasource().KEY_profile_image, imageFile.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));*/

    imageUploadRequest.fields[RestDatasource().KEY_first_name] = first_name;
    imageUploadRequest.fields[RestDatasource().KEY_last_name] = last_name;
    imageUploadRequest.fields[RestDatasource().KEY_email] = email;
    imageUploadRequest.fields[RestDatasource().KEY_mobile_no] = mobile_no;
    imageUploadRequest.fields[RestDatasource().KEY_country_code] = country_code;
    imageUploadRequest.fields[RestDatasource().KEY_password] = password;
    imageUploadRequest.fields[RestDatasource().KEY_password_confirmation] =
        password_confirmation;

    if (imageFile != null) {
      var multipartFile = await MultipartFile.fromPath(
          RestDatasource().KEY_profile_image, imageFile.path);
      imageUploadRequest.files.add(multipartFile);
    }

    try {
      final streamedResponse = await imageUploadRequest.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (!apiStatusCodeCheck(response.statusCode)) {
        return null;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
      String method,
      Uri url, {
        this.onProgress,
      }) : super(method, url);

  final void Function(int bytes, int totalBytes) onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = this.contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
