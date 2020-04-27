import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
// import 'detailStok.dart';
// import 'detailScreen.dart';

class ListReturItemPage extends StatefulWidget {
  final String username;
   final TabController controller;
   final String idTransaction;
   final String docIDItem;
   final String docIDRetur;
  ListReturItemPage({this.username,this.controller,this.idTransaction,this.docIDItem,this.docIDRetur});
  @override
  _ShowItemPage createState() => _ShowItemPage();
}

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.subtitle,
    this.quantity,
    this.supplierPrice,
    this.sellingPrice,
    this.docID,
    this.idUser,
    // this.thumbnail,
    this.thumbnail2,
    this.urlphoto,
    this.available,
    this.idItem

  }) : super(key: key);

  final String title;
  final String subtitle;
  final int quantity;
  final int supplierPrice;
  final int sellingPrice;
  final String docID;
  final String idUser;
  // final Image thumbnail;
  final ImageCache thumbnail2;
  final String urlphoto;
  final bool available;
  final String idItem;

  void deleteData(String idUser, String docID) async{
    await Firestore.instance.collection('owner').document(idUser).collection('item').document(docID).delete();
  }
  
  //untuk nampilkan tampilannya di show Item selain Image Item
  @override
  Widget build(BuildContext context) {
    return InkWell(
      
      onTap: (){
           showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      // var option = await AlertDialog()
                      return AlertDialog(
                        title: new Text('Action'),
                        content: new Text('$title'),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          SimpleDialogOption( 
                            // his.itemName,this.category,this.qty,this.supplierPrice, this.sellingPrice
                            onPressed: () {
                               Navigator.pop(context);  
                              //  Navigator.push(
                              //    context,
                              //       MaterialPageRoute(builder: (context) => DetailItem(
                              //           idItem: docID,
                              //           itemName: title,
                              //           category: subtitle,
                              //           qty: quantity,
                              //           sellingPrice: sellingPrice,
                              //           supplierPrice: supplierPrice,
                              //           urlImage:urlphoto,
                              //           // fileImage: thumbnail,
                              //       ))
                              //       );
                                  },
                            child: const Text('Detail'),
                          ),
                          SimpleDialogOption(
                            child: const Text('Back'),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          )
                     
                        ],
                      );
                    },
                  );
      },
      child:
        Container(
        child:
          Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Document ID Transaction: $title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text('Item name: $subtitle'),
              SizedBox(
                height: 4,
              ),
              Text(
                'Quantity Retur: ${quantity.toString()}',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ), 
      ],
      ),
        )
    );
 
  }
}


class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.quantity,
    this.supplierPrice,
    this.sellingPrice,
    this.docID,
    this.idUser,
    this.urlPhoto,
    this.thumbnail2,
    this.thumbnailCache,
    this.available,
    this.idItem,
    this.docIDItem
  }) : super(key: key);

  final Image thumbnail;
  final CachedNetworkImage thumbnail2;
  final ImageCache thumbnailCache;
  final String title;
  final String subtitle;
  final int quantity;
  final int supplierPrice;
  final int sellingPrice;
  final String docID;
  final String idUser;
  final String urlPhoto;
  final bool available;
  final String idItem;
  final String docIDItem;
  //ngebuild gambar berdasarkan posisinya

  //kalau status_retur true berarti retur sudah selesai
    void updateData(docID,quantity,idItem,docIDItem) async{
 
      var userDocument = await Firestore.instance.collection('owner').document(idUser).collection('item').where('id_item', isEqualTo: idItem).getDocuments();
      int stokAwal=userDocument.documents[0].data['item_qty'];
      int stokAkhir= stokAwal+quantity;
      print('stokAwal');
      print(stokAwal.toString());
      print('stokAkhir');
      print(stokAkhir.toString());
      Firestore.instance.collection('owner').document(idUser).collection('item').document(idItem).updateData({
        'item_qty' : stokAkhir
      });

       Firestore.instance.collection('owner').document(idUser).collection('retur_penjualan').document(docID).updateData({
        'status_retur' : true});

    }

  void confirmationDone(context){
        showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      // var option = await AlertDialog()
                      return AlertDialog(
                        title: new Text('Confirmation'),
                        content: new Text('Retur Already Done?'),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                            SimpleDialogOption(
                              onPressed: () {  
                                    // deleteData(idUser, docID);
                                    updateData(docID,quantity,idItem,docIDItem);
                                    Navigator.pop(context);
                              },       
                                child: const Text('Delete'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {  
                                Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                            )
                          ]
                        );
                      }
          );
      
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.orangeAccent,
                width: 2.0
              )
            ),  
          ),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 20.0, 0.0, 10.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  quantity: quantity,
                  supplierPrice: supplierPrice,
                  sellingPrice: sellingPrice,
                  docID: docID,
                  idUser: idUser,
                  urlphoto: urlPhoto,
                  thumbnail2:thumbnailCache,
                  idItem:idItem
                ),
              ),
            ),
            Column(
              children: <Widget>[
                InkWell(
                  child: 
                  SizedBox(
                    child:
                      available ? 
                      Icon(Icons.done) :
                      Icon(Icons.do_not_disturb_alt)
                     ,
                     height: 100, width:100
                  ),
                  onTap: (){
                    // print("delete");
                       
                    if(available==false){
                      print("bisa pencet");
                      confirmationDone(context);
                      // print(docID);
                      // updateData(docID);
                    }
                  },
                ),
              
              ],
            )
            
          ],
        ),
      ),
    );
  }
}


class _ShowItemPage extends State<ListReturItemPage>{
    final db= Firestore.instance;
  final Widget child;
  // MyInheritedWidget dataInherit;
  String idUser;
  // String _email;
  // String name='zxc';
  // String addres,phone;

  TabController controller;

  _ShowItemPage({
    this.child
  });

  _loadUid() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        idUser = (prefs.getString('uid')??'');
        // _email = (prefs.getString('email')??'');
      });
  }
  
  @override
  initState(){
    _loadUid();
   super.initState();
  }


  // void _goUpdate(){

  // }
//ini data yang akan dikirimkan
  Widget body(context){
      return StreamBuilder<QuerySnapshot>(
        stream: db.collection('owner').document(idUser).collection('retur_penjualan').where('id_transaction', isEqualTo: this.widget.idTransaction).where('kd_item',isEqualTo:this.widget.docIDItem).snapshots(),
        builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return const Text('loading..');
          
          return new ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
                return CustomListItemTwo(
                    // thumbnail: Image.network(document['item_photo']),
                    //thumbnail2 adalah tipe CachedNetworkImage sedangkan thumbnail1 tipe Image
                    docID: document.documentID,  
                    title: document['id_transaction'],
                    idItem: document['kd_item'],
                    subtitle: document['nama_item'],
                    docIDItem: this.widget.docIDItem,
                    // idItem: document[''],
                    // subtitle: document['id_item'],id_transaction
                    quantity:document['qty_retur'],
                    idUser: idUser,
                    available: document['status_retur'],
                  );
              }
              ).toList(),
          ); 
          
        }
      );
  }

//context yang di parse adalah punya child yang dinitstate untuk nampilin widget,diperlukan biar gak error State waktu snackBar
//context2/c yang ada adalah context dr builder yang dibikin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('List Item Retur'),
        backgroundColor: Colors.orange,
      ),
      body:Builder(
        builder: (context) => body(context)
      ),
      
    );

  }
}
