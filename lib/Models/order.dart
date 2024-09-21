
import 'package:flutter/material.dart';

class Order {

String products;
  String total;
  String userName;
 String address;
 String discount;

  Order({
    required this.total,
    required this.products,
    required this.address,
    required this.userName,
    required this.discount
  });


}