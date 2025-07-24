import 'dart:io';

import 'package:ambition_delivery/domain/entities/user.dart';
import 'package:ambition_delivery/presentation/bloc/auth_bloc.dart';
import 'package:ambition_delivery/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PassengerProfilePage extends StatefulWidget {
  const PassengerProfilePage({super.key});

  @override
  State<PassengerProfilePage> createState() => _PassengerProfilePageState();
}

class _PassengerProfilePageState extends State<PassengerProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final AuthBloc _authBloc;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  User? user;

  File? profilePicture;
  String? profilePictureUrl;

  // To track initial values
  String? initialName;
  String? initialEmail;
  String? initialPhoneNumber;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    BlocProvider.of<ProfileBloc>(context).add(GetProfile());
  }

  // bool _hasProfileChanged() {
  //   return _nameController.text != initialName ||
  //       _emailController.text != initialEmail ||
  //       _phoneNumberController.text != initialPhoneNumber ||
  //       profilePicture != null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            user = state.user;
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is ProfileUpdated) {
          } else if (state is ProfileDeleted) {
          } else if (state is UserDisabledError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("User is disabled"),
              ),
            );
            _authBloc.add(SignOutEvent());
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          } else if (state is UserNotFoundError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("User not found"),
              ),
            );
            _authBloc.add(SignOutEvent());
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileLoaded) {
            // Store initial values
            profilePictureUrl = state.user.profile;
            initialName = state.user.name;
            initialEmail = state.user.email;
            initialPhoneNumber = state.user.phone;

            _nameController.text = initialName ?? '';
            _emailController.text = initialEmail ?? '';
            _phoneNumberController.text = initialPhoneNumber ?? '';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IgnorePointer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            final pickedFile = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                profilePicture = File(pickedFile.path);
                              });
                            }
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: profilePicture != null
                                ? FileImage(profilePicture!)
                                : (profilePictureUrl != null &&
                                        profilePictureUrl!.isNotEmpty)
                                    ? NetworkImage(profilePictureUrl!)
                                    : const AssetImage(
                                        'assets/profile_icon_blank.png',
                                      ) as ImageProvider,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIconColor: Colors.black,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/name_icon.png',
                                color: Colors.black,
                                height: 16,
                              ),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                            hintText: 'Name',
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIconColor: Colors.black,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/email_icon.png',
                                color: Colors.black,
                                height: 16,
                              ),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                            hintText: 'Email',
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneNumberController,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIconColor: Colors.black,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/phone_icon.png',
                                color: Colors.black,
                                height: 16,
                              ),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                            hintText: 'Phone Number',
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Account'),
                  content: const Text(
                      'Are you sure you want to delete your account?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (user == null) {
                          return;
                        }
                        context.read<ProfileBloc>().add(DeleteProfile(
                              id: user!.id,
                            ));
                        BlocProvider.of<AuthBloc>(context).add(SignOutEvent());

                        // Navigate to the login page
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Delete Account',
              style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
