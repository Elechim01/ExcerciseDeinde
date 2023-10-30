import 'package:exercise_deinde/Components/custom_alert_dialog.dart';
import 'package:exercise_deinde/repository.dart';
import 'package:flutter/material.dart';

class PageRIBSB extends StatefulWidget {
  late String breed;
  late List<String> subBreeds;

  PageRIBSB({
    Key? key,
    required this.breed,
    required this.subBreeds,
  }) : super(key: key);

  @override
  State<PageRIBSB> createState() => _PageRIBSBState();
}

class _PageRIBSBState extends State<PageRIBSB> {
  late String breed;
  List<String> imageBreed = [];
  bool showCircularProgressView = false;

  int countIteration = 0;
  @override
  void initState() {
    super.initState();
    breed = widget.breed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Random image for $breed",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow)),
              onPressed: () async {
                imageBreed = [];
                await fetchRandomImage();
              },
              child: const Text(
                "Generate image",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            showCircularProgressView
                ? const CircularProgressIndicator()
                : Container(),
            Expanded(
              child: ListView.builder(
                itemCount: imageBreed.length,
                itemBuilder: (context, index) {
                  if (index > 0) {
                    return Column(
                      children: [
                        Text(
                          "Sub breed ${widget.subBreeds[index - 1]}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.network(imageBreed[index]),
                        ),
                      ],
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(imageBreed[index]),
                  );
                },
              ),
            )
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
        imageBreed.add(urlImage);
        countIteration = 0;
        await _fetchRandomImageFromSubBreed(widget.subBreeds[countIteration]);
      }
    } catch (error) {
      imageBreed = [];
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(error: error.toString(), request: request);
          });
    }
  }

  Future<void> _fetchRandomImageFromSubBreed(String subBreed) async {
    try {
      String? urlImage = await Repository.singleton
          .fetchRandomImageFromSubBreed(breed, subBreed);
      if (urlImage != null) {
        imageBreed.add(urlImage);
        countIteration += 1;
        if (countIteration < widget.subBreeds.length) {
          await _fetchRandomImageFromSubBreed(widget.subBreeds[countIteration]);
        } else {
          setState(() {
            showCircularProgressView = false;
          });
        }
      }
    } catch (error) {
      imageBreed = [];
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
