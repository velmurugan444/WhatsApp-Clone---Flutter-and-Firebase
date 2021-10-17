import 'dart:io';

import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../constants.dart';
import 'login.dart';
import 'models/authentication.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _nameController,
      _mailController,
      _passwordController,
      _addressController,
      _mobileController,
      _descriptionController;
  String email, password;
  DatabaseReference _ref;
  File sampleImage;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mailController = TextEditingController();
    _passwordController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _mobileController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child("Registration");
  }

  void _showSuccessfulMessage(String inputmessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('From Whatsapp:'),
        content: Text(inputmessage),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new LoginPage()));
            },
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String msg) {
    print(msg);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
        content: Text(msg),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  Map<String, dynamic> _authData = {'email': '', 'password': ''};
  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    try {
      await Provider.of<Authentication>(context, listen: false)
          .signUp(_authData['email'], _authData['password']);
      final postImageRef =
          FirebaseStorage.instance.ref().child("Profile Images");

      var timeKey = DateTime.now();

      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      String url = imageUrl.toString();
      print("Image Url =" + url);
      String name = _nameController.text;
      String email = _mailController.text;
      String password = _passwordController.text;
      String profile = url;
      String description = _descriptionController.text;
      String address = _addressController.text;
      String mobile = _mobileController.text;
      Map<String, String> registration = {
        "username": name,
        "email": email,
        "password": password,
        "profile": profile,
        "description": description,
        "address": address,
        "mobile": mobile,
        "status": "inactive",
      };
      String message = "Your Registration was Successful.";
      _ref
          .push()
          .set(registration)
          .then((value) => _showSuccessfulMessage(message));
    } catch (error) {
      var errorMessage = "Account already exists";
      _showErrorDialog(errorMessage);
    }
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 70),
          child: Text(
            'Whatsapp Clone',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildNameRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.verified_user,
              color: mainColor,
            ),
            labelText: 'name'),
        validator: (value) {
          if (value.length == 0) {
            return "Enter name";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _mailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: mainColor,
            ),
            labelText: 'E-mail'),
        validator: (value) {
          if (value.length == 0) {
            return "Enter email";
          } else {
            return null;
          }
        },
        onSaved: (value) {
          _authData['email'] = value;
        },
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: mainColor,
          ),
          labelText: 'Password',
        ),
        validator: (value) {
          if (value.length == 0) {
            return "Enter password";
          } else {
            return null;
          }
        },
        onSaved: (value) {
          _authData['password'] = value;
        },
      ),
    );
  }

  Widget _buildprofileRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.streetAddress,
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: GestureDetector(
            onTap: () {
              getImage();
            },
            child: Icon(
              Icons.image,
              color: mainColor,
            ),
          ),
          labelText: 'Pick profile',
        ),
      ),
    );
  }

  Widget _buildAboutRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _descriptionController,
        keyboardType: TextInputType.streetAddress,
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.details,
            color: mainColor,
          ),
          labelText: 'description',
        ),
        validator: (value) {
          if (value.length == 0) {
            return "Enter description";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _buildaddressRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _addressController,
        keyboardType: TextInputType.streetAddress,
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.details,
            color: mainColor,
          ),
          labelText: 'address',
        ),
        validator: (value) {
          if (value.length == 0) {
            return "Enter address";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _buildmobileRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: _mobileController,
        keyboardType: TextInputType.number,
        obscureText: false,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.contact_page,
            color: mainColor,
          ),
          labelText: 'mobile',
        ),
        validator: (value) {
          if (value.length == 0) {
            return "Enter address";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20),
          // ignore: deprecated_member_use
          child: RaisedButton(
            elevation: 5.0,
            color: mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              _submit();
            },
            child: Text(
              "Signup",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Signup",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 30,
                          ),
                        ),
                      ],
                    ),
                    _buildNameRow(),
                    _buildEmailRow(),
                    _buildPasswordRow(),
                    _buildprofileRow(),
                    _buildAboutRow(),
                    _buildaddressRow(),
                    _buildmobileRow(),
                    _buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(70),
                    bottomRight: const Radius.circular(70),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLogo(),
                _buildContainer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
