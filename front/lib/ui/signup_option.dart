import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tataguid/blocs/signup/signup_event.dart';
import 'package:tataguid/blocs/signup/signup_state.dart';
import 'package:tataguid/ui/LoginUi.dart';
import 'package:tataguid/ui/get_contacts.dart';

import '../blocs/signup/signup_bloc.dart';
import '../widgets/BuildTextfield.dart';

class SignupOptions extends StatefulWidget {
  final String email;
  final String password;

  const SignupOptions({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<SignupOptions> createState() => _SignupOptionsState();
}

class _SignupOptionsState extends State<SignupOptions> {
  bool _current = true; // Set default value for _current
  PageController _controller = PageController();
  late SignupBloc _signupBloc;

  final TextEditingController nameController =
      TextEditingController(/* text: 'userName' */);
  final TextEditingController languageController =
      TextEditingController(/* text: 'userLaguage' */);
  final TextEditingController countryController =
      TextEditingController(/* text: 'userCountry' */);
  final TextEditingController agencyNameController =
      TextEditingController(/* text: 'agencyName' */);
  final TextEditingController locationController =
      TextEditingController(/* text: 'agencyLocation' */);
  final TextEditingController descriptionController =
      TextEditingController(/* text: 'agencySecription' */);
  final TextEditingController phoneNumberController =
      TextEditingController(/* text: '25418279' */);
  String selectedRole = ''; // Variable to store the selected role

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupRoleSelectedState) {
              // _selectedRole();
            }
            if (state is UserSignupSuccessState) {
              _handleUserSuccessfulSignup();
            } else if (state is AgencySignupSuccessState) {
              _handleAgencySuccessfulSignup();
            } else if (state is SignupErrorState) {
              _showErrorSnackBar(state.message);
            } else if (state is EmailExistState) {
              _showExistmessageSnackBar(state.Existmessage);
            } else if (state is FinalizeSignupState) {
              _onFinalizeSignupEvent();
            }
          },
          child: SafeArea(
            child: Container(
                margin: EdgeInsets.all(10),
                child: PageView(
                  controller: _controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // User Selection Page
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select your role",
                          style: TextStyle(
                            fontSize: size.width * 0.09,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Expanded(
                          child: Image.asset("assets/images/tour.png"),
                        ),
                        SizedBox(height: size.height * 0.1),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  _current ? HexColor("#6709eb") : Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RadioListTile<bool>(
                            value: true,
                            groupValue: _current,
                            title: Text(
                              "User",
                              style: TextStyle(
                                color: _current
                                    ? HexColor("#6709eb")
                                    : Colors.black,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _current = value!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                            activeColor: HexColor("#6709eb"),
                            secondary: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: !_current
                                  ? HexColor("#6709eb")
                                  : Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RadioListTile<bool>(
                            value: false,
                            groupValue: _current,
                            title: Text(
                              "Agency",
                              style: TextStyle(
                                color: !_current
                                    ? HexColor("#6709eb")
                                    : Colors.black,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _current = value!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                            activeColor: HexColor("#6709eb"),
                            secondary: Icon(Icons.business_rounded),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                            onPressed: () {
                              _selectedRole();
                            },
                            child: Text("Next",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * 0.04)),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignupOptions(
                                        email: widget.email, // Use widget.email
                                        password: widget
                                            .password, // Use widget.password
                                      )));
                            }),
                        Text("Fill all the details , carefully",
                            style: TextStyle(
                                fontSize: size.width * 0.06,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: size.height * 0.03),
                        BuildTextFormField(
                          'name',
                          nameController,
                          (value) {
                            // Implement name validation
                            if (value!.isEmpty) {
                              return "Name cannot be empty";
                            }
                            return null;
                          },
                          TextInputType.text,
                          Icons.account_circle,
                        ),
                        SizedBox(height: size.height * 0.03),
                        BuildTextFormField(
                          'language',
                          languageController,
                          (value) {
                            // Email validation logic
                            if (value!.isEmpty) {
                              return "Language cannot be empty";
                            }

                            return null;
                          },
                          TextInputType.text,
                          Icons.language,
                        ),
                        SizedBox(height: size.height * 0.03),
                        BuildTextFormField(
                          'Country',
                          countryController,
                          (value) {
                            if (value!.isEmpty) {
                              return "Country cannot be empty";
                            }

                            // Email validation logic
                            return null;
                          },
                          TextInputType.text,
                          Icons.location_on,
                        ),
                        SizedBox(height: size.height * 0.03),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                            onPressed: _onFinalizeSignupEvent,
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignupOptions(
                                      email: widget.email, // Use widget.email
                                      password: widget
                                          .password, // Use widget.password
                                    )));
                          },
                        ),
                        Text("Fill all the details , carefully",
                            style: TextStyle(
                                fontSize: size.width * 0.06,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: size.height * 0.03),
                        BuildTextFormField(
                          'agency name',
                          agencyNameController,
                          (value) {
                            // Email validation logic
                            return null;
                          },
                          TextInputType.text,
                          Icons.account_circle,
                        ),
                        SizedBox(height: size.height * 0.03),
                        BuildTextFormField(
                          'Location',
                          locationController,
                          (value) {
                            // Email validation logic
                            return null;
                          },
                          TextInputType.text,
                          Icons.location_city,
                        ),
                        SizedBox(height: size.height * 0.03),
                        BuildTextFormField(
                          'PhoneNumber',
                          phoneNumberController,
                          (value) {
                            // Email validation logic
                            return null;
                          },
                          TextInputType.text,
                          Icons.add_ic_call_rounded,
                        ),
                        SizedBox(height: size.height * 0.03),
                        BuildTextFormField(
                          'Description',
                          descriptionController,
                          (value) {
                            // Email validation logic
                            return null;
                          },
                          TextInputType.text,
                          Icons.description,
                        ),
                        SizedBox(height: size.height * 0.03),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                            onPressed: _onFinalizeSignupEvent,
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          )),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
  
  void _showExistmessageSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

  void _selectedRole() {
    if (_current == true) {
      // User role selected, navigate to user form page
      selectedRole = "User"; // Update selectedRole
      _signupBloc.add(TriggerRoleSelectionEvent(
        type: "User",
      ));
      _controller.animateToPage(1,
          duration: Duration(milliseconds: 10), curve: Curves.easeIn);
    } else {
      // Agency role selected, navigate to agency form page directly
      selectedRole = "Agency"; // Update selectedRole
      _signupBloc.add(TriggerRoleSelectionEvent(
        type: "Agency",
      ));
      _controller
        ..animateToPage(2,
            duration: Duration(milliseconds: 10), curve: Curves.easeIn);
    }
  }

  void _handleUserSuccessfulSignup() {
    if (nameController.text.isEmpty ||
        languageController.text.isEmpty ||
        countryController.text.isEmpty) {
      _showErrorSnackBar("Please fill in all the details");
      return;
    }
    _navigateToUserPage();
  }

  void _navigateToUserPage() {
    _signupBloc.add(SignupUserFieldsEvent(
      name: nameController.text,
      language: languageController.text,
      country: countryController.text,
    ));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserPage()),
    );
  }

  void _handleAgencySuccessfulSignup() {
    _signupBloc.add(SignupAgencyFieldsEvent(
      agencyName: agencyNameController.text,
      description: descriptionController.text,
      location: locationController.text,
      phoneNumber: phoneNumberController.text,
    ));
    // Navigate to Login UI
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginUi()),
    );

    // Show SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Your registration request will be checked soon by the admin."),
        backgroundColor: Colors.lightBlue, // Adjust color as needed
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onFinalizeSignupEvent() {
    if (selectedRole == "User") {
      _signupBloc.add(FinalizeSignupEvent(
        email: widget.email,
        password: widget.password,
        name: nameController.text,
        agencyName: '', // No need to pass agencyName for user
        type: selectedRole.toLowerCase(), // Convert to lowercase
        language: languageController.text,
        country: countryController.text,
        location: '', // No need to pass location for user
        description: '', // No need to pass description for user
        phoneNumber: '', // No need to pass phoneNumber for user
      ));
    } else if (selectedRole == "Agency") {
      _signupBloc.add(FinalizeSignupEvent(
        email: widget.email,
        password: widget.password,
        name: '', // No need to pass name for agency
        agencyName: agencyNameController.text,
        type: selectedRole.toLowerCase(), // Convert to lowercase
        language: '', // No need to pass language for agency
        country: '', // No need to pass country for agency
        location: locationController.text,
        description: descriptionController.text,
        phoneNumber: phoneNumberController.text,
      ));
    }
  }
}


