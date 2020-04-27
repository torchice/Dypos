import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:ta_andypos/components/TextFields/inputField.dart';

class DetailSupplier extends StatefulWidget {

  _DetailSupplierPage createState() => _DetailSupplierPage();
  final String idItem;

  final String nama,alamat,phone;

  DetailSupplier({
    Key key, 
    this.nama,this.alamat,this.phone,this.idItem}) : super(key: key);

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

File image;
String filename;
// class _ShowItemPage extends State<ShowItem>{
class _DetailSupplierPage extends State<DetailSupplier>{
  
  String idUser;
  // String _category;
  bool updateCheck=false;
  String _nama,_alamat,_phone;
  final db = Firestore.instance;
  TextEditingController supplierNameController = new TextEditingController();
  TextEditingController supplierAddressController = new TextEditingController();
  TextEditingController supplierPhoneController = new TextEditingController();

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

  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Supplier Sucesfully Updated"),
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
    void dispose() {
      super.dispose();
    }


    void updateData() async{
      // print('update');
      // print(idUser);
      // print(this.widget.idItem);
      _nama=supplierNameController.text;
      _alamat=supplierAddressController.text;
      _phone=supplierPhoneController.text;  

        db.collection('owner').document(idUser).collection('supplier').document(this.widget.idItem).updateData({
          'supplier_name': '$_nama ',
          'supplier_address': '$_alamat',
          'supplier_phone': '$_phone',
        });
      
      _showDialog(context);

    }

 Widget uploadArea(){
      // Image image = decodeImage(new Io.File(image).readAsBytesSync());
    return Column(
      children: <Widget>[
        Image.file(image, width:300, height: 100,),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
      Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
              backgroundColor: Colors.orangeAccent,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child:
              InkWell(
                child:
                Icon(
                  Icons.update,
                  size:30.0,
                ),
                onTap: (){
                  setState(() {
                    if(updateCheck==false){
                      updateCheck=true;
                    }else{
                      updateCheck=false;
                    }
                  });
                },
              ),
          
          ),
       
        ],
        title: Text("Detail Supplier"),
        
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
                          "Detail Supplier",
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
                                controllerFunction: supplierNameController,
                                // initialVal: this.widget.itemName,
                                hintText: "Supplier Name: ${this.widget.nama}",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                enabled: updateCheck,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.people,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
                              ),
                              // Row(
                              //   children: <Widget>[
                              //      Icon(
                              //         Icons.perm_contact_calendar,
                              //         size: 20.0,
                              //           color: Colors.black
                              //     ),
                              //     SizedBox(width: 30,),
                              //     Expanded(
                              //       child:   StreamBuilder<QuerySnapshot>(
                              //         stream: Firestore.instance.collection("owner").document(idUser).collection('category').snapshots(),
                              //         builder: (context, snapshot) {
                              //           if(snapshot.data == null) return CircularProgressIndicator();
                              //           if (!snapshot.hasData)
                              //             const Text("Loading.....");
                              //           else {
                                          
                              //             List<DropdownMenuItem> currencyItems = [];
                              //             if(updateCheck==false){
                              //               currencyItems.add(
                              //                 DropdownMenuItem(
                              //                   child: Text(
                              //                     this.widget.category,
                              //                     style: TextStyle(color: Color(0xff11b719)),
                              //                   ),
                              //                   value:this.widget.category
                              //                   // value: "${snap.documentID}",
                              //                 ),
                              //               );
                              //             }else{
                              //               for (int i = 0; i < snapshot.data.documents.length; i++) {
                              //                 DocumentSnapshot snap = snapshot.data.documents[i];
                              //                 currencyItems.add(
                              //                   DropdownMenuItem(
                              //                     child: Text(
                              //                       snap.data['value'],
                              //                       style: TextStyle(color: Color(0xff11b719)),
                              //                     ),
                              //                     value: "${snap.documentID}",
                              //                   ),
                              //                 );
                              //               }
                              //             }
                                          
                              //           return Container(
                              //             width: 300.0,
                              //             child: DropdownButtonHideUnderline(
                              //                 child: DropdownButton(
                              //                   items: currencyItems,
                              //                   value:  _category,
                                                
                              //                   onChanged:(currencyValue) {
                              //                     // final snackBar = SnackBar(
                              //                     // content: Text(
                              //                     //   'Selected Currency value is $currencyValue',
                              //                     //    style: TextStyle(color: Color(0xff11b719)),
                              //                     //  ),
                              //                     // );
                              //                     // Scaffold.of(context).showSnackBar(snackBar);
                              //                       setState(() {
                              //                        _category = currencyValue;
                              //                       });
                              //                     },
                              //                   style: TextStyle(
                              //                     color: Colors.grey[800],
                              //                   ),
                                        
                              //               ),
                              //             )
                              //         );
                              //         }
                              //       },
                              //       ),
                              //     )
                              //   ],
                              // ),
                              new InputField(
                                obscureText: false,
                                hintText: "Supplier Address: ${this.widget.alamat}",
                                textInputType: TextInputType.text,
                                 enabled: updateCheck,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.home,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                controllerFunction: supplierAddressController,
                              ),
                              new InputField(
                                // hintText: "Selling Price",
                                 enabled: updateCheck,
                                hintText: "Supplier Phone: ${this.widget.phone}",
                                obscureText: false,
                                textInputType: TextInputType.number,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.phone,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                controllerFunction: supplierPhoneController,
                              ),
                             
                              SizedBox(height: 10.0,),
                             new RaisedButton(
                                  child:
                                  Text('Update'),
                                  onPressed: () {
                                   
                                    updateData();
                                     dispose();
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
