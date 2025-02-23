import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteProductButton extends StatelessWidget {
  final String collectionPath;
  final String documentId;
  final String productName;
  final Function? onDeleteSuccess;
  final Color buttonColor;
  final bool isIconButton;

  const DeleteProductButton({
    Key? key,
    required this.collectionPath,
    required this.documentId,
    required this.productName,
    this.onDeleteSuccess,
    this.buttonColor = Colors.red,
    this.isIconButton = true,
  }) : super(key: key);

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl, // Set RTL for Arabic
          child: AlertDialog(
            title: Text('تأكيد الحذف'),
            content: Text('هل أنت متأكد أنك تريد حذف "$productName"؟'),
            actions: <Widget>[
              TextButton(
                child: Text('إلغاء'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text('حذف'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await _deleteProduct(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteProduct(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(documentId)
          .delete();

      Fluttertoast.showToast(
        msg: "تم الحذف بنجاح",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      if (onDeleteSuccess != null) {
        onDeleteSuccess!();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "فشل الحذف: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isIconButton) {
      return IconButton(
        icon: Icon(Icons.delete_forever, color: buttonColor),
        onPressed: () => _showDeleteConfirmation(context),
        tooltip: 'حذف المنتج',
      );
    } else {
      return ElevatedButton.icon(
        icon: Icon(Icons.delete_outline),
        label: Text('حذف'),
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
        ),
        onPressed: () => _showDeleteConfirmation(context),
      );
    }
  }
}