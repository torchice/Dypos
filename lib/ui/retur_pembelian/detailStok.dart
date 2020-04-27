import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'insert.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailItem extends StatefulWidget {

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
      // Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[

        ],
        title: Text("Detail Adding Stock"),
        backgroundColor: Colors.orangeAccent,
      ),
      body:   StreamBuilder<QuerySnapshot>(
          stream:  Firestore.instance
          .collection("owner")
          .document(idUser).collection('item').document(this.widget.idItem).collection('supplier_sender').snapshots(),
            builder: (context, snapshot) {
              // MyInheritedWidget.of(context).name= snapshot.data.documents[index].data['supplier_name'];
              // dataInherit.addres
              if (snapshot?.data == null) return Text("Error");
                    return ListView.builder(
                    itemBuilder: (BuildContext context2, int index) => 
                    Card(
                          elevation: 2.0,
                          child:
                          InkWell(
                              child: ListTile(
                                      title: Text(
                                        // snapshot.toString(),
                                        "Id Add Stok:${
                                        snapshot.data.documents[index].documentID}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: (){
                                          
                                        // gotoDetail(
                                        //   snapshot.data.documents[index].data['supplier_name'],
                                        //   snapshot.data.documents[index].data['supplier_phone'],
                                        //     snapshot.data.documents[index].data['supplier_address'],
                                        //     snapshot.data.documents[index].documentID
                                        //   );
                                      },
                                      subtitle:
                                        
                                        Text("Tanggal Add Stok ${snapshot.data.documents[index].data['time']}"),
                                        trailing: 
                                        InkWell(
                                          child:
                                            Icon(Icons.remove_circle_outline),
                                          onTap:(){
                                              Navigator.push(
                                        context,
                                            MaterialPageRoute(builder: (context) => AddPage(
                                              docIDItem: this.widget.idItem,
                                              docIDStok: snapshot.data.documents[index].documentID,
                                              docIDSupplier: snapshot.data.documents[index].data['supplier_sender'],
                                              qtyMaxStok: snapshot.data.documents[index].data['stok_tambah'],
                                                // fileImage: thumbnail,
                                            ))
                                            );
                                            // confirmationDelete(context, snapshot.data.documents[index].documentID);
                                          }
                                        ),
                                        // trailing: Text(snapshot.data.documents[index].data['supplier_address']),
                                    ),
                          ),
                        ),
                        
                    itemCount:snapshot.data.documents.length,
                  );
            },
          )
    );
  }

}
