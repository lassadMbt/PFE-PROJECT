// lib/agencyPages/general_information_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tataguid/blocs/profile/profile_bloc.dart';
import 'package:tataguid/blocs/profile/profile_event.dart';
import 'package:tataguid/blocs/profile/profile_state.dart';
import 'package:tataguid/repository/profil_repo.dart';
import 'package:tataguid/agencyPages/profilePage.dart';  // Import the ProfilePage

class GeneralInformationPage extends StatefulWidget {
  final String email;
  final String token;

  const GeneralInformationPage({
    required this.email,
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  _GeneralInformationPageState createState() => _GeneralInformationPageState();
}

class _GeneralInformationPageState extends State<GeneralInformationPage> {
  final _agencyNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _agencyNameController.dispose();
    _locationController.dispose();
    _phoneNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: ProfileRepository(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#1E9CFF"),
          title: const Text(
            "General Information",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField("Agency Name", _agencyNameController, screenWidth, screenHeight),
                buildTextField("Location", _locationController, screenWidth, screenHeight),
                buildPhoneNumberField("Contact Information", _phoneNumberController, screenWidth, screenHeight),
                buildTextField("Description", _descriptionController, screenWidth, screenHeight, maxLines: 5),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Map<String, String?> updateFields = {
                        'agencyName': _agencyNameController.text.isNotEmpty ? _agencyNameController.text : null,
                        'location': _locationController.text.isNotEmpty ? _locationController.text : null,
                        'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                        'phoneNumber': _phoneNumberController.text.isNotEmpty ? _phoneNumberController.text : null,
                      };

                      context.read<ProfileBloc>().add(UpdateAgencyProfile(
                        email: widget.email,
                        token: widget.token,
                        agencyName: updateFields['agencyName'],
                        location: updateFields['location'],
                        description: updateFields['description'],
                        phoneNumber: updateFields['phoneNumber'],
                      ));
                    },
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message ?? 'Profile updated successfully')),
                      );
                      Navigator.pop(context, true);  // Return true when the update is successful
                    } else if (state is ProfileFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.error}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const CircularProgressIndicator();
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, double screenWidth, double screenHeight, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.045,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: "Enter ${label.toLowerCase()}",
            filled: true,
            fillColor: Colors.white60,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  Widget buildPhoneNumberField(String label, TextEditingController controller, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.045,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Enter new phone number",
            filled: true,
            fillColor: Colors.white60,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }
}
