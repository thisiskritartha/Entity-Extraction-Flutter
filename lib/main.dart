import 'package:flutter/material.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  String result = 'Extracted Entities';
  bool isModelDownloaded = false;
  dynamic modelManager;
  dynamic entityExtractor;

  @override
  void initState() {
    super.initState();
    modelManager = EntityExtractorModelManager();
    checkAndDownloadModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkAndDownloadModel() async {
    isModelDownloaded = await modelManager
        .isModelDownloaded(EntityExtractorLanguage.english.name);

    if (!isModelDownloaded) {
      isModelDownloaded = await modelManager
          .downloadModel(EntityExtractorLanguage.english.name);
    }

    if (isModelDownloaded) {
      entityExtractor =
          EntityExtractor(language: EntityExtractorLanguage.english);
    }
  }

  extractEntity(String text) async {
    if (isModelDownloaded) {
      final List<EntityAnnotation> annotations =
          await entityExtractor.annotateText(text);
      result = '';
      for (final annotation in annotations) {
        print(annotation.text);

        for (final entity in annotation.entities) {
          print(entity.type.name);
          result += '${entity.type.name.toUpperCase()}: ${annotation.text}\n';
        }
      }
    } else {
      result =
          'Please Check your connectivity first to Download the Language Model.';
      checkAndDownloadModel();
    }
    setState(() {
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/wall.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text(
                    'ENTITY EXTRACTION',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  width: double.infinity,
                  height: 250,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  child: Card(
                    color: Colors.white,
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Type text here...',
                          filled: true,
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.black),
                        maxLines: 100,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 20),
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      extractEntity(textEditingController.text);
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: const Text(
                      'Extract Entity',
                      style: TextStyle(fontSize: 30, letterSpacing: 2),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 60),
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 25.0,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      result,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
