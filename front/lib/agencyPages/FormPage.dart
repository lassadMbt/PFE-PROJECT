import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tataguid/blocs/uploadBloc/upload_bloc.dart';
import 'package:tataguid/blocs/uploadBloc/upload_event.dart';
import 'package:tataguid/models/upload.model.dart';
import 'package:tataguid/storage/token_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class AgencyForm extends StatefulWidget {
  const AgencyForm({super.key});

  @override
  State<AgencyForm> createState() => _AgencyFormState();
}

class _AgencyFormState extends State<AgencyForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final PageController pageController = PageController();
  final List<File> _selectedImages = [];

  final UploadModel _uploadModel = UploadModel(
    title: '',
    placeName: '',
    StartEndPoint: '',
    photos: [],
    visitDate: '',
    price: 0.0,
    description: '',
    duration: '',
    HotelName: '',
    CheckInOut: '',
    accessibility: '',
    phoneNumber: '',
  );
  TextEditingController title = TextEditingController(/* text: 'visite' */);
  TextEditingController placeName = TextEditingController(/* text: 'tataouine' */);
  TextEditingController price = TextEditingController(/* text: '50dt' */);
  TextEditingController description = TextEditingController(/* text: 'a description' */);
  TextEditingController hotelName = TextEditingController(/* text: 'Dakianouss' */);
  TextEditingController accessibility =TextEditingController(/* text: 'Wheelchair accessible' */);
  TextEditingController start = TextEditingController(/* text: '25/05/2024' */);
  TextEditingController end = TextEditingController(/* text: '30/05/2024' */);
  TextEditingController from = TextEditingController(/* text: 'Douz' */);
  TextEditingController to = TextEditingController(/* text: 'chneni' */);
  TextEditingController checkIn = TextEditingController(/* text: '12:30' */);
  TextEditingController checkOut = TextEditingController(/* text: '12:30' */);
  TextEditingController duration = TextEditingController(/* text: '5 days' */);
  TextEditingController phoneNumber = TextEditingController(/* text: '58 037 648' */);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    start.dispose();
    end.dispose();
    price.dispose();
    from.dispose();
    to.dispose();
    description.dispose();
    placeName.dispose();
    checkIn.dispose();
    checkOut.dispose();
    hotelName.dispose();
    accessibility.dispose();
    phoneNumber.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _nextPage() {
    if (formKey.currentState?.validate() ?? false) {
      pageController.nextPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
        // arguments: {'title': title, 'images': _selectedImages.toList()},
      );
    }
  }

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      // Get the stored token from TokenStorage
      final token = await TokenStorage.getToken();
      if (token == null) {
        print('Token not available');
        return;
      }
      // Get the stored user type from TokenStorage
      final userType = await TokenStorage.getUserType();
      if (userType == null) {
        print('User type not available');
        return;
      }
      // Check if the token and user type exist
      if (userType == 'agency') {
        // Get the stored agency ID from TokenStorage
        final agencyId = await TokenStorage.getAgencyId();
        if (agencyId == null) {
          // Handle scenario when agency ID is not available
          print('Agency ID not available');
          return;
        }
        // Convert price from String to double
        final double? priceValue = double.tryParse(price.text);
        if (priceValue == null) {
          // Handle invalid price value
          print('Invalid price value');
          return;
        }

        // Create an instance of UploadModel
        final uploadModel = UploadModel(
          agencyId: agencyId,
          title: title.text,
          placeName: placeName.text,
          StartEndPoint:
              'the start point is from ${/* start.text */from.text} to the ${to.text/* end.text */}',
          photos: _selectedImages.map((file) => file.path).toList(),
          visitDate: 'from the ${/* from.text */start.text} to the ${end.text/* to.text */}',
          price: priceValue,
          description: description.text,
          duration: duration.text,
          HotelName: hotelName.text,
          CheckInOut:
              'the checkIn will be in the ${checkIn.text} and the checkOut in the ${checkOut.text}',
          accessibility: accessibility.text,
          phoneNumber: phoneNumber.text,
        );

        // Call the BLoC event to upload the data
        context.read<UploadBloc>().add(UploadData(
              agencyId: agencyId, // Replace with the actual agency ID
              token: token,
              uploadModel: uploadModel,
            ));

        // Show a snack bar to notify that the place is added successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Place added successfully'),
          ),
        );

        // Navigate to AgencyHome()
        Navigator.of(context).pushReplacementNamed('/agency_home');
      } else {
        print('User type is not agency');
      }
    }
  }

  Future<void> _handleImageSelection() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages != null) {
      setState(() {
        _selectedImages
            .addAll(pickedImages.map((pickedImage) => File(pickedImage.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _generateDescription() async {
    // Récupérez les images sélectionnées par l'utilisateur (vous devrez implémenter cette partie)
    final selectedImages = await _getSelectedImages();

    final generatedDescription = await generateDescription(
      selectedImages,
      title.text,
      start.text,
      end.text,
      "${from.text} - ${to.text}",
      phoneNumber.text
    );

    // Mettez à jour le TextEditingController de description avec la description générée
    setState(() {
      description.text = generatedDescription!;
    });
  }

  Future<List<File>> _getSelectedImages() async {
    // Retournez simplement les images sélectionnées
    return _selectedImages;
  }

  Future<String?> generateDescription(
    List<File> _getSelectedImages,
    String title,
    String startPoint,
    String destination,
    String duration, 
    String phoneNumber,
    /* String description */
  ) async {
    // Accédez à votre clé API comme une variable d'environnement
    final apiKey = 'AIzaSyBuCToJcsmJ-esv1Sftxz1jWZeFTtUs_Ho';
    if (apiKey == null) {
      throw Exception('No \$API_KEY environment variable');
    }

    // Créez une instance du modèle gemini-pro-vision
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);

    // Lisez les fichiers d'images en tant que bytes
    final imageBytes = await Future.wait(
        _getSelectedImages.map((image) => image.readAsBytes()));

    // Créez les parties de texte et d'images pour la requête
    final prompt = TextPart(
        "Generate a detailed description of a travel package based on the following information: Title: $title, Image: $_getSelectedImages, Starting point: $startPoint, Destination: $destination, Duration: $duration, Phone Number: $phoneNumber");
    //, Initial description: $description
    final imageParts =
        imageBytes.map((bytes) => DataPart('image/jpeg', bytes)).toList();

    // Générez le contenu en utilisant le modèle gemini-pro-vision
    final response = await model.generateContent([
      Content.multi([prompt, ...imageParts])
    ]);

    return response.text;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Form(
            key: formKey,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Add new Package",
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 1,
                          width: screenWidth,
                          color: Colors.grey,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Title',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: title,
                              decoration: InputDecoration(
                                hintText: "Enter the title",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Attach Documents',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            DottedBorder(
                              color: HexColor("#551656"),
                              dashPattern: [10],
                              strokeWidth: 4,
                              child: GestureDetector(
                                onTap: _handleImageSelection,
                                child: Container(
                                  width: screenWidth,
                                  height: screenHeight * 0.35,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/agencyImages/upload.png",
                                        width: screenWidth * 0.17,
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      Text(
                                        'Click to pick images',
                                        style: TextStyle(
                                          color: HexColor("#2996E4"),
                                          fontSize: screenWidth * 0.07,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: _handleImageSelection,
                                        child: Text('Pick Images'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        _selectedImages.isNotEmpty
                            ? CarouselSlider(
                                options: CarouselOptions(
                                  height: screenHeight * 0.50,
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: false,
                                ),
                                items: _selectedImages
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  File image = entry.value;
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10.0,
                                                  spreadRadius: 2.0,
                                                  offset: Offset(0.0, 0.0),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Image.file(
                                                image,
                                                fit: BoxFit.scaleDown,
                                                width: screenWidth * 0.50,
                                                height: screenHeight * 0.50,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 8,
                                            top: 8,
                                            child: GestureDetector(
                                              onTap: () => _removeImage(index),
                                              child: Icon(
                                                Icons.cancel_rounded,
                                                color: Colors.red,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }).toList(),
                              )
                            : Container(),
                        SizedBox(height: screenHeight * 0.05),
                        Container(
                          width: screenWidth,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  HexColor("#1E9CFF")),
                            ),
                            onPressed: _nextPage,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Next",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.05),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            pageController.previousPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.ease);
                          },
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: Colors.black),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'placeName',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: placeName,
                              decoration: InputDecoration(
                                hintText: "Add a placeName",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a placeName';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Starting Point',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: from,
                              decoration: InputDecoration(
                                hintText: "From",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the starting point';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Ending Point',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: to,
                              decoration: InputDecoration(
                                hintText: "To",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the ending point';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Start',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  TextFormField(
                                    controller: start,
                                    decoration: InputDecoration(
                                      hintText: "dd/mm/yyyy",
                                      filled: true,
                                      fillColor: Colors.white60,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the start date';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'End',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  TextFormField(
                                    controller: end,
                                    decoration: InputDecoration(
                                      hintText: "dd/mm/yyyy",
                                      filled: true,
                                      fillColor: Colors.white60,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the end date';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Phone Numbre',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: phoneNumber,
                              decoration: InputDecoration(
                                hintText: "(+216) Enter your phone number",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                final phoneNumber = value.replaceAll(
                                    ' ', ''); // Remove spaces for validation
                                if (double.tryParse(phoneNumber) == null) {
                                  _showSnackBar(
                                      'The phone number must be a valid number');
                                  return 'The phone number must be a valid number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Price',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: price,
                              decoration: InputDecoration(
                                hintText: "\dt00.0",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the price';
                                }
                                final priceValue = value.replaceAll('dt', '');
                                if (double.tryParse(priceValue) == null) {
                                  _showSnackBar(
                                      'The price must be a valid number');
                                  return 'The price must be a valid number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Description',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.045,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: description,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "Write a brief description",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              "Note: Mistakes can occur. Please review your description before submitting.",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _generateDescription,
                              child: Text('Generate Description'),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Duration',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.045,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: duration,
                              decoration: InputDecoration(
                                hintText: "Add a Duration",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a duration';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hotel Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: hotelName,
                              decoration: InputDecoration(
                                hintText: "Enter the hotel name",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Check-in",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenWidth * 0.045),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  TextFormField(
                                    controller: checkIn,
                                    decoration: InputDecoration(
                                      hintText: "00:00",
                                      filled: true,
                                      fillColor: Colors.white60,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Check-out",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenWidth * 0.045),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  TextFormField(
                                    controller: checkOut,
                                    decoration: InputDecoration(
                                      hintText: "00:00",
                                      filled: true,
                                      fillColor: Colors.white60,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                          SizedBox(height: screenHeight * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Accessibility",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.045),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: accessibility,
                              decoration: InputDecoration(
                                hintText: "Enter the Accessibility",
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Container(
                          width: screenWidth,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  HexColor("#1E9CFF")),
                            ),
                            onPressed: _submitForm,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015),
                              child: Text(
                                "Create Package",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
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
