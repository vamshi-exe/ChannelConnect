
import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'dart:io';
import 'package:channel_connect/prefrence_util/Prefs.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class ResponseData {
  dynamic json;
  String error;

  ResponseData(this.json, this.error);
}

enum RequestType { Get, Post, Put, Delete, Post_type_ko_Put }

class Api {
  //static Log log = Log("Api Log");
  // POST
  static Future<ResponseData> requestPost(
      {required String api,
      Map<String, String>? query,
      required Map<String, dynamic> body,
      bool encoded = true,
      bool jsonformat = true}) {
    return _request(
        RequestType.Post, query == null ? api : _makeUrl(api, query),
        body: body, encoded: encoded, jsonformat: jsonformat);
  }

  static Future<ResponseData> requestPut(
      {required String api,
      Map<String, String>? query,
      required Map<String, dynamic> body,
      bool encodedurl = true}) {
    return _request(encodedurl ? RequestType.Put : RequestType.Post_type_ko_Put,
        query == null ? api : _makeUrl(api, query),
        body: body);
  }

  static Future<ResponseData> requestDelete(
      {required String api, Map<String, String>? query,required Map<String, dynamic> body}) {
    return _request(
        RequestType.Delete, query == null ? api : _makeUrl(api, query),
        body: body);
  }

  // GET
  static Future<ResponseData> requestGet(String api,
      {required Map<String, String> query}) async {
    return await _request(RequestType.Get, _makeUrl(api, query));
  }

  // static Future<ResponseData> requestGetPaging(
  //     String api, PageQuery query) async {
  //   return await _request(
  //       RequestType.Get, _makeUrl(api, query != null ? query.toQuery() : null));
  // }

  static Future<Map<String, String>>? _getHeaders({
    bool jsonformat = false,
  }) async {
    Map<String, String>? map = {};
    var token = await Prefs.token;
    if (!jsonformat) {
      if (token.isEmpty)
        map = {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
        };
      else
        map = {
          'Authorization': 'Bearer ${token}',
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
        };
    } else {
      if (token.isEmpty)
        map = {
          "Accept": "application/json",
          "Content-Type": "application/json; charset=utf-8"
        };
      map = {
        'Authorization': 'Bearer ${token}',
        "Accept": "application/json",
        "Content-Type": "application/json; charset=utf-8"
      };
    }
    return map;
  }

  // static Future post_or_put_patch_DataWithImage(
  //     {context,
  //     String thumbpath,
  //     Map<String, String> data,
  //     bool user = false,
  //     String imagename = "image",
  //     String post_put = "POST",
  //     url}) async {
  //   try {
  //     var request =
  //         new MultipartRequest(post_put.toUpperCase(), Uri.parse(url));
  //     File file = File(thumbpath);
  //     var stream = new ByteStream(file.openRead());

  //     var length = await file.length();
  //     await request.files.add(await MultipartFile('$imagename', stream, length,
  //         filename: basename(file.path),
  //         contentType:
  //             MediaType.parse(Mime.getContentType(extension(file.path)))));

  //     request.fields.addAll(data);

  //     await request.headers.addAll(await _getHeaders());
  //     final response = await request.send();
  //     await response.stream.transform(utf8.decoder).listen((value) {
  //       if (response.statusCode.toString().startsWith("2")) {
  //         Utility.toast(
  //             context: context,
  //             text: Utility.decodeJson(value)["message"].toString().isEmpty
  //                 ? "Success"
  //                 : Utility.decodeJson(value)["message"].toString());
  //         // Utility.setPreferences(
  //         //     "user", Utility.encodeJson(Utility.decodeJson(value)["data"]));
  //         return ResponseData(value, null);
  //       } else {
  //         if (!(value.toString().contains("html") ||
  //             value.toString().contains("python"))) {
  //           Utility.toast(context: context, text: something);
  //           return ResponseData(null, something);
  //         } else {
  //           Utility.toast(context: context, text: value);

  //           return ResponseData(null, value);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     Utility.toast(context: context, text: something);

  //     return ResponseData(null, something);
  //   }
  // }

  // static Future post_or_put_patch_DataWithMultipleImage(
  //     {context,
  //     Map<String, String> data,
  //     bool user = false,
  //     FunctionCallback fun,
  //     Map fileNameWithStore,
  //     String post_put = "POST",
  //     url}) async {
  //   try {
  //     var request =
  //         new MultipartRequest(post_put.toUpperCase(), Uri.parse(url));
  //     print("here");
  //     fileNameWithStore.forEach((key, value) async {
  //       print("file key: $key");
  //       if (value != null) {
  //         if (value is String) {
  //           print("file value: $value");
  //           File file = File(value);
  //           var stream = new ByteStream(file.openRead());

  //           var length = await file.length();
  //           await request.files.add(await MultipartFile('$key', stream, length,
  //               filename: basename(file.path),
  //               contentType: MediaType.parse(
  //                   Mime.getContentType(extension(file.path)))));
  //         } else if (value is List) {
  //           log.i("THe value is as list $value");
  //           value.forEach((filepath) async {
  //             File file = File(filepath);
  //             var stream = new ByteStream(file.openRead());

