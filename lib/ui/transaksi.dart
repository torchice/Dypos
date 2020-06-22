import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:ta_andypos/style/theme.dart' as Theme;
import 'package:ta_andypos/ui/drawerBar.dart';
import 'cart.dart';
import 'home.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'detailScreen.dart';

class Transaksi extends StatefulWidget {
  final String username;
   final TabController controller;
  Transaksi({this.username,this.controller});
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
    // this.pcs,
    this.totalHarga,

  }) : super(key: key);
  //title nama
  //subtitle category

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
  // final TextEditingController pcs;
  int totalHarga;

  final db=Firestore.instance;

  //docID adalah docID dari item yang dipilih;
  void printA(){
    print("berhasil");
  }

  addCart(docID,pcs,stok) async{
    int _qty = int.tryParse(pcs);
    //pcs adalah variabel untuk quantitiy
    //sedangkan untuk 
    // int _priceItem;
    // await takeItemDesc(docID);
    int hargaPcs=sellingPrice;
    int _subTotal=_qty*hargaPcs;
    //qty adalah quantity yg dibeli, sedangkan stok adalah jumlah stok yang tersisa.
    Firestore.instance.collection('owner').document(idUser).collection('cart').add({
        'id_item': docID,
        'item_photo': urlphoto, 
        'item_name': title,
        'qty': _qty,
        'stok': stok,
        'price_pcs':hargaPcs,
        'sub_total': _subTotal,
    });
    
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // _email = this.widget.user;
    // prefs.setInt('totalHarga', _subTotal);
    print("transaksi");
    print(_subTotal);
    // print(ref.documentID);

  }
  
  TextEditingController pcs = new TextEditingController();
  
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Input Quantity is wrong"),
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

  void _inputQty(context){
         showDialog(
                    context: context,
                    builder: (BuildContext context2) {
                      // return object of type Dialog
                      // var option = await AlertDialog()
                      return AlertDialog( 
                        title: new Text('Quantity'),
                        content: TextFormField(
                          controller: pcs,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Pcs '
                          ), 
                        ),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          SimpleDialogOption(
                            child: const Text('Ok'),
                            onPressed: (){
                              print("addCart");
                              int quantityInput = int.tryParse(pcs.text);
                              int stok=quantity;
                              
                              if(quantityInput>stok ||quantityInput ==0){
                                _showDialog(context);
                                print("error");
                              }else{
                                addCart(
                                  docID,
                                  pcs.text,
                                  stok
                                );

                              Navigator.pop(context2);
                                  final snackBar = SnackBar(
                                    content: Text(
                                      'Added to cart',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                backgroundColor: Theme.Colors.loginGradientStart,
                              );
                              Scaffold.of(context).showSnackBar(snackBar);  
                              }
                            },
                          ),
                          SimpleDialogOption(
                            child: const Text('Cancel'),
                            onPressed: (){
                              Navigator.pop(context2);
                            },
                          )
                     
                        ],
                      );
                    },
                  );
  }

  @override
  Widget build(BuildContext dialog) {
    return InkWell(
      onTap: (){
         _inputQty(dialog);
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
                'Stock available: ${quantity.toString()}',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Price pcs: Rp $sellingPrice',
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
    this.thumbnailCache
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
  //ngebuild gambar berdasarkan posisinya

   void deleteData(String idUser, String docID) async{
       Firestore.instance.collection('owner').document(idUser).collection('item').document(docID).delete();
    }

    void confirmationDelete(context){
        showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      // var option = await AlertDialog()
                      return AlertDialog(
                        title: new Text('Confirmation'),
                        content: new Text('Are you sure delete this item?'),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                            SimpleDialogOption(
                              onPressed: () {  
                                    deleteData(idUser, docID);
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
              child: thumbnail2,
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
class Logic {

}


class _ShowItemPage extends State<Transaksi>{
    final db= Firestore.instance;
  final Widget child;
  // MyInheritedWidget dataInherit;
  String idUser;
  int totalHarga=0;
  String _email;
  String role;
  // String name='zxc';
  // String addres,phone;
  String _counter,_value;
  TabController controller;
  final _ArticleDescription customlist;
  _ShowItemPage({
    this.child,this.customlist
  });
  int sellingPrice,quantity;
  String urlphoto,title,docID;

  addCart(docID,pcs,stok) async{
    int _qty = int.tryParse(pcs);
    //pcs adalah variabel untuk quantitiy
    //sedangkan untuk 
    // int _priceItem;
    // await takeItemDesc(docID);
    int hargaPcs=sellingPrice;
    int _subTotal=_qty*hargaPcs;
    //qty adalah quantity yg dibeli, sedangkan stok adalah jumlah stok yang tersisa.
    Firestore.instance.collection('owner').document(idUser).collection('cart').add({
        'id_item': docID,
        'item_photo': urlphoto, 
        'item_name': title,
        'qty': _qty,
        'stok': stok,
        'price_pcs':hargaPcs,
        'sub_total': _subTotal,
  
    });
    
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // _email = this.widget.user;
    // prefs.setInt('totalHarga', _subTotal);
    print("transaksi");
    print(_subTotal);
    // print(ref.documentID);

  }
  
  TextEditingController pcs = new TextEditingController();
  
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Input Quantity is wrong"),
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
    addCart2(docID,pcs,stok) async{
    int _qty = int.tryParse(pcs);
    //pcs adalah variabel untuk quantitiy
    //sedangkan untuk 
    // int _priceItem;
    // await takeItemDesc(docID);
    int hargaPcs=sellingPrice;
    int _subTotal=_qty*hargaPcs;
    //qty adalah quantity yg dibeli, sedangkan stok adalah jumlah stok yang tersisa.

    
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // _email = this.widget.user;
    // prefs.setInt('totalHarga', _subTotal);
    print("transaksi");
    print(_subTotal);
    // print(ref.documentID);

  }


  void _inputQty(context,docID,quantity,hargaPcs,urlphoto,itemname){
         showDialog(
                    context: context,
                    builder: (BuildContext context2) {
                      // return object of type Dialog
                      // var option = await AlertDialog()
                      return AlertDialog( 
                        title: new Text('Quantity'),
                        content: TextFormField(
                          controller: pcs,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Pcs '
                          ), 
                        ),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          SimpleDialogOption(
                            child: const Text('Ok'),
                            onPressed: (){
                              print("addCart");
                              int quantityInput = int.tryParse(pcs.text);
                              int stok=quantity;
                              
                              if(quantityInput>stok ||quantityInput ==0){
                                _showDialog(context);
                                print("error");
                              }else{
                                print("masuk kok coeg 123");
                                int _subTotal=hargaPcs*quantityInput;
                                  Firestore.instance.collection('owner').document(idUser).collection('cart').add({
                                      'id_item': docID,
                                      'item_photo': urlphoto, 
                                      'item_name': itemname,
                                      'qty': quantityInput,
                                      'stok': stok,
                                      'price_pcs':hargaPcs,
                                      'sub_total': _subTotal,
                                  });

                              Navigator.pop(context2);
                                  final snackBar = SnackBar(
                                    content: Text(
                                      'Added to cart',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                backgroundColor: Theme.Colors.loginGradientStart,
                              );
                              Scaffold.of(context).showSnackBar(snackBar);  
                              }
                            },
                          ),
                          SimpleDialogOption(
                            child: const Text('Cancel'),
                            onPressed: (){
                              Navigator.pop(context2);
                            },
                          )
                     
                        ],
                      );
                    },
                  );
  }


    
  Future _scanStok() async{
    _counter = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true, ScanMode.DEFAULT);
      setState(() {
        _value=_counter; 
      });
    var userQuery = await db.collection('owner').document(idUser).collection('item').where('id_item',isEqualTo: _value).getDocuments();
    
    quantity = userQuery.documents[0].data['item_qty'];
    print(quantity.toString());
    print(userQuery.documents[0].data['item_name']);
    docID=userQuery.documents[0].data['id_item'];
    String itemname = userQuery.documents[0].data['item_name'];
    String urlphoto = userQuery.documents[0].data['item_photo'];
    int hargapcs = userQuery.documents[0].data['item_sellingprice'];
    _inputQty(context,docID,quantity,hargapcs,urlphoto,itemname);
    // customlist._inputQty(context);
  }
    
   _loadUid() async {             
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = (prefs.getString ('uid')??'');
      _email = (prefs.getString ('email')??'');
      role = (prefs.getString ('role')??'');
      // totalHarga = (prefs.getInt('totalHarga')??'');
      if(idUser==null){
       CircularProgressIndicator();
      }
      print("Load IdUSer");
      print(idUser);
      print(_email);
    });
  }
  
  @override
  void initState(){
    _loadUid();
    // _loadCart();
    // queryValues();
   super.initState();
  }

  void deleteData(String idUser, String docID) async{
     db.collection('owner').document(idUser).collection('supplier').document(docID).delete();
    }
  
//ini data yang akan dikirimkan
  Widget body(context){ 
      return Flexible(
        child: StreamBuilder<QuerySnapshot>(
        stream: db.collection('owner').document(idUser).collection('item').where('status_aktif', isEqualTo: true).snapshots(),
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
                );
              }
              ).toList(),
          ); 
          
        }
      )
      );
  }

  sumTotal() async {
      Firestore.instance
        .collection('owner').document(idUser).collection('cart')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.documents.fold(
        0, (tot, doc) =>
      
       tot + doc.data['sub_total']);
       totalHarga=tempTotal;

             if(totalHarga!=0){
                Navigator.pushReplacement(context, MaterialPageRoute
              (builder: 
                (context) => Cart(
                  total:totalHarga
                )
              )
            );
          }
      return totalHarga;
      // debugPrint(totalHarga.toString());
    });
  }
  // Widget _buildShowSupplier(BuildContext context, List<DocumentSnapshot> snapshot){
  // }
