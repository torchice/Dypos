import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:ta_andypos/style/theme.dart' as Theme;
import 'package:ta_andypos/components/TextFields/inputField.dart';
// import 'package:ta_andypos/theme/style.dart';
// import '../home.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../drawerBar.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// import 'master_item.dart';

// import 'package:image/image.dart';

void main() => runApp(AddStokPage());

class TambahStok extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add New Item',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes:  <String, WidgetBuilder>{
      },
      home: AddStokPage(),
    );
  }
}

File image;
String filename;

class RIKeys {
  static final riKey1 = const Key('rikey1');
  static final keyAddStok = const Key('keyAddStok');
  static final riKey3 = const Key('rikey3');
}

class AddStokPage extends StatefulWidget {
  // final FirebaseUser emailReg;

  final String email,passwordValue;
  final TabController controller;

  AddStokPage({Key key, this.email, this.passwordValue,this.controller}) : super(key: key);

  @override
  _AddStokPageState createState() => _AddStokPageState();

}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/img/login_logo.png'),
  fit: BoxFit.cover,
);

TextStyle headingStyle = new TextStyle(
  color: Colors.white,
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

class _AddStokPageState extends State<AddStokPage>
{
  int _qty;
  int _qtyOld;
  int _qtyNew;
  String role;
  //category,supplier,item variable untuk onChanged dropDown
  var _category,_nameSupplier,_nameItem;
  String dropdownValue;
  String idItem,idSupplier,idKategori;
  String pricepcs;
  final db = Firestore.instance;
  // String _uid;
  String id;
  String idUser;
  String _email;

  bool autoValidate=false;
  bool emailExist=false;
  
  @override
  void initState(){
    super.initState();
    _loadUid();
  }
   _loadUid() async {             
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = (prefs.getString ('uid')??'');
      _email = (prefs.getString ('email')??'');
      role = (prefs.getString ('role')??'');
      if(idUser==null){
         CircularProgressIndicator();
      }
      print("Load IdUSer");
      print(idUser);
      print(_email);
    });
  }

  TextEditingController itemNameController = new TextEditingController();
  TextEditingController categoryController = new TextEditingController(); 
  // MoneyMaskedTextController supplierPriceController = new MoneyMaskedTextController(leftSymbol: 'Rp', thousandSeparator: '.');
  // MoneyMaskedTextController sellingPriceController = new MoneyMaskedTextController(leftSymbol: 'Rp', thousandSeparator: '.');
  TextEditingController qtyController = new TextEditingController();
  TextEditingController supplierPriceController = new TextEditingController();
  TextEditingController sellingPriceController = new TextEditingController();

  final FocusNode myFocusNodeStoreName = FocusNode();
  final FocusNode myFocusNodeCategory = FocusNode();
  final FocusNode myFocusNodeOwner = FocusNode();
  final FocusNode myFocusNodeAddress = FocusNode();
  final FocusNode myFocusNodePhone = FocusNode();
  
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    //print(context.widget.toString());
    return new Scaffold(
        key: RIKeys.keyAddStok,
        drawer: buildDrawer(context,idUser,_email,role),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _scanStok(),
        //   tooltip: "Scan",
        //   child: Icon(Icons.settings_overscan),
        // ),
        body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.all(15.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  new SizedBox(
                    height: 50.0 ,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "Add New Stock",
                          textAlign: TextAlign.center,
                          // style: headingStyle,
                        )
                      ],
                    )),
                new SizedBox(
                  height: screenSize.height,
                  child: new Column(
                    children: <Widget>[
                      new Form(
                        //onWillPop: _warnUserAboutInvalidData,
                          child: new Column(
                            children: <Widget>[
                              //DROPDOWN UNTUK CATEGORY NAME
                              Row(
                                children: <Widget>[
                                  Icon(
                                      Icons.category,
                                      size: 22.0,
                                        color: Colors.black
                                  ),
                                  SizedBox(width:20.0),
                                  Expanded(
                                    // kalau streambuilder hasilnya null awalnya maka error 18/7/19
                                    child: StreamBuilder<QuerySnapshot>(
                                    stream: db.collection("owner").document(idUser).collection('category').where('status_aktif', isEqualTo: true).snapshots(),
                                    builder: (context, snapshot) {
                                      
                                      if(snapshot.data == null) return CircularProgressIndicator();
                                    if (!snapshot.hasData && snapshot.data.documents.length>0)
                                     return const Text("Loading.....");
                                    else {
                                      List<DropdownMenuItem> itemKategori = [];
                                      if(snapshot.data.documents.length>0){
                                        for (int i = 0; i < snapshot.data.documents.length; i++) {
                                        DocumentSnapshot snap = snapshot.data.documents[i];
                                        itemKategori.add(
                                        DropdownMenuItem(
                                          child: Text(
                                            snap.data['value'],
                                            style: TextStyle(color: Colors.grey[800]),
                                          ),
                                            value: "${snap.data['value']}",
                                          ),
                                          );
                                        }
                                      }else{
                                        itemKategori.add(
                                          DropdownMenuItem(
                                          child: Text(
                                            '',
                                            style: TextStyle(color: Colors.grey[800]),
                                          ),

                                          ),
                                        );
                                      }
                                        return Container(
                                          key:RIKeys.keyAddStok,
                                          width: 300.0,
                                          child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                items: itemKategori,
                                                value:  _category,
                                                hint: new Text(
                                                    "Category",
                                                  style: TextStyle(color:Colors.grey[800]),
                                                ),
                                                onChanged: (currencyValue) {
                                                  //  final snackBar = SnackBar(
                                                  //    content: Text(
                                                  //     'Selected Currency value is $currencyValue',
                                                  //     style: TextStyle(color: Color(0xff11b719)),
                                                  //    ),
                                                  // );
                                                  // Scaffold.of(context).showSnackBar(snackBar);
                                                    setState(() {
                                                    _category=currencyValue;
                                                    idKategori = currencyValue;
                                                  });
                                                // _confirmDialog(currencyValue);    
                                                 },
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                ),
                                        
                                            ),
                                          )
                                      );
                                      }
                                    },
                                    ),
                                  )
                                ],
                              ),
                              //DROPDOWN UNTUK ITEM NAME
                              Row(
                                children: <Widget>[
                                  Icon(
                                      Icons.text_fields,
                                      size: 22.0,
                                        color: Colors.black
                                  ),
                                  SizedBox(width:20.0),
                                  Expanded(
                                    // kalau streambuilder hasilnya null awalnya maka error 18/7/19
                                    // solved 24/7/2019
                                    child: StreamBuilder<QuerySnapshot>(
                                    stream: db.collection("owner").document(idUser).collection('item').where('item_category', isEqualTo: idKategori).snapshots(),
                                    builder: (context, snapshot) {
                                    if(snapshot.data == null) return CircularProgressIndicator();
                                    if (!snapshot.hasData && snapshot.data.documents.length>0)
                                      return const Text("Loading.....");
                                    else {
                                      List<DropdownMenuItem> itemName = [];
                                      if(snapshot.data.documents.length>0){
                                        for (int i = 0; i < snapshot.data.documents.length; i++) {
                                        // idItem = snapshot.data.documents[i].documentID;
                                        DocumentSnapshot snap = snapshot.data.documents[i];
                                        itemName.add(
                                        DropdownMenuItem(
                                          child: Text(
                                            snap.data['item_name'],
                                            style: TextStyle(color: Colors.grey[800]),
                                           ),
                                          value: "${snap.documentID}",
                                           ),
                                          );
                                        }
                                      }
                                      else{
                                        itemName.add(
                                          DropdownMenuItem(
                                          child: Text(
                                            '',
                                            style: TextStyle(color: Colors.grey[800]),
                                          ),
                                          ),
                                        );
                                      }
                                      return Container(
                                          key:RIKeys.keyAddStok,
                                          width: 300.0,
                                          child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                items: itemName,
                                                value:  _nameItem,
                                                hint: new Text(
                                                    "Item Name",
                                                  style: TextStyle(color:Colors.grey[800]),
                                                ),
                                                 onChanged: (docItem) {
                                                   checkStock(docItem);
                                                  //  final snackBar = SnackBar(
                                                  //    content: Text(
                                                  //     'Selected Currency value is $currencyValue',
                                                  //     style: TextStyle(color: Color(0xff11b719)),
                                                  //    ),
                                                  // );
                                                  // Scaffold.of(context).showSnackBar(snackBar);
                                                    setState(() {
                                                     _nameItem=docItem;
                                                     idItem = docItem;
                                                  });
                                                  print(docItem);
                                                // _confirmDialog(currencyValue);    
                                                 },
                                                // onChanged:(currencyValue) {
                                                //   checkStock(currencyValue);
                                                //   // final snackBar = SnackBar(
                                                //   // content: Text(
                                                //   //   'Selected Currency value is $currencyValue',
                                                //   //    style: TextStyle(color: Color(0xff11b719)),
                                                //   //  ),
                                                //   // );
                                                //   // Scaffold.of(context).showSnackBar(snackBar);
                                                //     setState(() {

                                                //      _nameItem = currencyValue;
                                                //      print(_nameItem);
                                                    
                                                //     });
                                                //   },
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                ),
                                        
                                            ),
                                          )
                                      );
                                      }
                                    },
                                    ),
                                  )
                                ],
                              ),
                        
                              //DROPDOWN UNTUK SUPPLIER NAME
                              Row(
                                children: <Widget>[
                                  Icon(
                                      Icons.perm_contact_calendar,
                                      size: 22.0,
                                        color: Colors.black
                                  ),
                                  SizedBox(width:20.0),
                                  Expanded(
                                    // kalau streambuilder hasilnya null awalnya maka error 18/7/19
                                    child: StreamBuilder<QuerySnapshot>(
                                    stream: db.collection("owner").document(idUser).collection('supplier').snapshots(),
                                    builder: (context, snapshot) {
                                    
                                    if(snapshot.data == null) return CircularProgressIndicator();
                                    if (!snapshot.hasData && snapshot.data.documents.length>0)
                                     return  const Text("Loading.....");
                                    else {
                                      List<DropdownMenuItem> supplierName = [];
                                      if(snapshot.data.documents.length>0){
                                        for (int i = 0; i < snapshot.data.documents.length; i++) {
                                        DocumentSnapshot snap = snapshot.data.documents[i];
                                        supplierName.add(
                                        DropdownMenuItem(
                                          child: Text(
                                            snap.data['supplier_name'],
                                            style: TextStyle(color: Colors.grey[800]),
                                          ),
                                          value: "${snap.documentID}",
                                          ),
                                          );
                                        }
                                      }else{
                                        supplierName.add(
                                          DropdownMenuItem(
                                          child: Text(
                                            '',
                                            style: TextStyle(color: Colors.grey[800]),
                                          ),

                                          ),
                                        );
                                      }
                                        return Container(
                                          key:RIKeys.keyAddStok,
                                          width: 300.0,
                                          child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                items: supplierName,
                                                value:  _nameSupplier,
                                                hint: new Text(
                                                    "Supplier",
                                                  style: TextStyle(color:Colors.grey[800]),
                                                ),
                                                 onChanged: (currencyValue) {
                                                  //  final snackBar = SnackBar(
                                                  //    content: Text(
                                                  //     'Selected Currency value is $currencyValue',
                                                  //     style: TextStyle(color: Color(0xff11b719)),
                                                  //    ),
                                                  // );
                                                  // Scaffold.of(context).showSnackBar(snackBar);
                                                    setState(() {
                                                      _nameSupplier = currencyValue;
                                                       idSupplier = currencyValue;
                                                  });
                                                // _confirmDialog(currencyValue);    
                                                 },
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                ),
                                        
                                            ),
                                          )
                                      );
                                      }
                                    },
                                    ),
                                  )
                                ],
                              ),
                              new InputField(
                                hintText: "Quantity",
                                obscureText: false,
                                textInputType: TextInputType.number,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.cloud,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                controllerFunction: qtyController,
                                
                              ),
                              new InputField(
                                hintText: "Supplier Price",
                                obscureText: false,
                                textInputType: TextInputType.number,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.account_balance,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                controllerFunction: supplierPriceController,
                              ),
                              // Text(
                              //   "$_value"
                              // ),
                               new MaterialButton(
                                child: new Text("Add Stock", style: new TextStyle(color: Colors.white),),
                                color: Colors.lightBlue,
                                onPressed: (){
                                
                                  createData(context,idItem);
                                }
                               ),
               
                              // Text("Value uid pref is $idUser")
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        );
  }
    @override


    checkStock(docId) async{
      DocumentSnapshot snapshot = await db.collection('owner').document(idUser).collection('item').document(docId).get();
      // print(snapshot.data['name']);
      setState(() {
          _qtyOld=snapshot.data['item_qty'];
      });
        print("qtyOld");
        print(_qtyOld.toString());
    }
 
    Future<void> createData(context,idItem) async{
      
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
      int pricepcs = int.tryParse(supplierPriceController.text);
      try{
        _qty = int.tryParse(qtyController.text);
        
        _qtyNew = _qty + _qtyOld;

        db.collection('owner').document(idUser).collection('item').document(idItem).updateData({
          'item_qty' : _qtyNew,
          'item_supplierprice': pricepcs
          });

        db.collection('owner').document(idUser).collection('item').document(idItem).collection('supplier_sender').add({
          'id_item':idItem,
          'supplier_sender' : '$idSupplier',
          'stok_tambah' : _qty,
          'time' : '$formattedTime',
          'harga_beli' : pricepcs,
          'stok_awal': _qty
         }
        );

        // db.collection('report_stok').add({
        //   'id_item': idItem,
        //   'uid': idUser,
        //   'id_headerStok': 
        // });


        // _nameItem="";
        supplierPriceController.clear();
        qtyController.clear();
         _showDialog(context);
        // print(_gambar);
 
        // Navigator.push(
        //   context,  
        //   MaterialPageRoute(builder: (context) => Home(user: _email)) ,
        // );
      }catch(e){
        print(e.toString());
      }
  
    }

  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Stock Sucesfully Added"),
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


}

