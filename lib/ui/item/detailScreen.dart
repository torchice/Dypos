import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_andypos/ui/item/updateItem.dart' as prefix0;
// import 'dart:async';
import 'dart:io';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:ta_andypos/style/theme.dart' as Theme;
import 'package:ta_andypos/components/TextFields/inputField.dart';
// import 'package:ta_andypos/theme/style.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
// import 'package:ta_andypos/ui/supplier/showSupplier.dart';
// import 'home.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
// import '../drawerBar.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'master_item.dart';



// class ShowItem extends StatefulWidget {
//   final String username;
//    final TabController controller;
//   ShowItem({this.username,this.controller});
//   @override
//   _ShowItemPage createState() => _ShowItemPage();
// }


class DetailItem extends StatefulWidget {

  //   final String username;
  //  final TabController controller;
  // ShowItem({this.username,this.controller});
  // @override
  _DetailItemPage createState() => _DetailItemPage();
  final String idItem;
  final String itemName,category;
  final int supplierPrice,sellingPrice;
  final int qty;
  final String urlImage;
  final Image fileImage;
  final String urlPhoto;
  final ImageCache imageCache;

  DetailItem({
    Key key, 
  this.itemName,this.category,this.qty,this.supplierPrice
  , this.sellingPrice,this.idItem,this.urlImage, this.fileImage,this.urlPhoto,this.imageCache}) : super(key: key);

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

File image;
String filename;
// class _ShowItemPage extends State<ShowItem>{
class _DetailItemPage extends State<DetailItem>{
  
  String idUser;
  String _category;
  bool updateCheck=false;
  var _gambar;
  String _name;
  int _supplierPrice;
  int _sellingPrice;

  TextEditingController itemNameController = new TextEditingController();
  TextEditingController categoryController = new TextEditingController(); 
  // MoneyMaskedTextController supplierPriceController = new MoneyMaskedTextController(leftSymbol: 'Rp', thousandSeparator: '.');
  // MoneyMaskedTextController sellingPriceController = new MoneyMaskedTextController(leftSymbol: 'Rp', thousandSeparator: '.');
  TextEditingController qtyController = new TextEditingController();
  TextEditingController supplierPriceController = new TextEditingController();
  TextEditingController sellingPriceController = new TextEditingController();
  
  final db=Firestore.instance;

