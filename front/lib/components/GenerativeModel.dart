/* // lib/GenerativeDescription.dart

import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenerativeDescriptionPage extends StatefulWidget {
  @override
  _GenerativeDescriptionPageState createState() =>
      _GenerativeDescriptionPageState();
}

class _GenerativeDescriptionPageState extends State<GenerativeDescriptionPage> {
  late TextEditingController descriptionController;
  late GenerativeModel generativeModel;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    initializeGenerativeModel();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void initializeGenerativeModel() {
    // Initialize the GenerativeModel with your API key
    final apiKey = Platform.environment['API_KEY'];
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      // Handle error
      return;
    }
    generativeModel = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
  }

  void generateDescription() async {
    // Construct the prompt using the text from your text fields
    final prompt = TextPart("A description of the place");
    final response = await generativeModel.generateContent([Content.text(prompt as String)]);

    // Update the description field with the generated description
    setState(() {
      descriptionController.text = response.text ?? 'No description generated';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Description'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Your text fields for input
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: generateDescription,
              child: Text('Generate Using AI'),
            ),
          ],
        ),
      ),
    );
  }
}


/* import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

class GenerativeDescription {
  // Access your API key as an environment variable (see "Set up your API key" above)
  final apiKey = Platform.environment['API_KEY'];
  if (apiKey == null) async {
    print('No \$API_KEY environment variable');
    exit(1);
  }
  // For text-and-image input (multimodal), use the gemini-pro-vision model
  final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
  final (firstImage, secondImage) = await (
    File('image0.jpg').readAsBytes(),
    File('image1.jpg').readAsBytes()
  ).wait;
  final prompt = TextPart("What's different between these pictures?");
  final imageParts = [
    DataPart('image/jpeg', firstImage),
    DataPart('image/jpeg', secondImage),
  ];
  final response = await model.generateContent([
    Content.multi([prompt, ...imageParts])
  ]);
  print(response.text);
} */ */