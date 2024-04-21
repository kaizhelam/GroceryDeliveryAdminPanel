import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../screens/loading_manager.dart';
import '../services/utils.dart';
import '../widgets/text_widget.dart';

class EditOrderScreen extends StatefulWidget {
  const EditOrderScreen({
    super.key,
    required this.username,
    required this.userid,
    required this.price,
    required this.productid,
    required this.imageUrl,
    required this.quantity,
    required this.orderDate,
    required this.userLocation,
    required this.orderStatus,
    required this.orderId,
    required this.phoneNumber,
    required this.title,
    required this.message,
  });

  final String username, userid, productid, imageUrl, userLocation, orderId, phoneNumber, title, message;
  final double price;
  final int quantity, orderStatus;
  final Timestamp orderDate;

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  late String _userName;
  late String _userId;
  late double _price;
  late String _productId;
  late String _imageUrl;
  late Timestamp _orderDate;
  late String _userLocation;
  late String _orderId;
  late String _phoneNumber;
  late int _productSold;
  late String _title;
  late int _quantity;
  late int _orderStatus;
  late String _message;
  final _formKey = GlobalKey<FormState>();
  // late final TextEditingController _titleController, _priceController;

  @override
  void initState() {
    // _priceController = TextEditingController(text: widget.price);
    // _titleController = TextEditingController(text: widget.title);

    _userName = widget.username;
    _userId = widget.userid;
    _price = widget.price;
    _productId = widget.productid;
    _imageUrl = widget.imageUrl;
    _quantity = widget.quantity;
    _orderDate = widget.orderDate;
    _userLocation = widget.userLocation;
    _orderStatus = widget.orderStatus;
    _orderId = widget.orderId;
    _phoneNumber = widget.phoneNumber;
    _title = widget.title;
    _message = widget.message;

    super.initState();
  }

  bool _isLoading = false; // Add this variable to track loading state

  void _acceptOrder() async {
    setState(() {
      _isLoading = true; // Show loading spinner
    });

    // Update data in Firebase
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(_orderId)
          .update({
        'orderStatus': 1,
      });
    } catch (error) {
      print('Error updating document: $error');
    }

    try {
      // Get the current productSold value
      var productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(_productId)
          .get();

      // Get the current value or default to 0 if it doesn't exist
      int currentProductSold = productDoc.exists
          ? (productDoc.data()?['productSold'] ?? 0) as int
          : 0;

      // Add the new quantity to the current value
      int newProductSold = currentProductSold + _quantity;

      // Update the productSold field with the new total
      await FirebaseFirestore.instance
          .collection('products')
          .doc(_productId)
          .update({
        'productSold': newProductSold,
      });
    } catch (error) {
      print('Error updating document: $error');
    }



    Fluttertoast.showToast(
      msg: "Product accepted",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
    );

    setState(() {
      _isLoading = false; // Hide loading spinner
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );

    Timestamp orderTimestamp = widget.orderDate;

    DateTime orderDateTime = orderTimestamp.toDate();

    // Remove 8 hours from the orderDateTime
    orderDateTime = orderDateTime.subtract(Duration(hours: 8));

    // Format the DateTime object into a user-readable string with 12-hour format
    String formattedDateTime =
    DateFormat('yyyy-MM-dd hh:mm:ss a').format(orderDateTime);

    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                SizedBox(height: 10),
                Text(
                  "Order Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: size.width > 650 ? 650 : size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextWidget(
                          text: 'UserName',
                          color: color,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: _userName,
                          color: color,
                          isTitle: false,
                        ),
                        const SizedBox(height: 15),
                        TextWidget(
                          text: 'Phone Number',
                          color: color,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: _phoneNumber,
                          color: color,
                          isTitle: false,
                        ),
                        const SizedBox(height: 15),
                        TextWidget(
                          text: 'Address to be delivery',
                          color: color,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: _userLocation,
                          color: color,
                          isTitle: false,
                        ),
                        const SizedBox(height: 15),
                        TextWidget(
                          text: 'Order Quantity',
                          color: color,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: 'X ${_quantity.toString()}',
                          color: color,
                          isTitle: false,
                        ),
                        const SizedBox(height: 15 ),
                        TextWidget(
                            text: 'Order Date and Time',
                            color: color,
                            isTitle: true
                        ),
                        TextWidget(
                          text: formattedDateTime,
                          color: color,
                          isTitle: false,
                        ),
                        const SizedBox(height: 15 ),
                        TextWidget(
                            text: 'Note for Driver',
                            color: color,
                            isTitle: true
                        ),
                        TextWidget(
                          text: _message,
                          color: color,
                          isTitle: false,
                        ),
                        const SizedBox(height: 15 ),
                        TextWidget(
                          text: 'Total Price',
                          color: color,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: 'RM ${_price.toStringAsFixed(2)}',
                          color: color,
                          isTitle: false,
                        ),
                        const SizedBox(height: 15),
                        Image.network(
                          _imageUrl, // Replace with your image URL
                          width: 150, // Adjust the width to your desired size
                          height: 150, // Adjust the height to your desired size// Adjust the fit property as needed
                        ),
                        const SizedBox(height: 15),
                        TextWidget(
                          text: 'The order is ' + (_orderStatus == 0 ? 'Pending' : 'In Progress'),
                          color: color,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Add onPressed logic for the first button
                              },
                              child: const Text('Reject'),
                            ),
                            ElevatedButton(
                              onPressed: _acceptOrder,
                              child: const Text('Accept'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