   _loadUid() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        idUser = (prefs.getString('uid')??'');
        // _email = (prefs.getString('email')??'');
      });
  }

   Future _getImage() async{
    var selectedImage =  await ImagePicker.pickImage(source: ImageSource.gallery);
    setState((){
      image=selectedImage;
      filename=basename(image.path);
      print(image.path);
      print(filename);
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
          content: new Text("Item Sucesfully Updated"),
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
      image = null;
      super.dispose();
    }
  
  @override
  void initState(){
    // controller = new TabController(vsync: this, length: 3);
    _category=this.widget.category;
    updateCheck=false;
    super.initState();
    _loadUid();
  }

    Future<void> updateData(BuildContext context) async{

      if(image!=null){
          StorageReference ref = FirebaseStorage.instance.ref().child(filename);
          StorageUploadTask uploadTask = ref.putFile(image);

          var url = await(await uploadTask.onComplete).ref.getDownloadURL();
          _gambar = url.toString();
      }else{
        print('gambar diubah');
        _gambar=this.widget.urlImage;
      }

      print('update');
      print(idUser);
      print(this.widget.idItem);

      if(itemNameController.text==""){
        _name=this.widget.itemName;
      }else{
          _name=itemNameController.text;
      }
      if(supplierPriceController.text==""){
        _supplierPrice=this.widget.supplierPrice;
      }else{
         _supplierPrice=int.tryParse(supplierPriceController.text);
      }
      if(sellingPriceController.text==""){
        _sellingPrice=this.widget.sellingPrice;
      }else{
        _sellingPrice=int.tryParse(sellingPriceController.text);
      }
        
      await db.collection('owner').document(idUser).collection('item').document(this.widget.idItem).updateData({
          'item_name': '$_name ',
          'item_category': '$_category',
          'item_supplierprice': _supplierPrice,
          'item_sellingprice': _sellingPrice,
          'item_photo': '$_gambar' 
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
        title: Text("Detail Item"),
        
      ),
        floatingActionButton: FloatingActionButton(
          onPressed:()=> _getImage(),
          tooltip: 'Increment',
          child: Icon(Icons.image),
        
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
                          "Detail Item",
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
                              //  image = Image.file(this.widget.fileImage, width:200, height: 200,),
                              //   SizedBox(height: 30,),
                              // image == null ? 
                              // image == null?
                              // Image.network(this.widget.urlImage, width:200, height: 200,):uploadArea(),
                              // SizedBox(height: 15.0,),
                              // image == null ?
                                image == null ?
                                // this.widget.imageCache
                                CachedNetworkImage(
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  imageUrl: this.widget.urlImage,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                      ),
                                    ),
                                    height: 200,
                                    width: 200,
                                  ),
                                )
                                :uploadArea(),
                                // Icon(Icons.autorenew),
                              new InputField(
                                controllerFunction: itemNameController,
                                // initialVal: this.widget.itemName,
                                hintText: "Item Name: ${this.widget.itemName}",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                enabled: updateCheck,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.text_fields,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
                              ),
                              Row(
                                children: <Widget>[
                                   Icon(
                                      Icons.perm_contact_calendar,
                                      size: 20.0,
                                        color: Colors.black
                                  ),
                                  SizedBox(width: 30,),
                                  Expanded(
                                    child:   
                                    StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance.collection("owner").document(idUser).collection('category').snapshots(),
                                      builder: (context, snapshot) {
                                        if(snapshot.data == null){
                                           return CircularProgressIndicator();
                                        }
                                        if (!snapshot.hasData)
                                        return
                                          const Text("Loading.....");
                                        else {
                                          List<DropdownMenuItem> currencyItems = [];
                                          if(updateCheck==false){
                                            currencyItems.add(
                                              DropdownMenuItem(
                                                child: Text(
                                                  this.widget.category,
                                                  style: TextStyle(color: Color(0xff11b719)),
                                                ),
                                                value:this.widget.category
                                                // value: "${snap.documentID}",
                                              ),
                                            );
                                          }else{
                                            for (int i = 0; i < snapshot.data.documents.length; i++) {
                                              DocumentSnapshot snap = snapshot.data.documents[i];
                                              currencyItems.add(
                                                DropdownMenuItem(
                                                  child: Text(
                                                    snap.data['value'],
                                                    style: TextStyle(color: Color(0xff11b719)),
                                                  ),
                                                  value: "${snap.data['value']}",
                                                ),
                                              );
                                            }
                                          }
                                          
                                        return Container(
                                          width: 300.0,
                                          child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                items: currencyItems,
                                                value:  _category,
                                                onChanged:(currencyValue) {
                                                  // final snackBar = SnackBar(
                                                  // content: Text(
                                                  //   'Selected Currency value is $currencyValue',
                                                  //    style: TextStyle(color: Color(0xff11b719)),
                                                  //  ),
                                                  // );
                                                  // Scaffold.of(context).showSnackBar(snackBar);
                                                    setState(() {
                                                     _category = currencyValue;
                                                    });
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
                                obscureText: false,
                                hintText: "Supplier Price: ${this.widget.supplierPrice.toString()}",
                                textInputType: TextInputType.number,
                                 enabled: false,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: CupertinoIcons.tag_solid,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                controllerFunction: supplierPriceController,
                              ),
                              new InputField(
                                // hintText: "Selling Price",
                                 enabled: updateCheck,
                                hintText: "Selling Price: ${this.widget.sellingPrice.toString()}",
                                obscureText: false,
                                textInputType: TextInputType.number,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.monetization_on,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                controllerFunction: sellingPriceController,
                              ),
                              new InputField(
                                // hintText: "Quantity",
                                obscureText: false,
                                 enabled: false,
                                hintText:"Quantity: ${this.widget.qty}",
                                textInputType: TextInputType.number,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.account_balance,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                // controllerFunction: qtyController,
                              ),
                              SizedBox(height: 10.0,),
                             new RaisedButton(
                                  child:
                                  Text('Update'),
                                  onPressed: () {
                                    // dispose();
                                    updateData(context);
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
