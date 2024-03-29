import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as eos;

class Posts {
  //static String userId = Hive.box('name').get('userID');
  static String baseUrl = "https://statup.ng/room8/room8/index.php/";

  var user_data = Hive.box("room8").get("user_data");

  Future<dynamic> get_all_posts() async {
    String? access_token = user_data["access_token"];
    print("access_token" + access_token.toString());

    print("user_id" + user_data["id"].toString());
    try {
      //eos.Response response;
      var dio = eos.Dio();

      var response = await dio.get(baseUrl + 'posts/get_posts',
          // data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
              // "Content-Type": "multipart/form-data",
              "Authorization": access_token.toString()
            },
          ));

      //print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error
          print(data["message"]);

          return [];
        } else if (data["code"] == 1) {
          print("posts retrieved");
          return data["data"];
        } else {
          return [];
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return "failed";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "failed";
    };
  }

  Future<dynamic> get_all_users_posts(String user_id) async {
    String? access_token = user_data["access_token"];
    print("access_token" + access_token.toString());

    try {
      //eos.Response response;
      var dio = eos.Dio();

      var response =
          await dio.get(baseUrl + 'posts/get_posts_from_user?user_id=$user_id',
              // data: formData,

              options: eos.Options(
                headers: {
                  "accept": "application/json",
                  // "Content-Type": "multipart/form-data",
                  "Authorization": access_token.toString()
                },
              ));

      //print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error
          print(data["message"]);

          return [];
        } else if (data["code"] == 1) {
          print("posts retrieved");

          //store details of user in storage to display on user screen
          Hive.box("room8").put("user_data_for_profile_inview",
              data["user_data_for_profile_inview"]);

          return data["data"];
        } else if (data["code"] == 2) {
          print("No posts retrieved");

          //store details of user in storage to display on user screen
          Hive.box("room8").put("user_data_for_profile_inview",
              data["user_data_for_profile_inview"]);

          //only user data received

          return [];
        } else {
          return [];
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return "failed";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "failed";
    };
  }

  Future<dynamic> post(
      {List<File>? media, String? text, String? post_type}) async {
    String? access_token = user_data["access_token"];
    var dio = eos.Dio();
    String? request_post_type;

    if (post_type == "IMAGE" && media!.isNotEmpty) {
      request_post_type = "IMAGE";
    }
    else if(post_type == "VIDEO" && media!.isNotEmpty){
      request_post_type = "VIDEO";
    }
    else if(media!.isNotEmpty){
      request_post_type = "TEXT";
    }

    var formData = eos.FormData.fromMap({
      'text': text ?? text,
      'post_type': request_post_type,
    });

    //set post type based on length of images

    if (media!.isNotEmpty) {
      int c = 0;
      for (File item in media!) {
        formData.files.addAll([
          MapEntry("files" + c.toString(),
              await eos.MultipartFile.fromFile(item.path)),
        ]);
        c++;
      }
    } else if (media.isEmpty) {
      post_type = "TEXT";
    }
    var response = await dio.post(baseUrl + 'posts/create',
        data: formData,
        options: eos.Options(
          headers: {
            "accept": "application/json",
            // "Content-Type": "multipart/form-data",
            "Authorization": access_token.toString()
          },
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.data);

      if (data["code"] == 1) {
        return 1;
      } else if (data["code"] == 0) {
        return 0;
      } else if (data["code"] == 2) {
        //image could not be uploaded probably due to server issues
        return 2;
      } else if (data["code"] == 3) {
        //image size greater than 5mb
        return 3;
      }
    } else {
      return 0;
    }
  }

  Future<dynamic> delete_post(String post_id) async {
    String? access_token = user_data["access_token"];
    print("access_token" + access_token.toString());

    try {
      //eos.Response response;
      var dio = eos.Dio();

      var response =
          await dio.get(baseUrl + 'posts/delete_post?post_id=$post_id',
              // data: formData,
              options: eos.Options(
                headers: {
                  "accept": "application/json",
                  // "Content-Type": "multipart/form-data",
                  "Authorization": access_token.toString()
                },
              ));

      //print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error
          print(data["message"]);

          return [];
        } else if (data["code"] == 1) {
          print("post deleted successfully");

          return 1;
        } else {
          return [];
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return "failed";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "failed";
    };
  }

  Future<dynamic> post_comment(
      {List<File>? media, String? text, String? post_id}) async {
    //provisions are made in case we decide to add media into the comments feature soon

    String? access_token = user_data["access_token"];
    var dio = eos.Dio();
    String? post_type;
    media = [];

    var formData = eos.FormData.fromMap({
      'content': text ?? text,
      'type': media!.isEmpty ? "TEXT" : "IMAGE",
      'post_id': post_id
    });

    //set post type based on length of images

    if (media!.isNotEmpty) {
      int c = 0;
      for (File item in media!) {
        formData.files.addAll([
          MapEntry("files" + c.toString(),
              await eos.MultipartFile.fromFile(item.path)),
        ]);
        c++;
      }
    } else if (media.isEmpty) {
      post_type = "TEXT";
    }
    var response = await dio.post(baseUrl + 'posts/create_comment',
        data: formData,
        options: eos.Options(
          headers: {
            "accept": "application/json",
            // "Content-Type": "multipart/form-data",
            "Authorization": access_token.toString()
          },
        ));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.data);

      if (data["code"] == 1) {
        return 1;
      } else if (data["code"] == 0) {
        return 0;
      } else if (data["code"] == 2) {
        //image could not be uploaded probably due to server issues
        return 2;
      } else if (data["code"] == 3) {
        //image size greater than 5mb
        return 3;
      }
    } else {
      return 0;
    }
  }

  Future<dynamic> get_all_post_comments(String post_id) async {
    String? access_token = user_data["access_token"];
    print("access_token" + access_token.toString());

    try {
      //eos.Response response;
      var dio = eos.Dio();

      var response =
          await dio.get(baseUrl + 'posts/get_post_comments?post_id=$post_id',
              // data: formData,
              options: eos.Options(
                headers: {
                  "accept": "application/json",
                  // "Content-Type": "multipart/form-data",
                  "Authorization": access_token.toString()
                },
              ));

      //print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error
          print(data["message"]);

          return [];
        } else if (data["code"] == 1) {
          print("posts retrieved");
          return data["data"];
        } else {
          return [];
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return "failed";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "failed";
    };
  }
}
