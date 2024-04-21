import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/widgets/text_widget.dart';

import '../inner_screens/edit_prod.dart';
import '../inner_screens/edti_order.dart';
import '../services/utils.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget(
      {Key? key,
      required this.price,
      required this.totalPrice,
      required this.productId,
      required this.userId,
      required this.imageUrl,
      required this.userName,
      required this.quantity,
      required this.orderDate,
      required this.orderStatus, required this.shippingAddress, required this.orderId, required this.phoneNumber, required this.title, required this.noteForDriver})
      : super(key: key);

  final double price, totalPrice;
  final String productId, userId, imageUrl, userName, shippingAddress,   orderId, phoneNumber, title, noteForDriver;
  final int quantity, orderStatus;
  final Timestamp orderDate;

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late String orderDateStr;
  @override
  void initState() {
    var postDate = widget.orderDate.toDate();
    orderDateStr = '${postDate.day}/${postDate.month}/${postDate.year}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditOrderScreen(
              username: widget.userName,
              userid: widget.userId,
              productid: widget.productId,
              price: widget.price,
              imageUrl : widget.imageUrl == null
                  ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                  : widget.imageUrl!,
              quantity: widget.quantity,
              orderDate: widget.orderDate,
              userLocation: widget.shippingAddress,
              orderStatus : widget.orderStatus,
              orderId: widget.orderId,
              phoneNumber: widget.phoneNumber,
              title: widget.title,
              message: widget.noteForDriver,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).cardColor.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: size.width < 650 ? 3 : 1,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.fill,
                    // height: screenWidth * 0.15,
                    // width: screenWidth * 0.15,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget(
                        text:
                        widget.title,
                        color: color,
                        textSize: 16,
                        isTitle: true,
                      ),
                      TextWidget(
                        text:
                            '${widget.quantity}x For RM${widget.price.toStringAsFixed(2)}',
                        color: color,
                        textSize: 16,
                        isTitle: false,
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'By ',
                              color: Colors.blue,
                              textSize: 16,
                              isTitle: true,
                            ),
                            TextWidget(
                              text: widget.userName,
                              color: color,
                              textSize: 14,
                              isTitle: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Order Status : ',
                              style: TextStyle(
                                color: color,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: widget.orderStatus == 0
                                  ? 'Pending'
                                  : 'Accepted',
                              style: TextStyle(
                                color: widget.orderStatus == 0
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
