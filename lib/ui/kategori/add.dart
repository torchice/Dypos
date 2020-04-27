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
 
    var selectedCurrency, selectedType;
  final db = Firestore.instance;
  // String idUser;
  String role;
  // final GlobalKey<FormState> _formKeyKategori = new GlobalKey<FormState>();
  String _category;
  final TextEditingController _categoryController = new TextEditingController();
  // String _email;

  
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
  
  Future<void> insertCategory() async{
        _category=_categoryController.text;
    try{
        db.collection('owner').document(idUser).collection('category').add({
           'value': '$_category ',
           'status_aktif': true
         });
         _showDialog();
         _categoryController.clear();
    }catch(e){
      print(e.message);
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Form(
                  child: new Column(
                    children:<Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 64.0, 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(    Icons.category, color: Colors.red),
                            labelText: "Category Name",
                          )
                          ,controller:_categoryController,
                          // focusNode: supplierNameFocus,
                        ),
                      ),
        
                          ],
                        )
                      ),
                      new MaterialButton(
                        child: new Text("Add Category", style: new TextStyle(color: Colors.white),),
                        color: Colors.lightBlue,
                        onPressed: (){
                          insertCategory();
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