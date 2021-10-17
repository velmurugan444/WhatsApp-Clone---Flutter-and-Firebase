import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Loginauthentication with ChangeNotifier {
  String profile,
      username,
      rollno,
      email,
      userpassword,
      description,
      address,
      mobile,
      status,
      secretkey;
  userDetails(String password) async {
    DatabaseReference db;
    db = FirebaseDatabase.instance.reference().child("Registration");
    await db
        .orderByChild("password")
        .equalTo(password)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(values["profile"]);
        print(values["username"]);
        print(values["email"]);
        print(values["password"]);
        print(values["address"]);
        print(values["description"]);
        print(values["mobile"]);
        print(values["status"]);
        print(key);
        secretkey = key;
        profile = values["profile"];
        username = values["username"];
        email = values["email"];
        userpassword = values["password"];
        description = values["description"];
        address = values["address"];
        mobile = values["mobile"];
        status = values["status"];
        secretkey = key;
      });
    });

    notifyListeners();
  }
}
