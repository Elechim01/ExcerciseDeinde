import 'dart:convert';

import 'package:exercise_deinde/request.dart';

class Repository {
  static Repository singleton = Repository();

  Future<List<String>?> fetchAllBreed() async {
    List<String> breedList = [];
    String url = ManagerRequest.root +
        ManagerRequest.breeds +
        ManagerRequest.list +
        ManagerRequest.listAllBreeds;

    Map<String, dynamic>? result = await ManagerRequest.fetchData(url);

    if (result == null) {
      return null;
    } else {
      Map<String, dynamic> message = result["message"];
      message.forEach((breed, subBreed) {
        breedList.add(breed);
      });
      return breedList;
    }
  }

  Future<String?> fetchRandomImageByBreed(String breed) async {
    String url = ManagerRequest.root +
        ManagerRequest.breed +
        breed +
        ManagerRequest.randomImageByBreedURL;

    print(url);
    Map<String, dynamic>? result = await ManagerRequest.fetchData(url);
    if (result != null) {
      return result["message"] as String;
    } else {
      return null;
    }
  }

  Future<List<String>?> fetchImageListByBreed(String breed) async {
    String url = ManagerRequest.root +
        ManagerRequest.breed +
        breed +
        ManagerRequest.imagesListByBreed;

    Map<String, dynamic>? result = await ManagerRequest.fetchData(url);
    if (result != null) {
      return (result["message"] as List<dynamic>)
          .map((e) => e as String)
          .toList();
    } else {
      return null;
    }
  }

  Future<List<String>?> fetchAllSubBreeds(String breed) async {
    String url =
        "${ManagerRequest.root}${ManagerRequest.breed}$breed/${ManagerRequest.list}";

    Map<String, dynamic>? result = await ManagerRequest.fetchData(url);

    if (result == null) {
      return null;
    } else {
      return (result["message"] as List<dynamic>)
          .map((e) => e as String)
          .toList();
    }
  }

  Future<String?> fetchRandomImageFromSubBreed(
      String breed, String subBreed) async {
    String url =
        "${ManagerRequest.root}${ManagerRequest.breed}$breed/$subBreed${ManagerRequest.randomImageByBreedURL}";

    Map<String, dynamic>? result = await ManagerRequest.fetchData(url);
    if (result != null) {
      return result["message"] as String;
    } else {
      return null;
    }
  }

  Future<List<String>?> fetchImageListBySubBreed(
      String breed, String subBreed) async {
    String url =
        "${ManagerRequest.root}${ManagerRequest.breed}$breed/$subBreed${ManagerRequest.imagesListByBreed}";

    Map<String, dynamic>? result = await ManagerRequest.fetchData(url);
    if (result != null) {
      return (result["message"] as List<dynamic>)
          .map((e) => e as String)
          .toList();
    } else {
      return null;
    }
  }
}
