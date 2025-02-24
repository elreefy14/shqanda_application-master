import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> isSignedIn() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Update SharedPreferences to ensure persistence
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', currentUser.uid);
      await prefs.setString('phone', currentUser.email!.split('@')[0]);
      await prefs.setBool('isLoggedIn', true);
      return true;
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }

  static Future<String?> getCurrentUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static String formatPhoneAsEmail(String phone) {
    // Remove any non-digit characters
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return '$cleanPhone@gmail.com';
  }

  static Future<Map<String, dynamic>> signIn(
      String phone, String password) async {
    try {
      String email = formatPhoneAsEmail(phone);
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Store user data in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userCredential.user!.uid);
        await prefs.setString('phone', phone);
        await prefs.setBool('isLoggedIn', true);

        return {
          'success': true,
          'userId': userCredential.user!.uid,
        };
      }
      return {'success': false, 'error': 'Login failed'};
    } on FirebaseAuthException catch (e) {
      print('Sign in error: ${e.message}');
      return {'success': false, 'error': 'رقم الهاتف أو كلمة المرور غير صحيحة'};
    }
  }

  static Future<Map<String, dynamic>> signUp(
      String phone, String password) async {
    try {
      String email = formatPhoneAsEmail(phone);
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Store user data in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
          'userId': userCredential.user!.uid,
          'items': [], // Array to track user's uploaded items
        });

        return {
          'success': true,
          'userId': userCredential.user!.uid,
        };
      }
      return {'success': false, 'error': 'Registration failed'};
    } on FirebaseAuthException catch (e) {
      print('Sign up error: ${e.message}');
      if (e.code == 'email-already-in-use') {
        return {'success': false, 'error': 'Phone number already registered'};
      }
      return {'success': false, 'error': e.message};
    }
  }

  // Add method to upload item
  static Future<Map<String, dynamic>> uploadItem(
      String userId, Map<String, dynamic> itemData) async {
    try {
      // Add the item to items collection
      DocumentReference itemRef = await _firestore.collection('items').add({
        ...itemData,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update user's items array
      await _firestore.collection('users').doc(userId).update({
        'items': FieldValue.arrayUnion([itemRef.id])
      });

      return {
        'success': true,
        'itemId': itemRef.id,
      };
    } catch (e) {
      print('Error uploading item: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Add method to delete item
  static Future<Map<String, dynamic>> deleteItem(
      String userId, String itemId) async {
    try {
      // Get the item
      DocumentSnapshot itemDoc =
          await _firestore.collection('items').doc(itemId).get();

      // Check if item exists and belongs to user
      if (!itemDoc.exists) {
        return {
          'success': false,
          'error': 'Item not found',
        };
      }

      Map<String, dynamic> itemData = itemDoc.data() as Map<String, dynamic>;
      if (itemData['userId'] != userId) {
        return {
          'success': false,
          'error': 'Not authorized to delete this item',
        };
      }

      // Delete the item
      await _firestore.collection('items').doc(itemId).delete();

      // Remove item from user's items array
      await _firestore.collection('users').doc(userId).update({
        'items': FieldValue.arrayRemove([itemId])
      });

      return {
        'success': true,
      };
    } catch (e) {
      print('Error deleting item: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
