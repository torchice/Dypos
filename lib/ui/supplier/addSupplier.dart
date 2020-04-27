import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPage extends StatefulWidget {

  @override
  _AddPageState createState() => _AddPageState();
}
class FormKeys {
  static final supplierKey = const Key('supplierKey');
}

class _AddPageState extends State<AddPage>{

  String idUser;
  String _nama,_alamat,_phone;
  
  TextEditingController supplierNameController = new TextEditingController();
  TextEditingController supplierAddressController = new TextEditingController();
  TextEditingController supplierPhoneController = new TextEditingController();

  final GlobalKey<FormState> _formKeyAddSupplier = new GlobalKey<FormState>();
  
  _loadUid() async {             
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = (prefs.getString ('uid')??'');
    });
  }

  @override
  void initState(){
    super.initState();
    _loadUid();
  }
  
  Future<void> insertSupplier() async{
      try{
        _nama=supplierNameController.text;
        _alamat=supplierAddressController.text;
        _phone=supplierPhoneController.text;  
        print("testId");
        print(idUser);

        Firestore.instance.collection('owner').document(idUser).collection('supplier').add({
          'supplier_name': '$_nama ',
          'supplier_address': '$_alamat',
          'supplier_phone': '$_phone',
        });

        supplierAddressController.clear();
        supplierNameController.clear();
        supplierPhoneController.clear();
        _showDialog();
        
      }catch(e){
        print(e.toString());
      }
    }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Value Sucesfully Added"),
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

  Widget body(BuildContext context){
    //  Size screenSize = MediaQuery.of(context).size;
          return new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  child: new Column(
                    children:<Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 0.0, 64.0, 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.person, color: Colors.red),
                            labelText: "Supplier Name",
                          )
                          ,controller:supplierNameController,
                          // focusNode: supplierNameFocus,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 0.0, 64.0, 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.home, color: Colors.red),
                            labelText: "Supplier Address",
                          )
                          ,controller:supplierAddressController,
                          // focusNode: supplierAddressFocus,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 0.0, 64.0, 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.add_call, color: Colors.red),
                            labelText: "Supplier Phone",
                          )
                          ,controller:supplierPhoneController,
                          // focusNode: supplierPhoneFocus,
                          keyboardType:TextInputType.phone,
                        ),
                      ),
                          ],
                        )
                      ),
                      new MaterialButton(
                        child: new Text("Add Supplier", style: new TextStyle(color: Colors.white),),
                        color: Colors.lightBlue,
                        onPressed: (){
                          insertSupplier();
                        }
                      )
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: body(context),
      key:_formKeyAddSupplier
    );
  }
}