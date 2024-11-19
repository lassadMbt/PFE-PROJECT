// lib/ui/LoginUi.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tataguid/blocs/guest/guest_bloc.dart';
import 'package:tataguid/blocs/guest/guest_event.dart';
import 'package:tataguid/blocs/login/login_bloc.dart';
import 'package:tataguid/blocs/login/login_event.dart';
import 'package:tataguid/blocs/login/login_state.dart';
import 'package:tataguid/blocs/resetPassword/reset_password_event.dart';
import 'package:tataguid/components/my_button.dart';
import 'package:tataguid/components/my_textfield.dart';
import 'package:tataguid/components/square_tile.dart';
import 'package:tataguid/repository/google_sign_in_demo.dart';
import 'package:tataguid/ui/SignUpUi.dart';
import 'package:tataguid/ui/get_contacts.dart';
import '../storage/token_storage.dart';
import '../widgets/first_page.dart';
import '../widgets/second_page.dart';
import '../widgets/third_page.dart';
import 'package:tataguid/blocs/resetPassword/reset_password_bloc.dart';

class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> with SingleTickerProviderStateMixin {
  // TextEditingController emailController = TextEditingController(text: 'mbt.lass.dev@gmail.com' );
  TextEditingController emailController = TextEditingController(text: 'mrabetlassade@gmail.com' );
  // TextEditingController emailController = TextEditingController(text: 'ahmedgharghar@gmail.com' );
  // TextEditingController emailController = TextEditingController(text: 'sana.souai@univ-cotedazur.fr' );
  TextEditingController passwordController = TextEditingController( text: 'Mrabet123&' );

  // TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();

  late LoginBloc authBloc;
  String errorMessage = '';

  late double screenWidth;
  late double screenHeight;

  List<String> otplist = [];
  GlobalKey<FormState> formKey = GlobalKey();
  PageController pageController = PageController();
  TextEditingController forget_email = TextEditingController(/* text: 'raserfinblade@gmail.com' */);
  TextEditingController password = TextEditingController(/* text: '987654321' */);
  TextEditingController confirmPasswordController = TextEditingController(/* text: '987654321' */);
  TextEditingController verificationCode = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  late ResetPasswordBloc resetPasswordBloc;

  // Animation controller and variables
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _logoAnimation;


  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<LoginBloc>(context);
    resetPasswordBloc = BlocProvider.of<ResetPasswordBloc>(context);

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Define the fade-in animation
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Define the logo animation
    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    forget_email.dispose();
    verificationCode.dispose();
    password.dispose();
    confirmPass.dispose();
    confirmPasswordController.dispose();
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  void _loginButtonPressed() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter email and password.';
      });
    } else {
      authBloc.add(LoginButtonPressed(email: email, password: password));
    }
  }

  void _clearErrorMessage() {
    setState(() {
      errorMessage = '';
    });
  }

  void shifting(int currpageindx) {
    setState(() {
      currpageindx += 1;
      print(currpageindx);
      pageController.animateToPage(currpageindx,
          duration: Duration(microseconds: 300), curve: Curves.easeIn);
    });
  }

  void sendVerificationCode(String email) {
    resetPasswordBloc.add(SendVerificationCode(email: email));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is UserLoginSuccessState) {
            if (state.type == 'user') {
              Navigator.pushNamed(context, '/user_dashboard');
            }
          } else if (state is AgencyLoginSuccessState) {
            Navigator.pushNamed(context, '/agency_panel');
          } else if (state is LoginErrorState) {
            // Handle error state
          } else if (state is NavigateToUserDashboard) {
            Navigator.pushNamed(context, '/user_dashboard');
          } else if (state is NavigateToAgencyPanel) {
            Navigator.pushNamed(context, '/agency_panel');
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: ScaleTransition(
                        scale: _logoAnimation,
                        child: Icon(Icons.supervised_user_circle,
                            size: screenWidth * 0.4, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: screenHeight * 0.03),
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                      obscureText: false,
                      onChanged: _clearErrorMessage,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      onChanged: _clearErrorMessage,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Container(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: () {
                            _showBottomWidget(context);
                          },
                          child: Text(
                            "Forget password ?",
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.w700),
                          )),
                    ),
                    MyButton(
                      onPressed: _loginButtonPressed,
                      text: 'Log In',
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(
                          onTap: () => {handelGoogleSignIn()},
                          imagePath: 'assets/images/google.png',
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        SquareTile(
                          imagePath: 'assets/images/apple.png',
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Register now',
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Take the opportunity to visit as a',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: () async {
                            BlocProvider.of<GuestBloc>(context)
                                .add(GenerateGuestID());
                            await TokenStorage.storeUserType('guest');
                            Navigator.pushNamed(context, '/Guest');
                          },
                          child: Text(
                            ' Guest',
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomWidget(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              ForgotPasswordFirstPage(
                screenHeight: screenHeight,
                forgetEmail: forget_email,
                currPageIndex: 0,
                pageController: pageController,
                screenWidth: screenWidth,
                otpList: [],
                formKey: formKey,
                onSubmit: (email) {
                  resetPasswordBloc.add(SendVerificationCode(email: email));
                },
              ),
              ForgotPasswordSecondPage(
                screenHeight: screenHeight,
                forgetEmail: forget_email,
                currPageIndex: 1,
                pageController: pageController,
                screenWidth: screenWidth,
                otpList: [],
                formKey: formKey,
                verificationCodeController: verificationCode,
              ),
              ForgotPasswordThirdPage(
                screenHeight: screenHeight,
                forgetEmail: forget_email,
                currPageIndex: 2,
                pageController: pageController,
                screenWidth: screenWidth,
                otpList: [],
                formKey: formKey,
                passwordController: password,
                confirmPasswordController: confirmPass,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> handelGoogleSignIn() async {
    final user = await LoginAPI.login();
    if (user != null) {
      print("user is not null");
      print(user.photoUrl);
      print(user.email);
      print(user.displayName);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserPage(user: user),
        ),
      );
    } else {
      print("user is null");
    }
  }
}
