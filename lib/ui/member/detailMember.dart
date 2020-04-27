import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:ta_andypos/style/theme.dart' as Theme;
// import 'package:ta_andypos/ui/drawerBar.dart';
import '../home.dart';
import 'package:intl/intl.dart';

// import '..//home.dart';
// import 'cart.dart';
// import 'detailScreen.dart';

class DetailMember extends StatefulWidget {
  final String username;
  final String idHeaderTrans;
  final String nameBuyer;
  final String emailBuyer;
  final String noTelpBuyer;
   final TabController controller;
  DetailMember({this.username,this.controller,this.idHeaderTrans,this.nameBuyer,this.emailBuyer,this.noTelpBuyer});
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
    this.totalRetur,
    this.idItem

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
  int totalRetur;
  final String idItem;

  final db=Firestore.instance;
  
  //docID adalah docID dari item yang dipilih;

  addDataRetur(title,pcs,stok) async{
    int _qty = int.tryParse(pcs);
    //title diisi docID dari header_trans
    //pcs adalah variabel untuk quantitiy
    //sedangkan untuk 
    // int _priceItem;
    // await takeItemDesc(docID);
    // int hargaPcs=sellingPrice;
    // int _subTotal=_qty*hargaPcs;
    //qty adalah quantity yg dibeli, sedangkan stok adalah jumlah stok yang tersisa.
     await Firestore.instance.collection('owner').document(idUser).collection('cart_header').add({
        'id_header': title,
        'id_item': idItem,
        'item_photo': urlphoto, 
        'item_name': subtitle,
        'qty_retur': _qty,
    });
        
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // _email = this.widget.user;
    // await prefs.setInt('totalRetur', _subTotal);
    // print("transaksi");
    // print(_subTotal);
    // print(ref.documentID);

  }
 
  TextEditingController pcs = new TextEditingController();
  
  void _showDialogError(context) {
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

  

  @override
  Widget build(BuildContext dialog) {
    
    return InkWell(
      
      onTap: (){
           showDialog(
                    context: dialog,
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
                                _showDialogError(dialog);
                                print("error");
                              }else{
                                  //pcs.text adalah quantity jumlah yang akan diretur
                                // queryValues();
                                addDataRetur(
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
                              Scaffold.of(dialog).showSnackBar(snackBar);  
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
                '$subtitle',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
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
                'Quantity Bought: ${quantity.toString()}',
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
    this.thumbnailCache,
    this.idItem
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
  final String idItem;
  //ngebuild gambar berdasarkan posisinya

   void deleteData(String idUser, String docID) async{
      await Firestore.instance.collection('owner').document(idUser).collection('item').document(docID).delete();
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
                StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('owner').document(idUser).collection('item').where('id_item',isEqualTo: idItem).snapshots(),
                builder:(context,  snapshot){          
                  if(!snapshot.hasData) return new Text('loading..');
                  // var index = snapshot.data.documents.length;
                  var userDocument = snapshot.data;
                  // print(userDocument.documents[0].data['item_photo']);
                  // return Text(index.toString());
                  
                  return  CachedNetworkImage(
                            imageUrl: userDocument.documents[0].data['item_photo'],
                            imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                      
                                  ),
                                  
                                ),
                                height: 100,
                                width: 100,
                              ),
                            placeholder: (context, url) => new CircularProgressIndicator(),
                          );
                      }),
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
                  thumbnail2:thumbnailCache,
                  idItem: idItem,
                ),
              ),
            ),
        
          ],
        ),
      ),
    
    );
  }
}


class _ShowItemPage extends State<DetailMember>{
    final db= Firestore.instance;
  final Widget child;
  // MyInheritedWidget dataInherit;
  String idUser;
  int totalRetur=0;
  String _email;
  String role;
  // String name='zxc';
  // String addres,phone;

  TabController controller;
  
  // TextEditingController headerMemberController;
  
  // TextEditingController headerController = new TextEditingController();
  
  TextEditingController headerTanggalController = new TextEditingController();
  _ShowItemPage({
    this.child
  });

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

  _loadCart() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        totalRetur = (prefs.getInt('totalRetur')??'');
        // _email = (prefs.getString('email')??'');
      });
  }
  
  @override
  void initState(){
    _loadUid();
    _loadCart();
    _loadData();
        // queryValues();
   super.initState();
  }

  _loadData() async{
              //  stream: db.collection('owner').document(idUser).collection('header_transaksi').document(this.widget.idHeaderTrans).snapshots(),
              //       builder:(BuildContext context, snapshot){
     

  
  //   if(userQuery.documents.isNotEmpty){

  //     print("Check New Module");
  
  //     role=userQuery.documents[0].data['role'];
  // }

  }

  void deleteData(String idUser, String docID) async{
      await db.collection('owner').document(idUser).collection('supplier').document(docID).delete();
    }

  // void _goUpdate(){

  // }
