import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _phoneNumber;
  bool _isLoading = true;
  bool _isPhoneEditable = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _phoneNumber = prefs.getString('phoneNumber');

      if (_phoneNumber != null && _phoneNumber!.isNotEmpty) {
        _phoneController.text = _phoneNumber!;
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_phoneNumber)
            .get();

        if (userDoc.exists) {
          setState(() {
            _nameController.text = userDoc.data()?['name'] ?? '';
            _emailController.text = userDoc.data()?['email'] ?? '';
            _addressController.text = userDoc.data()?['address'] ?? '';
            _isPhoneEditable = false;
          });
        }
      } else {
        setState(() {
          _isPhoneEditable = true;
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        _isLoading = false;
        _isPhoneEditable = true;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // If phone number was empty or editable, save the new one
      if (_isPhoneEditable) {
        _phoneNumber = _phoneController.text;
        // Save to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('phoneNumber', _phoneNumber!);
      }

      // Create or update user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_phoneNumber)
          .set({
        'phoneNumber': _phoneNumber,
        'name': _nameController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': _isPhoneEditable ? FieldValue.serverTimestamp() : null,
      }, SetOptions(merge: true));

      setState(() {
        _isPhoneEditable = false;
      });

      Fluttertoast.showToast(
        msg: "Profile updated successfully",
        backgroundColor: Colors.green,
      );
    } catch (e) {
      print('Error saving profile: $e');
      Fluttertoast.showToast(
        msg: "Error updating profile",
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFFF2C51D),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFF2C51D),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                enabled: _isPhoneEditable,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text(_isPhoneEditable ? 'Create Profile' : 'Update Profile'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFF2C51D),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}