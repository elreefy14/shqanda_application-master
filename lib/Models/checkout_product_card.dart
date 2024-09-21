import 'package:flutter/material.dart';

class CheckoutProductCardModel {
  final String id;
  final String name;
  final String image;
  final int price;
  final int quentity;
  final int ordersNo;
  final String shippingDuration;
  CheckoutProductCardModel( {
    required this.id,
    required this.price,
    required this.name,
    required this.image,
    required this.quentity,
    required this.ordersNo,
    required this.shippingDuration,
  });
}