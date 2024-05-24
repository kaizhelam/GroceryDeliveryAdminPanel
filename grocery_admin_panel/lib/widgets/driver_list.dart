import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../consts/constants.dart';
import '../services/utils.dart';
import 'orders_widget.dart';

class DriverList extends StatefulWidget {
  const DriverList({Key? key, this.isInDashboard = true}) : super(key: key);

  final bool isInDashboard;

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  void _deleteDriver(String driverId) async {
    // Show confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this driver?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if confirmed
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false if canceled
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    // If confirmed, delete the driver
    if (confirmDelete == true) {
      await FirebaseFirestore.instance.collection('drivers').doc(driverId).delete();
      Fluttertoast.showToast(
        msg: "Deleted Driver successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    }
  }

  void _editDriver(String driverId, Map<String, dynamic> driverData) async {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _phoneNumberController = TextEditingController();
    TextEditingController _numberPlateController = TextEditingController();

    // Populate the text fields with current data
    _nameController.text = driverData['name'] ?? '';
    _emailController.text = driverData['email'] ?? '';
    _phoneNumberController.text = driverData['phoneNumber'] ?? '';
    _numberPlateController.text = driverData['vehicleNumberPlate'] ?? '';

    String _selectedVehicle = driverData['vehicleType'] ?? 'Car'; // Default to 'Car' if no value is found

    // Show dialog for editing
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Driver Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Driver Email'),
              ),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Driver Phone Number'),
              ),
              Row(
                children: [
                  Text('Vehicle: ', style: TextStyle(fontSize: 16)),
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
                decoration: const InputDecoration(labelText: 'Vehicle Number Plate'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Update data in Firestore
                await FirebaseFirestore.instance.collection('drivers').doc(driverId).update({
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'phoneNumber': _phoneNumberController.text,
                  'vehicleType': _selectedVehicle,
                  'vehicleNumberPlate': _numberPlateController.text,
                });
                Fluttertoast.showToast(
                  msg: "Edit Driver successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                );
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving changes
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          );
        } else if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          if (docs.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.isInDashboard && docs.length > 4 ? 4 : docs.length,
                itemBuilder: (ctx, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final driverId = docs[index].id;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Driver Id: ${data['driverId'] ?? 'N/A'}', style: TextStyle(color: color),),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue,),
                                onPressed: () => _editDriver(driverId, data),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red,),
                                onPressed: () => _deleteDriver(driverId),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('Email: ${data['email'] ?? 'N/A'}', style: TextStyle(color: color),),
                      SizedBox(height: 3,),
                      Text('Name: ${data['name'] ?? 'N/A'}', style: TextStyle(color: color),),
                      SizedBox(height: 3,),
                      Text('Phone Number: ${data['phoneNumber'] ?? 'N/A'}', style: TextStyle(color: color),),
                      SizedBox(height: 3,),
                      Text('Vehicle Type : ${data['vehicleType'] ?? 'N/A'}', style: TextStyle(color: color),),
                      SizedBox(height: 3,),
                      Text('Vehicle Number Plate: ${data['vehicleNumberPlate'] ?? 'N/A'}', style: TextStyle(color: color),),
                      const Divider(
                        thickness: 3,
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('No Driver Data'),
              ),
            );
          }
        } else {
          // If snapshot doesn't have data, it's still loading
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
