import 'dart:io';

import 'package:ambition_delivery/data/models/driver_form_data.dart';
import 'package:ambition_delivery/presentation/bloc/auth_bloc.dart';
import 'package:ambition_delivery/presentation/widgets/image_upload_section.dart';
import 'package:ambition_delivery/presentation/widgets/profile_picture_picker.dart';
import 'package:ambition_delivery/presentation/widgets/terms_and_conditions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverSignupAdditionalInfoPage extends StatefulWidget {
  const DriverSignupAdditionalInfoPage({
    super.key,
    required this.driverFormData,
    this.userId,
  });
  final DriverFormData driverFormData;
  final String? userId;

  @override
  State<DriverSignupAdditionalInfoPage> createState() =>
      _DriverSignupAdditionalInfoPageState();
}

class _DriverSignupAdditionalInfoPageState
    extends State<DriverSignupAdditionalInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additional Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthSuccess) {
              // Handle success
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            } else if (state is AuthFailure) {
              // Handle failure
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          }, builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AuthLocationLoaded) {
              widget.driverFormData.currentLocation = state.position;
            }
            return Column(
              children: [
                ProfilePicturePicker(
                  profilePicture: widget.driverFormData.profilePicture,
                  onImageSelected: (File image) {
                    setState(() {
                      widget.driverFormData.profilePicture = image;
                    });
                  },
                  // Add asterisk in the label/title if possible in your widget
                ),
                const SizedBox(height: 16),
                // Name field
                Row(
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextFormField(
                  controller: widget.driverFormData.nameController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/name_icon.png',
                        height: 16,
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 1.0),
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

                // Email field
                TextFormField(
                  controller: widget.driverFormData.emailController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/email_icon.png',
                        height: 16,
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 1.0),
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

                // Vehicle details fields
                _buildVehicleDetailsFields(),

                // License check code field
                _buildLicenseCheckCodeField(),

                // Bank account fields
                _buildBankAccountFields(),

                // Document upload sections
                _buildDocumentUploadSections(),

                TermsAndConditions(
                  isChecked: widget.driverFormData.isTermsAndConditionsChecked,
                  onChanged: (value) {
                    setState(() {
                      widget.driverFormData.isTermsAndConditionsChecked = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.driverFormData.isValid() &&
                          widget.driverFormData.isTermsAndConditionsChecked) {
                        context.read<AuthBloc>().add(DriverSignUpEvent(
                            driver: widget.driverFormData.toMap()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Submit',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsFields() {
    return Column(
      children: [
        // Vehicle Year (Mandatory)
        Row(
          children: [
            Text('Vehicle Year', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        TextFormField(
          controller: widget.driverFormData.carYearController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
            hintText: 'Vehicle Year',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your vehicle year';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        // Vehicle Plate Number (Mandatory)
        Row(
          children: [
            Text('Vehicle Plate Number', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        TextFormField(
          controller: widget.driverFormData.carPlateController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.directions_car, color: Colors.grey),
            hintText: 'Vehicle Plate Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your vehicle plate number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        // Vehicle Colour (NOT mandatory)
        Row(
          children: [
            Text('Vehicle Color', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        TextFormField(
          controller: widget.driverFormData.carColorController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.color_lens, color: Colors.grey),
            hintText: 'Vehicle Color',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
          ),
          validator: (value) {
            // Not mandatory
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLicenseCheckCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 16),
            Text('DVLA License Check Code', style: TextStyle(fontWeight: FontWeight.bold)),
            // No asterisk, not mandatory
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.driverFormData.licenseCheckCodeController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.code, color: Colors.grey),
            hintText: 'DVLA License Check Code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
          ),
          validator: (value) {
            // Not mandatory
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildBankAccountFields() {
    return Column(
      children: [
        Row(
          children: [
            Text('Bank Account Name', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        TextFormField(
          controller: widget.driverFormData.accountNameController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_circle, color: Colors.grey),
            hintText: 'Bank Account Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your bank account name';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Bank Account Number', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        TextFormField(
          controller: widget.driverFormData.accountNumberController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_balance, color: Colors.grey),
            hintText: 'Bank Account Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your bank account number';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Bank Account Sort Code', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        TextFormField(
          controller: widget.driverFormData.accountSortCodeController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.security, color: Colors.grey),
            hintText: 'Bank Account Sort Code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 1.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your bank account sort code';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDocumentUploadSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // License documents
        ImageUploadSection(
          title: 'Front Picture of Driving License',
          image: widget.driverFormData.licenseFrontPicture,
          onImageSelected: (File image) {
            setState(() {
              widget.driverFormData.licenseFrontPicture = image;
            });
          },
        ),

        ImageUploadSection(
          title: 'Back Picture of Driving License',
          image: widget.driverFormData.licenseBackPicture,
          onImageSelected: (File image) {
            setState(() {
              widget.driverFormData.licenseBackPicture = image;
            });
          },
        ),

        ImageUploadSection(
          title: 'License Plate Picture',
          image: widget.driverFormData.licensePlatePicture,
          onImageSelected: (File image) {
            setState(() {
              widget.driverFormData.licensePlatePicture = image;
            });
          },
        ),

        // Vehicle pictures
        ImageUploadSection(
          title: 'Vehicle Front Picture',
          image: widget.driverFormData.vehicleFrontPicture,
          onImageSelected: (File image) {
            setState(() {
              widget.driverFormData.vehicleFrontPicture = image;
            });
          },
        ),

        ImageUploadSection(
          title: 'Vehicle Back Picture',
          image: widget.driverFormData.vehicleBackPicture,
          onImageSelected: (File image) {
            setState(() {
              widget.driverFormData.vehicleBackPicture = image;
            });
          },
        ),

        ImageUploadSection(
          title: 'Vehicle Left Picture',
          image: widget.driverFormData.vehicleLeftPicture,
          onImageSelected: (File image) {
            setState(() {
              widget.driverFormData.vehicleLeftPicture = image;
            });
          },
        ),

        ImageUploadSection(
          title: 'Vehicle Right Picture',
          image: widget.driverFormData.vehicleRightPicture,
          onImageSelected: (File image) {
            setState(() {
              widget.driverFormData.vehicleRightPicture = image;
            });
          },
        ),

        // Insurance documents
        ImageUploadSection(
          title: 'Vehicle Insurance Picture',
          image: widget.driverFormData.vehicleInsurancePicture,
          onImageSelected: (File image) {
            setState(() {
              widget.driverFormData.vehicleInsurancePicture = image;
            });
          },
        ),

        ImageUploadSection(
          title: 'Public Liability Insurance Picture',
          image: widget.driverFormData.publicLiabilityInsurancePicture,
          onImageSelected: (File image) {
            setState(() {
              widget.driverFormData.publicLiabilityInsurancePicture = image;
            });
          },
        ),

        // Vehicle category specific documents
        if (widget.driverFormData.selectedVehicleCategory == 'Van')
          ImageUploadSection(
            title: 'Goods in Transit Insurance Picture',
            image: widget.driverFormData.goodsInTransitInsurancePicture,
            onImageSelected: (File image) {
              setState(() {
                widget.driverFormData.goodsInTransitInsurancePicture = image;
              });
            },
          ),

        if (widget.driverFormData.selectedVehicleCategory == 'Car')
          ImageUploadSection(
            title: 'PCO License Picture',
            image: widget.driverFormData.pcoLicensePicture,
            onImageSelected: (File image) {
              setState(() {
                widget.driverFormData.pcoLicensePicture = image;
              });
            },
          ),

        const SizedBox(height: 20),
      ],
    );
  }
}
