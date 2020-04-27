import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'detailStok.dart';
// import 'detailScreen.dart';


class ShowPage extends StatefulWidget {
  final String username;
   final TabController controller;
  ShowPage({this.username,this.controller});
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
    this.available

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
                               Navigator.push(
                                 context,
                                    MaterialPageRoute(builder: (context) => DetailItem(
                                        idItem: docID,
                                        itemName: title,
                                        category: subtitle,
                                        qty: quantity,
                                        sellingPrice: sellingPrice,
                                        supplierPrice: supplierPrice,
                                        urlImage:urlphoto,
                                        // fileImage: thumbnail,
                                    ))
                                    );
                                  },
                            child: const Text('Retur'),
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
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$subtitle',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'Quantity: ${quantity.toString()}',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Selling Price: $sellingPrice ★',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
                
              ),
            ],
          ),
          
        
        ), 
         
        
      ],
      ),
      
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
    this.available
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
  //ngebuild gambar berdasarkan posisinya

    // void updateData(DocumentSnapshot doc) async{
    //   await db.collection('mahasiswa').document(doc.documentID).updateData({'todo' : 'Updated!'});
    // }


    

    void confirmationDelete(context){
        showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      // var option = await AlertDialog()
                      return AlertDialog(
                        title: new Text('Confirmation'),
                        content: new Text('Non Active / Delete'),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                            SimpleDialogOption(
                              onPressed: () {  
                                    // deleteData(idUser, docID);
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  available ?
                  thumbnail2 : 
                    Container(
                      child: new Image.asset(
                       'assets/not_active.png',
                       height:100,
                       fit:BoxFit.cover
                      ),
                    )
                ],)
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  quantity: quantity,
                  supplierPrice: supplierPrice,
                  sellingPrice: sellingPrice,
                  docID: docID,
                  idUser: idUser,
                  urlphoto: urlPhoto,
                  thumbnail2:thumbnailCache
                ),
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}


class _ShowItemPage extends State<ShowPage>{
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
  void initState(){
    _loadUid();
   super.initState();
  }

  // void _goUpdate(){

  // }
//ini data yang akan dikirimkan
  Widget body(context){ 
      return StreamBuilder<QuerySnapshot>(
        stream: db.collection('owner').document(idUser).collection('item').snapshots(),
        builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return const Text('loading..');
          
          return new ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
                return CustomListItemTwo(
                    // thumbnail: Image.network(document['item_photo']),
                    //thumbnail2 adalah tipe CachedNetworkImage sedangkan thumbnail1 tipe Image  
                    thumbnail2: CachedNetworkImage(
                      imageUrl: document['item_photo'],
                      imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      placeholder: (context, url) => new CircularProgressIndicator(),
                    ),
                    title: document['item_name'],
                    subtitle: document['item_category'],
                    quantity:document['item_qty'],
                    supplierPrice:document['item_supplierprice'],
                    sellingPrice:document['item_sellingprice'],
                    docID: document.documentID,
                    idUser: idUser,
                    urlPhoto: document['item_photo'],
                    
                    available: document['status_aktif'],
                  );
                
              }
              ).toList(),
          ); 
          
        }
      );
  }

  // Widget _buildShowSupplier(BuildContext context, List<DocumentSnapshot> snapshot){
  
  // }

//context yang di parse adalah punya child yang dinitstate untuk nampilin widget,diperlukan biar gak error State waktu snackBar
//context2/c yang ada adalah context dr builder yang dibikin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Builder(
        builder: (context) => body(context)
      ),
      
    );

  }
}