//ini data yang akan dikirimkan

  Widget _buildNameMemberField(data) {
    return CupertinoTextField(
      prefix: const Icon(
        CupertinoIcons.mail,
        color: CupertinoColors.black,
        size: 28,
      ),
      // controller: headerMemberController,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      
      keyboardType: TextInputType.text,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.black,
          ),
        ),
      ),
      placeholder: 'Buyer Email : $data',
      enabled: false,
      onChanged: (newName) {
        setState(() {
          // name = newName;
        });
      },
    );
  }

   Widget _buildEmailMemberField(data) {
    return CupertinoTextField(
      prefix: const Icon(
        CupertinoIcons.person,
        color: CupertinoColors.black,
        size: 28,
      ),
      // controller: headerMemberController,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      
      keyboardType: TextInputType.text,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.black,
          ),
        ),
      ),
      placeholder: 'Buyer Name : $data',
      enabled: false,
      onChanged: (newName) {
        setState(() {
          // name = newName;
        });
      },
    );
  }

   Widget _buildTelpMemberField(data) {
    return CupertinoTextField(
      prefix: const Icon(
        CupertinoIcons.phone,
        color: CupertinoColors.black,
        size: 28,
      ),
      // controller: headerMemberController,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      
      keyboardType: TextInputType.text,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.black,
          ),
        ),
      ),
      placeholder: 'No Telp : $data',
      enabled: false,
      onChanged: (newName) {
        setState(() {
          // name = newName;
        });
      },
    );
  }


  Widget body(context){ 
    // Size screenSize = MediaQuery.of(context).size;
    // String headerBuyer;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: new Column(
      children: <Widget>[
       Column(
               children: <Widget>[
                StreamBuilder(
                    stream: db.collection('owner').document(idUser).collection('header_transaksi').where('id_header', isEqualTo: this.widget.idHeaderTrans).snapshots(),
                    builder:(BuildContext context, snapshot){
                      if(!snapshot.hasData) return const Text('loading..');
                        // var userDocument = snapshot.data;

                        // setState(() {
                        //   headerBuyer = snapshot.data['nama_member'];
                        //  });
                        //  headerMemberController = new TextEditingController(text: snapshot.data['nama_member']);
                          return new  Container(
                          height: 150,
                          // margin: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            children: <Widget>[
                              //email,nama,notelp
                              _buildEmailMemberField(this.widget.emailBuyer),
                              _buildNameMemberField(this.widget.nameBuyer),
                              _buildTelpMemberField(this.widget.noTelpBuyer),
                              // // _buildPelayanField(userDocument.documents[0].data['nama_pelayan']),                    
                              // _buildTanggalTransField(snapshot.data['no_telp']),                 
                              // _buildTotalField(snapshot.data['email_member']),
                            ],
                          ),
                        );
                      }
                  ),
               ],
             ),
         ]
        ),
     );
   
  }

  
  // Widget _buildShowSupplier(BuildContext context, List<DocumentSnapshot> snapshot){
  // }
//context yang di parse adalah punya child yang dinitstate untuk nampilin widget,diperlukan biar gak error State waktu snackBar
//context2/c yang ada adalah context dr builder yang dibikin
  getStok(idItem,stokAwal,qtyRetur) async{
    var userQuery = await db.collection('owner').document(idUser).collection('item').where('id_item',isEqualTo: idItem).getDocuments();

    print("Check Modul Quantity Stok");
    
    stokAwal=userQuery.documents[0].data['item_qty'];
    print(stokAwal.toString());
            print('stok awal');
            print(stokAwal.toString());
            print("stok retur");
            print(qtyRetur.toString());
            int stokAkhir = stokAwal - qtyRetur;
            print(stokAkhir.toString());
            
            Firestore.instance.collection('owner').document(idUser).collection('item').document(idItem).updateData({
              'item_qty': stokAkhir,
            }); 
            
    // return stokAwal;x
  }

  void _showDialogSuccess(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Retur Succesfully executed"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home(user: _email)) ,
                );
  
              },
            ),
          ],
        );
      },
    );
  }



   confirmRetur(idHeader,namaBuyer) async{
     int stokAwal=0;
    // int stokAkhir;

    DateTime now = DateTime.now();
    String formattedTime = DateFormat('yyyy-MM-dd hh:mm').format(now);
    
   Firestore.instance.collection('owner').document(idUser).collection('header_transaksi').document(idHeader).get();
    
    
    DocumentReference ref = await Firestore.instance.collection('owner').document(idUser).collection('retur_penjualan').add({
      'id_transaction': idHeader,
      'tanggal_retur': formattedTime,
      'nama_buyer': namaBuyer,
      'status_retur' : false,
    });

    print('mulai');
    await Firestore.instance.collection('owner').document(idUser).collection('cart_header').getDocuments().then((snapshot){
        for(DocumentSnapshot ds in snapshot.documents){
           Firestore.instance.collection('owner').document(idUser).collection('retur_penjualan').document(ref.documentID).collection('item_retur').add({
              'id_transaction':  ds.data['id_header'],
              'kd_item': ds.data['id_item'], 
              'nama_item': ds.data['item_name'],
              'qty_retur': ds.data['qty_retur'],
              'price_pcs': ds.data['price_pcs'], 
              'status_retur': false,
            });
            print("getStok");            
            getStok(ds.data['id_item'],stokAwal,ds.data['qty_retur']);
           
            ds.reference.delete();

          }
      });
      print('selesai');
      // Firestore.instance.collection('owner').document(idUser).collection('cart_header').;
       _showDialogSuccess(context);
  }

  queryValues() async {
    Firestore.instance
        .collection('owner').document(idUser).collection('cart_header')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.documents.fold(
        0, (tot, doc) =>
      
       tot + doc.data['qty_retur']);
       totalRetur=tempTotal;
      print('test total Retur');
      
      debugPrint(totalRetur.toString());
      return totalRetur;
    });
  }


  @override
  Widget build(BuildContext context) {
    //  Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        title: Text('Detail Member'),
        backgroundColor: Colors.orangeAccent,
      ),
      body:body(context),
     
    );
  }
}
