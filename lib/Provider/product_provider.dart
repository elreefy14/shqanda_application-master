import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shqanda_application/Models/checkout_product_card.dart';
import 'package:shqanda_application/Models/order.dart';
import 'package:shqanda_application/Models/user_model.dart';

 class ProductProvider with ChangeNotifier{
   //--------------User--------------------------------------------
   List<UserModel> userModelList = [];
   UserModel? userModel;

   Future<void> getUserData() async {
     List<UserModel> newList = [];
     User? currentUser = FirebaseAuth.instance.currentUser;
     QuerySnapshot userSnapShot =
     await FirebaseFirestore.instance.collection("User").get();
     userSnapShot.docs.forEach(
           (element) {
         if (currentUser?.uid == element["UserId"]) {
           userModel = UserModel(
               userAddress: element["UserAddress"],
               // userImage: element["UserImage"],
               userEmail: element["UserEmail"],
               agentCode: element["AgentCode"],
               userName: element["UserName"],
               userPhoneNumber: element["UserNumber"],
               discount: element["Discount"]
           );
           newList.add(userModel!);
         }
         userModelList = newList;
         notifyListeners();
       },
     );
   }
   List<UserModel> get getUserModelList {
     return userModelList;
   }
  //-------------Shipping-------------------------------------------------
    num? cost;
   late String duration;

  Future getShippingCost() async {
    cost = (await FirebaseFirestore.instance
        .collection("ShippingInfo").doc("1").get().then((value) {
      return value.data()?["cost"];
    }));
    notifyListeners();
  }

  Future getShippingDuration() async {
    duration = (await FirebaseFirestore.instance
        .collection("ShippingInfo").doc("1").get().then((value) {
      return value.data()!["duration"];
    }));
    notifyListeners();
  }
   //------------ Checkout ------------------------------------------------
   List<CheckoutProductCardModel> checkOutModelList = [];
    CheckoutProductCardModel? checkOutModel;

   void deleteCheckoutProduct(int index) {
     checkOutModelList.removeAt(index);
     notifyListeners();
   }

   void clearCheckoutProduct() {
     checkOutModelList.clear();
     notifyListeners();
   }

   void getCheckOutData({
     required String id,
     required int quentity,
     required int price,
     required String name,
     required String image,
     required int ordersNo,
     required String shippingDuration
   }) {
     checkOutModel = CheckoutProductCardModel(
         id: id,
         price: price,
         name: name,
         image: image,
         quentity: quentity,
         ordersNo: ordersNo,
         shippingDuration: shippingDuration
     );
     checkOutModelList.add(checkOutModel!);
   }
   List<CheckoutProductCardModel> get

   getCheckOutModelList{
     return List.from(checkOutModelList);
   }
   int get getCheckOutModelListLength {
     return checkOutModelList.length;
   }
   //-------------Order-------------------------------------------------------------
   Future<void> getOrdersData() async {
     List<Order> newList = [];
     QuerySnapshot featureSnapShot = await FirebaseFirestore.instance
         .collection("Order").where(
         "UserId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

     featureSnapShot.docs.forEach(
           (element){
             orderData=Order(
             total:element['TotalPrice'],
             address:element["UserAddress"],
             userName:element["UserName"],
             products:element["Product"],
             discount:element["Discount"].toString()
         );
         newList.add(orderData);
       },
     );
     orders = newList;
     notifyListeners();
   }
    late List<Order> orders;
    late Order orderData;
   List<Order> get getOrdersList {
     return orders;
   }
}

