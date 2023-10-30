import 'package:exercise_deinde/Components/custom_alert_dialog.dart';
import 'package:exercise_deinde/pages/page_ilb.dart';
import 'package:exercise_deinde/pages/page_ilbsb..dart';
import 'package:exercise_deinde/pages/page_rib.dart';
import 'package:exercise_deinde/pages/page_ribsb.dart';
import 'package:exercise_deinde/repository.dart';
import 'package:flutter/material.dart';

class TypeOFVisualization extends StatefulWidget {
  late String breed;
  TypeOFVisualization({
    Key? key,
    required this.breed,
  }) : super(key: key);

  @override
  State<TypeOFVisualization> createState() => _TypeOFVisualizationState();
}

class _TypeOFVisualizationState extends State<TypeOFVisualization> {
  late String breed;
  List<String> subBreeds = [];
  @override
  void initState() {
    super.initState();
    breed = widget.breed;
    Future.delayed(Duration.zero, () async {
      try {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choose how to see the breed",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Select the type of display\nBreed selected: $breed",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PageRIB(
                        breed: breed,
                      ),
                    ),
                  );
                },
                child: const Text("Random Image by breed"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PageLIB(
                        breed: breed,
                      ),
                    ),
                  );
                },
                child: const Text("Images list by breed"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Text(
                "Options for sub breeds",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            subBreeds.isNotEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PageRIBSB(
                                  breed: breed,
                                  subBreeds: subBreeds,
                                ),
                              ),
                            );
                          },
                          child:
                              const Text("Random image by breed and sub breed"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PageILBSB(
                                  breed: breed,
                                  subBreeds: subBreeds,
                                ),
                              ),
                            );
                          },
                          child:
                              const Text("Images list by breed and sub breed"),
                        ),
                      ),
                    ],
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Didn't  found  any sub breeds",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> request() async {
    List<String>? urls = await Repository.singleton.fetchAllSubBreeds(breed);
    if (urls != null) {
      setState(() {
        subBreeds = urls;
      });
    }
  }
}
