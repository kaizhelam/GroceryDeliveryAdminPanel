import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_admin_panel/inner_screens/all_driver.dart';
import 'package:grocery_admin_panel/screens/dashboard_screen.dart';

import '../widgets/buttons.dart';
import '../widgets/side_menu.dart';
import 'package:http/http.dart' as http;

class AddDriver extends StatefulWidget {
  const AddDriver({Key? key}) : super(key: key);

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _numberPlateController = TextEditingController();
  String _selectedVehicle = 'Car';


  bool _isLoading = false;

  int _generateRandomFourDigitNumber() {
    Random random = Random();
    return random.nextInt(9000) +
        1000;
  }

  Future<void> _addDriverToFirestore(BuildContext context) async {
    String vehicleNumberPlate = _numberPlateController.text.trim();
    if (vehicleNumberPlate.length > 8) {
      Fluttertoast.showToast(
        msg: "Vehicle number plate should not exceed 8 digits.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 1,
      );
      return;
    }

    setState(() {
      _isLoading =
          true;
    });

    try {
      final String email = _emailController.text.trim();
      final String name = _nameController.text.trim();
      final String phoneNumber = _phoneNumberController.text.trim();

      if (email.isEmpty || name.isEmpty || phoneNumber.isEmpty) {
        Fluttertoast.showToast(
          msg: "Please fill in all the fields.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors
              .red,
          timeInSecForIosWeb: 1,
        );
        return;
      }

      if(!email.contains("@")){
        Fluttertoast.showToast(
          msg: "Email missing @",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors
              .red,
          timeInSecForIosWeb: 1,
        );
        return;
      }

      if (phoneNumber.contains(RegExp(r'[a-zA-Z]'))) {
        Fluttertoast.showToast(
          msg: "Phone Number can only be digit",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors
              .red,
          timeInSecForIosWeb: 1,
        );
        return;
      }

      if (phoneNumber.length <= 9) {
        Fluttertoast.showToast(
          msg: "Phone Number at lest 10 digit",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors
              .red,
          timeInSecForIosWeb: 1,
        );
        return;
      }

      final int randomCode = _generateRandomFourDigitNumber();

      final QuerySnapshot<Map<String, dynamic>> existingDriversWithCode =
          await FirebaseFirestore.instance
              .collection('drivers')
              .where('code', isEqualTo: randomCode.toString())
              .get();

      if (existingDriversWithCode.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Driver with code $randomCode already exists. Please try again.')),
        );
        return;
      }

      final QuerySnapshot<Map<String, dynamic>> existingDriversWithEmail =
          await FirebaseFirestore.instance
              .collection('drivers')
              .where('email', isEqualTo: email)
              .get();

      if (existingDriversWithEmail.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Driver with email $email already exists. Please try again.')),
        );
        return;
      }

      String driverId = randomCode.toString();

      await FirebaseFirestore.instance.collection('drivers').doc(driverId).set({
        'email': email,
        'name': name,
        'phoneNumber': phoneNumber,
        'driverId': driverId,
        'earnings': [],
        'vehicleType': _selectedVehicle,
        'vehicleNumberPlate': vehicleNumberPlate, // Add the vehicle number plate to Firestore
      });

      Fluttertoast.showToast(
        msg: "Add Driver successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );

      await sendEmail(
          name: name,
          email: email,
          subject: "Welcome aboard, GoGrocery Merchant.",
          message:
              "Below is your driver ID\n\nDriver ID: $driverId\n\nKindly use your driver ID to log in to our application.",
          driverId: driverId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AllDriver()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add driver: $e')),
      );
    } finally {
      setState(() {
        _isLoading =
            false; // Set isLoading to false after adding the driver (success or failure)
      });
    }
  }

  Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
    required String driverId,
  }) async {
    final serviceId = "service_10oqxhr";
    final templateId = "template_3b8onei";
    final userId = "kiQPhUrR7wuNDrnka";

    var endPointUrl = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    var response = await http.post(
      endPointUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
          'driverID': driverId,
        }
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Driver'),
      ),
      drawer: const SideMenu(),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Show loading spinner while adding the driver
            )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Driver Email'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Driver Name'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Driver Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text('Vehicle:', style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedVehicle,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedVehicle = newValue!;
                    });
                  },
                  items: <String>['Car', 'Motorcycle']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          TextField(
            controller: _numberPlateController,
            decoration: InputDecoration(labelText: 'Vehicle Number Plate'),
            keyboardType: TextInputType.text,
            maxLength: 8, // Maximum of 8 characters
            onChanged: (value) {
              // Check if the input contains at least one letter alphabet
              if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                // If not, clear the text field and show an error message
                _numberPlateController.clear();
                Fluttertoast.showToast(
                  msg: "Vehicle number plate must contain at least one letter alphabet.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  timeInSecForIosWeb: 1,
                );
              }
            },
          ),
            SizedBox(height: 10),
            ButtonsWidget(
              onPressed: () => _addDriverToFirestore(context),
              text: 'Add Driver',
              icon: Icons.add,
              backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
