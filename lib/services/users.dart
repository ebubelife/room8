import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as eos;

class Users {
  //static String userId = Hive.box('name').get('userID');
  static String baseUrl = "https://statup.ng/room8/room8/index.php/";

  var user_data = Hive.box("room8").get("user_data");

  Future<dynamic> followUser({String? id_to_follow}) async {
    try {
      var dio = eos.Dio();

      var formData = eos.FormData.fromMap({
        'id_to_follow': id_to_follow!.trim(),
        'id_of_follower': user_data["id"],
      });

      var response = await dio.post(baseUrl + 'members/follow_user',
          data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured";
        } else if (data["code"] == 1) {
          //user was followed

          return 1;
        } else if (data["code"] == 2) {
          //user was unfollowed
          return 2;
        } else {
          //an error occured... possibly server error
          print(response.data.toString());
          return 0;
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());

      return "Sorry! could not connect to server. Try again.";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "Sorry! could not connect to server. Try again.";
    };
  }

  Future<dynamic> deactivate({String? id_to_deactivate}) async {
    String? access_token = user_data["access_token"];
    try {
      var dio = eos.Dio();

      var formData = eos.FormData.fromMap({
        'id_to_deactivate': id_to_deactivate,
      });

      var response = await dio.post(baseUrl + 'members/deactivate_user',
          data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
              "Authorization": access_token.toString()
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured";
        } else if (data["code"] == 1) {
          //user was deleted successfully

          return 1;
        } else if (data["code"] == 2) {
          //failed to delete user
          return 2;
        } else {
          //an error occured... possibly server error
          print(response.data.toString());
          return 0;
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());

      return "Sorry! could not connect to server. Try again.";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "Sorry! could not connect to server. Try again.";
    };
  }

  Future<dynamic> updateProfilePic({
    @required File? profile_pic,
  }) async {
    try {
      var dio = eos.Dio();
      String? access_token = user_data["access_token"];

      var formData = eos.FormData.fromMap({
        'user_id': user_data["id"],
      });

      if (profile_pic != null) {
        List<File> mainMediaHolder = [];

        mainMediaHolder.add(profile_pic);

        int c = 0;
        for (File item in mainMediaHolder) {
          formData.files.addAll([
            MapEntry("files" + c.toString(),
                await eos.MultipartFile.fromFile(item.path)),
          ]);
          c++;
        }
      }

      var response = await dio.post(baseUrl + 'members/update_profile_picture',
          data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
              "Authorization": access_token.toString()
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "Could not complete that upload. Please try again";
        } else if (data["code"] == 1) {
          var user_data = Hive.box("room8").get("user_data");

          user_data["profile_image_url"] = data["new_url"];
          Hive.box("room8").put("user_data", user_data);
          //upload successful
          return 1;
        } else if (data["code"] == 2) {
          return "Could not authenticate user! Please log out and login again";
        } else if (data["code"] == 2) {
          return "Could not upload image due to server issues";
        } else if (data["code"] == 600) {
          return "Please upload an image less than 10MB in size";
        } else if (data["code"] == 711) {
          return "Please upload a valid image!";
        } else {
          print(response.data.toString());
          return "Sorry!could not connect to server. Try again.";
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());

      return "A network error occured! Try again!";
    }
  }

  Future<dynamic> save_device_type({String? device_type}) async {
    try {
      var dio = eos.Dio();

      var formData = eos.FormData.fromMap({
        'device_type': device_type,
      });

      var response = await dio.post(baseUrl + 'members/save_device_type',
          data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured";
        } else if (data["code"] == 1) {
          //user was deleted successfully

          return 1;
        } else if (data["code"] == 2) {
          //failed to delete user
          return 2;
        } else {
          //an error occured... possibly server error
          print(response.data.toString());
          return 0;
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());

      return "Sorry! could not connect to server. Try again.";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "Sorry! could not connect to server. Try again.";
    };
  }

  Future<dynamic> save_firebase_token({String? firebase_token}) async {
    String? access_token = user_data["access_token"];
    try {
      var dio = eos.Dio();

      var formData = eos.FormData.fromMap({
        'firebase_token': firebase_token,
      });

      var response = await dio.post(baseUrl + 'members/save_firebase_token',
          data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
              "Authorization": access_token.toString()
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "An error occured";
        } else if (data["code"] == 1) {
          //token saved successfully

          print("ssssssssssssss");

          return 1;
        } else if (data["code"] == 2) {
          //failed to save_firebase_token
          return 2;
        } else {
          //an error occured... possibly server error
          print(response.data.toString());
          return 0;
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());

      return "Sorry! could not connect to server. Try again.";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "Sorry! could not connect to server. Try again.";
    };
  }

  Future<dynamic> get_all_posts() async {
    String? access_token = user_data["access_token"];
    print("access_token" + access_token.toString());

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

  Future<dynamic> get_selected_users() async {
    //get selected members to be followed by new user
    String? access_token = user_data["access_token"];
    print("access_token" + access_token.toString());

    try {
      //eos.Response response;
      var dio = eos.Dio();

      var response = await dio.get(baseUrl + 'members/get_selected_members',
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

  Future<dynamic> get_all_prefs() async {
    //  String? access_token = user_data["access_token"];
    // print("access_token" + access_token.toString());

    try {
      //eos.Response response;
      var dio = eos.Dio();

      var response = await dio.get(baseUrl + 'members/get_all_prefs',
          // data: formData,

          options: eos.Options(
            headers: {
              "accept": "application/json",
              // "Content-Type": "multipart/form-data",
              // "Authorization": access_token.toString()
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
          //store details of user in storage to display on user screen
          Hive.box("room8").put("prefs", data["prefs"]);

          print(data["prefs"].toString());

          return data["prefs"];
        } else if (data["code"] == 0) {
          print("No prefs retrieved");

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
}
