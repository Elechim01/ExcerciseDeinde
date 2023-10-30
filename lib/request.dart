import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

class ManagerRequest {
  static String listAllBreeds = "/all";
  //"https://dog.ceo/api/breeds/list/all";

  static String root = "https://dog.ceo/api/";

  static String breeds = "breeds/";

  static String breed = "breed/";

  static String randomImageByBreedURL = "/images/random";

  static String list = "list";

// https://dog.ceo/api/breed/hound/images/random

  static String imagesListByBreed = "/images";

  static Future<Map<String, dynamic>?> fetchData(String url) async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        HttpClient client = HttpClient();
        HttpClientRequest request = await client.getUrl(
          Uri.parse(url),
        );
        HttpClientResponse response = await request.close();
        if (response.statusCode == 200) {
          String content = await utf8.decodeStream(response);
          Map<String, dynamic> map = json.decode(content);
          return map;
        } else {
          throw "Error request";
        }
      }
    } on SocketException catch (_) {
      print('not connected');
      throw "No Connession";
    }
    return null;
  }
}
