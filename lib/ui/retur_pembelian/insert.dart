import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:ta_andypos/components/TextFields/inputField.dart';
import '../home.dart';

class AddPage extends StatefulWidget {

  _DetailItemPage createState() => _DetailItemPage();
  
  final String docIDSupplier,docIDItem,docIDStok;
  final int qtyMaxStok;

  AddPage({Key key, this.docIDSupplier, this.docIDItem,this.docIDStok,this.qtyMaxStok}) : super(key: key);

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

File image;
String filename;
// class _ShowItemPage extends State<ShowItem>{
class _DetailItemPage extends State<AddPage>{
  
  String idUser;
  bool updateCheck=false;


  int qtyRetur;
  String _email;
  var selectedCurrency;
  int stokAvailable;
  TextEditingController qtyController = new TextEditingController();

  TextEditingController stokNowController = new TextEditingController();

  
  final db=Firestore.instance;

   _loadUid() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        idUser = (prefs.getString('uid')??'');
        _email = (prefs.getString('email')??'');
      });
  }


  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Retur Success"),
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

  void _showDialogError(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Failure"),
          content: new Text("Input lower quantity"),
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

    createData(context,itemQty) async{
      
      int qtyRetur = int.tryParse(qtyController.text);
      int qtymax = this.widget.qtyMaxStok;
      print("qtyRetur");
      print(qtyRetur.toString());
      print("qtymax");
      print(qtymax.toString());
      if(qtyRetur>qtymax){
        _showDialogError(context);
      }else{
        print("benar");
        try{
          //qtyOld adalah quantitiy dari maximum stok yang ditambahkan
          //qty
          int qtynew = qtymax - qtyRetur;
          int stokAkhir = itemQty;
          print(stokAkhir.toString());
          int qtyItemNew = stokAkhir -  qtyRetur;
          print(qtymax.toString());
          print(qtynew.toString());
          print(qtynew.toString());
          // _qty=int.tryParse(qtyController.text);
          // _supplierPrice=int.tryParse(supplierPriceController.text);
          

          //jumlah yang diretur
          db.collection('owner').document(idUser).collection('retur_pembelian').add({
            'id_supplier_sender': this.widget.docIDStok,
            'jumlah_retur': qtyRetur,
            'id_item': this.widget.docIDItem,
            'status_retur' : false
          });

          //jumlah quantity stck item
         db.collection('owner').document(idUser).collection('item').document(this.widget.docIDItem).updateData({
            'item_qty': qtyItemNew
          });

          //jumlah quantity input STOK
           db.collection('owner').document(idUser).collection('item').document(this.widget.docIDItem).collection('supplier_sender').document(this.widget.docIDStok).updateData({
            'stok_tambah': qtynew
          });

          print("2x");
          // print(_gambar);
          _showDialog(context);
          Navigator.push(
            context,  
            MaterialPageRoute(builder: (context) => Home(user: _email)) ,
          );
        }catch(e){
          print(e.toString());
        }
      }
     
  
    }

    void dispose() {
      image = null;
      super.dispose();
    }
  
  @override
  void initState(){
    // controller = new TabController(vsync: this, length: 3);

    updateCheck=false;
    super.initState();
    _loadUid();
  }
  
  @override
  Widget build(BuildContext context) {
    
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
        ],
        title: Text("Insert Retur Pembelian"), 
        backgroundColor: Colors.orangeAccent,
      ),
      body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.all(15.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                    height: 30,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "Insert Retur Pembelian",
                          textAlign: TextAlign.center,
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
                              new InputField(
                             
                                // initialVal: this.widget.itemName,
                                obscureText: false,
                                textInputType: TextInputType.text,
                                enabled: updateCheck,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                hintText: "Stok Retur Max: ${this.widget.qtyMaxStok.toString()}",
                                icon: Icons.storage,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
                              ),
                                     StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("owner").document(idUser).collection('item').where('id_item', isEqualTo: this.widget.docIDItem).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.data == null) return CircularProgressIndicator();
                    if (!snapshot.hasData)
                      return const Text("Loading.....");
                    else {
                      // stokNowController.text = snapshot.data.documents[0].data['item_qty'].toString();
                      stokAvailable = snapshot.data.documents[0].data['item_qty'];
                      return InputField(
                                
                                // initialVal: this.widget.itemName,
                                obscureText: false,
                                textInputType: TextInputType.text,
                                enabled: updateCheck,
                                // initialVal: snapshot.data.documents[0].data['item_qty'].toString(),
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                hintText: "Stock now : ${stokAvailable.toString()}",
                                icon: Icons.account_balance,
                                controllerFunction: stokNowController,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
                              );
                    }
                  }),
                              new InputField(
                                // hintText: "Quantity",
                                obscureText: false,
                                //  enabled: false,
                                hintText:"Input Quantity retur: ",
                                textInputType: TextInputType.number,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.sd_storage,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                controllerFunction: qtyController,
                              ),
                              SizedBox(height: 10.0,),
                             new RaisedButton(
                                  child:
                                    Text('Insert Retur'),
                                  onPressed: () {
                                    // dispose();
                                    // int stok = stokNowController.
                                    // int itemQty = int.tryParse(stokNowController.text);
                                    createData(context,stokAvailable);
                                  },
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

}