//context yang di parse adalah punya child yang dinitstate untuk nampilin widget,diperlukan biar gak error State waktu snackBar
//context2/c yang ada adalah context dr builder yang dibikin

  @override
  Widget build(BuildContext context) {
    
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
      backgroundColor: Colors.orangeAccent,
        title:     
          InkWell(
            child:  new Text('Transaksi'),
            onTap:(){
                Navigator.push(
                    context,
                  MaterialPageRoute(builder: (context) => Home(user: _email)) ,
                );
                dispose();
            }
          ),
      ),
      body:
       Column(
         children: <Widget>[
           body(context),
            // QrImage(
            //   data: "sts",
            //   backgroundColor: Colors.white,
            //   size: 100
            // ),
       
            SizedBox(
            width: screenSize.width/2,
            height: 40,
              // height: double.infinity,
              child: new RaisedButton(
                onPressed: (){
                  sumTotal();
                },
                child: Text(
                  'Cart'
                ),
                color: Colors.orangeAccent,
              ),
            ),
            SizedBox(
              height: 10,
            )
         ],
       ),
      drawer: buildDrawer(context, idUser, _email, role),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _scanStok(),
          tooltip: "Scan",
          child: Icon(Icons.settings_overscan),
          backgroundColor: Colors.orange,
        ),
    );

  }
}
