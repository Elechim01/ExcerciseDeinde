import 'package:flutter/material.dart';

class CustomList extends StatefulWidget {
  late Future<List<String>> Function() getElement;

  CustomList({
    Key? key,
    required this.getElement,
  }) : super(key: key);

  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  List<String> totalUrls = [];
  List<String> urls = [];
  int numberOfElement = 20;
  final ScrollController _scrollController = ScrollController();
  bool showProgressView = false;

  @override
  void initState() {
    super.initState();

    fetchElement();

    _scrollController.addListener(() {
      scrollListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (totalUrls.isEmpty) {
      return SizedBox(
        width: 200,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            fetchElement();
          },
          child: const Text("Refetch"),
        ),
      );
    } else {
      return SizedBox(
        height: 400,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemCount: urls.length,
          itemBuilder: (context, index) {
            if (index == urls.length - 1) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(
                      urls[index],
                      width: 300,
                      height: 300,
                    ),
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
              child: Image.network(
                urls[index],
                width: 300,
                height: 300,
              ),
            );
          },
        ),
      );
    }
  }

  void fetchElement() {
    widget.getElement().then((value) {
      setState(() {
        totalUrls = value;
        if (urls.length > (totalUrls.length - numberOfElement)) {
          urls = totalUrls.getRange(urls.length, totalUrls.length).toList();
        } else {
          urls = totalUrls
              .getRange(urls.length, urls.length + numberOfElement)
              .toList();
        }
      });
    });
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
