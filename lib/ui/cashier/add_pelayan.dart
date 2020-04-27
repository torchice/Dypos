import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class FormKeys {
  static final supplierKey = const Key('supplierKey');
}

class _AddPageState extends State<AddPage> {
  String idUser;
  String _nama, _emailPelayan, _password, _confirmPassword;

  TextEditingController pelayanNameController = new TextEditingController();
  TextEditingController pelayanIdController = new TextEditingController();
  TextEditingController pelayanPasswordController = new TextEditingController();
  TextEditingController pelayanCPasswordController = new TextEditingController();

  final GlobalKey<FormState> _formKeyAddSupplier = new GlobalKey<FormState>();

  _loadUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = (prefs.getString('uid') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUid();
  }

  Future<void> insertPelayan() async {
    try {
      _nama = pelayanNameController.text;
      _emailPelayan = pelayanIdController.text;
      _password = pelayanPasswordController.text;
      _confirmPassword = pelayanCPasswordController.text;

      if (_password != _confirmPassword) {
        _showError();
      } else {
          
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailPelayan, password: _password);
      
      final docRef = await Firestore.instance
          .collection('owner')
          .document(idUser)
          .collection('user')
          .add({
        'email': '$_emailPelayan ',
        'password': '$_password',
        'role': 'cashier',
      });
      
      final uid=docRef.documentID.toString();

      Firestore.instance
          .collection('owner')
          .document(idUser)
          .collection('cashier')
          .add({
        'casher_uid': '$uid',
        'cashier_name': '$_nama ',
        'cashier_email': '$_emailPelayan',
        'cashier_password': '$_password',
      });

        Firestore.instance.collection('databaseLogin').add({
            'uid': idUser,
            'role': 'cashier',
            'email': '$_emailPelayan',
            'password': '$_password'
        });

      pelayanNameController.clear();
      pelayanIdController.clear();
      pelayanPasswordController.clear();
      pelayanCPasswordController.clear(

      );
      _showDialog();

      }

      print("testId");
      print(idUser);
    
    } catch (e) {
      print(e.toString());
    }
  }

  void _showError() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Password & Confirm Doesnt Match"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Account Sucesfully Added"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget body(BuildContext context) {
     Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      body: new SingleChildScrollView(
        child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
              child: new Column(
            children: <Widget>[
                 SizedBox(
                        height: screenSize.height/10,
                      ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 64.0, 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.person, color: Colors.red),
                    labelText: "Cashier Name",
                  ),
                  controller: pelayanNameController,
                  // focusNode: supplierNameFocus,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 64.0, 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.mail, color: Colors.red),
                    labelText: "Cashier Email",
                  ),
                  controller: pelayanIdController,
                  // focusNode: supplierNameFocus,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 64.0, 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock, color: Colors.red),
                    labelText: "Password",
                  ),
                  controller: pelayanPasswordController,
                  obscureText: true,
                  // focusNode: supplierAddressFocus,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 64.0, 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock_open, color: Colors.red),
                    labelText: "Confirm Password",
                  ),
                  controller: pelayanCPasswordController,
                  obscureText: true,
                  // focusNode: supplierPhoneFocus,
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          )),
          new MaterialButton(
              child: new Text(
                "Add Pelayan",
                style: new TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlue,
              onPressed: () {
                insertPelayan();
              })
        ],
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: body(context), key: _formKeyAddSupplier);
  }
}