  //             var length = await file.length();
  //             request.files.add(MultipartFile('$key[]', stream, length,
  //                 filename: basename(file.path),
  //                 contentType: MediaType.parse(
  //                     Mime.getContentType(extension(file.path)))));
  //           });
  //         }
  //       }
  //     });

  //     log.e(
  //         "Request is as: ${request.files} ${request.fields} ${request.method}");
  //     request.headers.addAll(await _getHeaders());
  //     final response = await request.send();
  //     response.stream.transform(utf8.decoder).listen((value) {
  //       log.e("FIle up load response is : $value");
  //       if (response.statusCode.toString().startsWith("2")) {
  //         var files = Utility.decodeJson(value);
  //         log.e("The gallery files are: ${files["gallery_file_name"]} ");

  //         Map data = {
  //           "gallery": files["gallery_file_name"],
  //           "thumb": files["thumb_file_name"]
  //         };
  //         if (fun != null) fun(data);
  //         return true;
  //       } else {
  //         if (!(value.toString().contains("html") ||
  //             value.toString().contains("python"))) {
  //           Utility.toast(context: context, text: something);
  //           return false;
  //         } else {
  //           Utility.toast(context: context, text: value);

  //           return false;
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     Utility.toast(context: context, text: something);

  //     return false;
  //   }
  // }

  // static Future<ResponseData> postImage(
  //     {List<String> filepathlist,
  //     String imageurl,
  //     String imagename,
  //     FunctionCallback function}) async {
  //   try {
  //     var request = new MultipartRequest("POST", Uri.parse(imageurl));
  //     filepathlist.forEach((filepath) async {
  //       File file = File(filepath);
  //       var stream = new ByteStream(file.openRead());

  //       var length = await file.length();
  //       await request.files.add(await MultipartFile(
  //           '$imagename', stream, length,
  //           filename: basename(file.path),
  //           contentType:
  //               MediaType.parse(Mime.getContentType(extension(file.path)))));
  //     });

  //     await request.headers.addAll(await _getHeaders());
  //     final response = await request.send();
  //     await response.stream.transform(utf8.decoder).listen((value) async {
  //       if (response.statusCode.toString().startsWith("2")) {
  //         var a = Utility.decodeJson(value);
  //         print("hdhdhdh=$a");
  //         if (a["code"].toString().contains("200")) {
  //           {
  //             if (function != null) {
  //               function(a["file_name"]);
  //             }
  //             return ResponseData(a["file_name"], null);
  //           }
  //         } else
  //           return ResponseData(null, a["status"]);
  //       } else {
  //         if (!(value.toString().contains("html"))) {
  //           return ResponseData(null, something);
  //         } else
  //           return ResponseData(null, value);
  //       }
  //     });
  //   } catch (e) {
  //     return ResponseData(null, something);
  //   }
  // }

  // REQUEST
  static Future<ResponseData> _request(RequestType type, String url,
      {Map<String, dynamic>? body,
      bool encoded = true,
      bool jsonformat = true}) async {
    Response response;
    // make request
    try {
      switch (type) {
        case RequestType.Get:
          response = await get(Uri.parse(url), headers: await _getHeaders());
          break;
        case RequestType.Post:
          print("  Data $body");
          response = await post(Uri.parse(url),
              body: Utility.encodeJson(body),
              headers: await _getHeaders(jsonformat: jsonformat));
          break;
        case RequestType.Post_type_ko_Put:
          response = await put(Uri.parse(url),
              body: Utility.encodeJson(body),
              headers: await _getHeaders(jsonformat: true));

          break;
        case RequestType.Put:
          response = await put(Uri.parse(url),
              body: body,
              // encoding: Encoding.getByName("utf-8"),
              headers: await _getHeaders(jsonformat: false));
          break;
        case RequestType.Delete:
          response = await delete(Uri.parse(url), headers: await _getHeaders());
          break;
      }
    //  print("Url is: $url");
     // print("response= is ${response.body}");
      // sample info available in response
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        return ResponseData(response.body, "null");
      } else {
        return ResponseData(
            null,
            response.body.contains("http") ||
                    response.body.contains("php") ||
                    response.body.contains("python")
                ? SOMETHING_WRONG_TEXT
                : response.body);
      }
    } catch (e) {
      print("Here=$e");
      return ResponseData(null, SOMETHING_WRONG_TEXT);
    }
  }

  static String _makeUrl(String api, Map<String, String> query) {
    var params = [];
    if (query != null) {
      query.forEach((key, value) {
        params.add(key + "=" + value);
      });
    } else {
      return api;
    }
    if (api.contains("?")) {
      if (api.endsWith("?")) {
        return api + params.join("&");
      }
      return api + "&" + params.join("&");
    }
    return api + "?" + params.join("&");
  }
}
