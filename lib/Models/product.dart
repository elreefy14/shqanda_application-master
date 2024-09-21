import 'package:flutter/material.dart';

class Product {
  final String name;
  final String image;
  final String description;
  final int price;
  final int ordersNo;
  final String amount;
  final String id;
  final int quetity;

  Product({required this.id,required this.image, required this.name, required this.price,required this.quetity,
    required this.ordersNo,required this.description,required this.amount });
}
