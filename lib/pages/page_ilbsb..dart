import 'package:exercise_deinde/Components/custom_alert_dialog.dart';
import 'package:exercise_deinde/Components/custom_list.dart';
import 'package:exercise_deinde/repository.dart';
import 'package:flutter/material.dart';

class PageILBSB extends StatefulWidget {
  late String breed;
  late List<String> subBreeds;
  PageILBSB({
    Key? key,
    required this.breed,
    required this.subBreeds,
  }) : super(key: key);

  @override
  State<PageILBSB> createState() => _PageILBSBState();
}

class _PageILBSBState extends State<PageILBSB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Images List for  ${widget.breed}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                child: Text(
                  "breed ${widget.breed}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              CustomList(
                getElement: () async {
                  try {
                    List<String>? result = await Repository.singleton
                        .fetchImageListByBreed(widget.breed);
                    if (result != null) {
                      return result;
                    } else {
                      return [];
                    }
                  } catch (error) {
                    print(error.toString());
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                              error: error.toString(), request: request);
                        });

                    return [];
                  }
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.subBreeds.length,
                itemBuilder: (context, index) {
                  String localSubBreed = widget.subBreeds[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        child: Text(
                          "Sub-Breed $localSubBreed",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomList(
                        getElement: () async {
                          try {
                            List<String>? result = await Repository.singleton
                                .fetchImageListBySubBreed(
                                    widget.breed, localSubBreed);
                            if (result != null) {
                              return result;
                            } else {
                              return [];
                            }
                          } catch (error) {
                            print(error.toString());
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlertDialog(
                                      error: error.toString(),
                                      request: request);
                                });
                            return [];
                          }
                        },
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> request() async {
    setState(() {});
  }
}
