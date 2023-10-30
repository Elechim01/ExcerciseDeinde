import 'package:exercise_deinde/Components/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

import 'package:exercise_deinde/repository.dart';

class PageRIB extends StatefulWidget {
  late String breed;

  PageRIB({
    Key? key,
    required this.breed,
  }) : super(key: key);

  @override
  State<PageRIB> createState() => _PageRIBState();
}

class _PageRIBState extends State<PageRIB> {
  String? url;
  late String breed;
  bool showCircularProgressView = false;

  @override
  void initState() {
    super.initState();
    breed = widget.breed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Random image ",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.yellow)),
                onPressed: () async {
                  await fetchRandomImage();
                },
                child: Text(
                  "Random image by $breed",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            url != null
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(url!),
                  )
                : Container(),
            showCircularProgressView
                ? const CircularProgressIndicator()
                : Container()
          ],
        ),
      ),
    );
  }

  Future<void> fetchRandomImage() async {
    try {
      setState(() {
        showCircularProgressView = true;
      });

      String? urlImage =
          await Repository.singleton.fetchRandomImageByBreed(breed);
      if (urlImage != null) {
        setState(() {
          url = urlImage;
          showCircularProgressView = false;
        });
      }
    } catch (error) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(error: error.toString(), request: request);
          });
    }
  }

  Future<void> request() async {
    setState(() {});
  }
}
