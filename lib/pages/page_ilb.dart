import 'dart:ffi';

import 'package:exercise_deinde/Components/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

import 'package:exercise_deinde/repository.dart';

class PageLIB extends StatefulWidget {
  late String breed;

  PageLIB({
    Key? key,
    required this.breed,
  }) : super(key: key);

  @override
  State<PageLIB> createState() => _PageLIBState();
}

class _PageLIBState extends State<PageLIB> {
  List<String> totalUrls = [];
  List<String> urls = [];
  int numberOfElement = 20;
  final ScrollController _scrollController = ScrollController();
  bool showProgressView = false;
  late String breed;

  @override
  void initState() {
    super.initState();
    breed = widget.breed;
    _scrollController.addListener(() {
      scrollListener();
    });

    Future.delayed(Duration.zero, () async {
      await fetchImagesListByBreed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Images list by breed",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: urls.length,
              itemBuilder: (context, index) {
                if (index == urls.length - 1) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(urls[index]),
                      ),
                      showProgressView
                          ? const Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: CircularProgressIndicator(),
                            )
                          : Container()
                    ],
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(urls[index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> fetchImagesListByBreed() async {
    try {
      setState(() {
        totalUrls = [];
        urls = [];
      });
      await request();
    } catch (error) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(
              error: error.toString(),
              request: request,
            );
          });
    }
  }

  Future<void> request() async {
    List<String>? urlsImages =
        await Repository.singleton.fetchImageListByBreed(breed);

    if (urlsImages != null) {
      print(urlsImages.length);
      setState(() {
        totalUrls = urlsImages;
        if (urls.length > (totalUrls.length - numberOfElement)) {
          urls = totalUrls.getRange(urls.length, totalUrls.length).toList();
        } else {
          urls = totalUrls
              .getRange(urls.length, urls.length + numberOfElement)
              .toList();
        }
      });
    }
  }

  void scrollListener() {
    setState(() {
      if (urls.length < totalUrls.length) {
        showProgressView = true;
      }
    });
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      List<String> newElement = [];
      if (urls.length > (totalUrls.length - numberOfElement)) {
        newElement = totalUrls.getRange(urls.length, totalUrls.length).toList();
      } else {
        newElement = totalUrls
            .getRange(urls.length, urls.length + numberOfElement)
            .toList();
      }
      urls.addAll(newElement);
      setState(() {
        showProgressView = false;
      });
    }
  }
}
