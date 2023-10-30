import 'package:exercise_deinde/Components/custom_alert_dialog.dart';
import 'package:exercise_deinde/pages/page_ilb.dart';
import 'package:exercise_deinde/pages/page_rib.dart';
import 'package:exercise_deinde/pages/type_of_visualization.dart';
import 'package:exercise_deinde/repository.dart';
import 'package:exercise_deinde/request.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? url;
  List<String> donwloadedBreeds = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        await request();
      } catch (error) {
        // ignore: use_build_context_synchronously
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
          "Welcome",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Choose the breed of dog to display',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: donwloadedBreeds.length,
                itemBuilder: ((context, index) {
                  return customButton(
                    donwloadedBreeds[index],
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) {
                            return TypeOFVisualization(
                                breed: donwloadedBreeds[index]);
                          }),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customButton(String testo, void Function() onPress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(15),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Type: $testo",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Future<void> request() async {
    List<String>? breed = await Repository.singleton.fetchAllBreed();
    if (breed != null) {
      setState(() {
        donwloadedBreeds = breed;
      });
    }
  }
}
