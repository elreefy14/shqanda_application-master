//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shqanda_application/Provider/product_provider.dart';
//
// class CheckOutSingleProduct extends StatefulWidget {
//   final String name;
//   final String image;
//   final int index;
//   final String quentity;
//   final String price;
//   CheckOutSingleProduct({
//     required this.index,
//     required this.quentity,
//     required this.image,
//     required this.name,
//     required this.price,
//   });
//   @override
//   _CheckOutSingleProductState createState() => _CheckOutSingleProductState();
// }
//
// TextStyle myStyle = TextStyle(fontSize: 18);
// ProductProvider? productProvider;
//
// class _CheckOutSingleProductState extends State<CheckOutSingleProduct> {
//   double? height, width;
//   Widget _buildImage() {
//     return Container(
//       height: height! * 0.2,
//       width: width! * 0.2,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           fit: BoxFit.fill,
//           image: NetworkImage(widget.image),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNameAndClosePart() {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(child: Text(
//             widget.name,
//             style: myStyle,
//           )),
//           IconButton(
//             icon: Icon(Icons.close),
//             onPressed: () {
//               productProvider?.deleteCheckoutProduct(widget.index);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget _buildColorAndSizePart() {
//   //   return Container(
//   //     width: width! * 0.4,
//   //     child: Row(
//   //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //       children: [
//   //         Text(
//   //           widget.color,
//   //           style: myStyle,
//   //         ),
//   //         Text(
//   //           widget.size,
//   //           style: myStyle,
//   //         )
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   Widget _buildCountOrNot() {
//     return Container(
//       height: 35,
//       width: width! * 0.2 + 20,
//       color: Color(0xfff2f2f2),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text("Quentity"),
//           Padding(
//             padding: const EdgeInsets.only(right: 5),
//             child: Text(
//               widget.quentity.toString(),
//               style: TextStyle(fontSize: 18),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     productProvider = Provider.of<ProductProvider>(context);
//
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     return Container(
//       height: height! * 0.2,
//       width: double.infinity,
//       child: Card(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 _buildImage(),
//                 Container(
//                   height: height ! * 0.1 + 50,
//                   width: width! * 0.7,
//                   child: ListTile(
//                     title: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                    Row(
//                           children: [
//                             Text(
//                               "${widget.price.toStringAsFixed(2)} EGP ",
//                               style: TextStyle(
//                                   color: Color(0xff9b96d6),
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             _buildCountOrNot(),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
