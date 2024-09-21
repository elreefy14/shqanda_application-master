import 'package:flutter/material.dart';

class UserModel {
  String userName,
      userEmail,
      agentCode,
      userPhoneNumber,

      userAddress;
  num discount;

  UserModel(
      {required this.userEmail,

        required this.userAddress,
        required this.agentCode,
        required this.userName,
        required this.userPhoneNumber,
        required this.discount
      });
}
