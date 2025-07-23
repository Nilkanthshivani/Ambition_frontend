import 'dart:developer';

import 'package:ambition_delivery/data/models/driver_form_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../bloc/auth_bloc.dart';
import '../../widgets/user_type_selector.dart';
import 'emailsignup.dart';
import 'package:geolocator/geolocator.dart';

import 'package:ambition_delivery/presentation/pages/auth/driver_signup_additional_info_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DriverFormData driverFormData = DriverFormData();
  final List<String> _dropdownMenuItems = ['Passenger', 'Driver'];
  String? _selectedItem = 'Passenger';

  final PhoneController phoneNumberController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.GB, nsn: ''),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: _handleAuthStateChanges,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildSignupForm(context, state);
            },
          ),
        ),
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
    if (state is AuthSuccess) {}

    if (state is UserTempOtpSent) {
      Navigator.pushNamed(context, '/passenger_signup_otp',
          arguments: driverFormData.phoneNumber ?? "");
    } else if (state is DriverTempOtpSent) {
      Navigator.pushNamed(context, '/driver_signup_otp_page',
          arguments: driverFormData);
    }
  }

  Widget _buildSignupForm(BuildContext context, AuthState state) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const SizedBox(height: 12),

              const SizedBox(height: 30),

              // === FORM STARTS ===
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    UserTypeSelector(
                      items: _dropdownMenuItems,
                      selectedItem: _selectedItem,
                      onSelected: (value) {
                        setState(() {
                          _selectedItem = value;
                          driverFormData.userType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    PhoneFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(width: 1.0),
                        ),
                      ),
                      validator: PhoneValidator.compose([
                        PhoneValidator.required(context,
                            errorText: 'Phone Number is required'),
                        PhoneValidator.validMobile(context,
                            errorText: 'Phone Number is invalid')
                      ]),
                      countrySelectorNavigator:
                          CountrySelectorNavigator.bottomSheet(
                        searchBoxDecoration: InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(width: 1.0),
                          ),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onChanged: (phone) {
                        driverFormData.phoneNumber =
                            "+${phone.countryCode}${phone.nsn}";
                      },
                      enabled: true,
                      isCountrySelectionEnabled: true,
                      isCountryButtonPersistent: true,
                      countryButtonStyle: const CountryButtonStyle(
                        showDialCode: true,
                        showFlag: true,
                        flagSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleSignUp(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Proceed',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25,
                            child: IconButton(
                              onPressed: () => _signInWithGoogle(context),
                              icon: const FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Apple Sign-In Button
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25,
                            child: IconButton(
                              onPressed: () => _signInWithApple(context),
                              icon: const FaIcon(
                                FontAwesomeIcons.apple,
                                color: Colors
                                    .black, // Apple logo is typically black
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25,
                            child: IconButton(
                              onPressed: () async {
                                Position position = await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmailSignupPage(
                                      latitude: position.latitude.toString(),
                                      longitude: position.longitude.toString(),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.email_outlined,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignUp(BuildContext context) {
    if (_selectedItem == 'Passenger') {
      _handlePassengerSignUp(context);
    } else {
      _handleDriverSignUp(context);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        clientId: '54199172130-oeh18658op3b94bu7g62o4607vt5m599.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("Google Sign-In was cancelled by the user.");
        return;
      }

      print("🔵 Google User Info:");
      print("Display Name:  {googleUser.displayName}");
      print("Email:  {googleUser.email}");
      print("ID:  {googleUser.id}");
      print("Photo URL:  {googleUser.photoUrl}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("🟣 Google Auth Tokens:");
      print("Access Token:  {googleAuth.accessToken}");
      print("ID Token:  {googleAuth.idToken}");

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null && googleAuth.idToken != null) {
        if (_selectedItem == 'Passenger') {
          _handlePassengerSignUp(context, idToken: googleAuth.idToken!);
        } else if (_selectedItem == 'Driver') {
          _handleDriverSignUp(context, name: googleUser.displayName, email: googleUser.email);
        }
      } else {
        print("❌ Firebase user is null or idToken is null.");
      }
    } catch (e, stackTrace) {
      print("Google sign-in error: $e");
      print("Stack Trace: $stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    }
  }

  void _handlePassengerSignUp(BuildContext context, {String? idToken}) {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = driverFormData.phoneNumber ?? "";
      if (idToken != null) {
        // Google sign-in flow
        Position position = driverFormData.currentLocation ?? Position(
          latitude: 0,
          longitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        final requestBody = {
          'idToken': idToken,
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        };
        log('🚀 Passenger creation request body: $requestBody');
        context.read<AuthBloc>().add(SignInWithGoogleEvent(
          idToken: idToken,
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
        ));
      } else {
        // Email sign-up flow
        context
            .read<AuthBloc>()
            .add(SendUserTempOtpEvent(otp: {'phone': phoneNumber}));
      }
    } else {
      context.read<AuthBloc>().add(
          const InvalidFormEvent(message: "Please fill a valid phone number"));
    }
  }

  void _handleDriverSignUp(BuildContext context, {String? name, String? email}) {
    if (_formKey.currentState!.validate()) {
      if (name != null) {
        // Google sign-in flow
        final driverFormData = DriverFormData();
        if (name != null) driverFormData.nameController.text = name;
        if (email != null) driverFormData.emailController.text = email;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverSignupAdditionalInfoPage(
              driverFormData: driverFormData,
            ),
          ),
        );
      } else {
        // Email sign-up flow
        final phoneNumber = driverFormData.phoneNumber ?? "";
        context
            .read<AuthBloc>()
            .add(SendDriverTempOtpEvent(otp: {'phone': phoneNumber}));
      }
    } else {
      context.read<AuthBloc>().add(
          const InvalidFormEvent(message: "Please fill a valid phone number"));
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final appleProvider = AppleAuthProvider();
      // Request full name and email from Apple
      appleProvider.addScope('email');
      appleProvider.addScope('fullName');

      final userCredential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);
      final user = userCredential.user;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Signed in with Apple as ${user?.displayName ?? user?.email}')),
      );

      // Optionally, save userType to Firestore if needed
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Apple sign-in failed.";
      if (e.code == 'canceled') {
        errorMessage = 'Apple sign-in cancelled by user.';
      } else if (e.code == 'firebase_auth_internal_error') {
        errorMessage =
            'Apple sign-in is not configured for this app in Firebase console.';
      } else {
        errorMessage = 'Apple sign-in failed: ${e.message}';
      }
      print("Apple sign-in error: ${e.code} - ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      print("Apple sign-in error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Apple sign-in failed: $e')),
      );
    }
  }
}
