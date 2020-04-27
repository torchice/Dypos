import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart' as prefix0;
import 'transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_andypos/style/theme.dart' as Theme;
// import 'package:ta_andypos/components/TextFields/inputField.dart';
// import 'package:ta_andypos/style/theme.dart' as Theme;
// import 'package:ta_andypos/theme/style.dart';
// import 'package:ta_andypos/succesfull.dart';
import '../succesfull.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'midtrans.dart';

//import 'package:flutter_midtrans/flutter_midtrans.dart';

void main() => runApp(Cart());

class Cart extends StatelessWidget {
  // This widget is the root of your application.
    final int total;

  Cart({
    Key key, 
    this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, home: CartPage(
        total:total
      ));
  }
}


class Record {
 final String name;
 final int qty;
 final DocumentReference reference;

 Record.fromMap(Map<dynamic, dynamic> map, {this.reference})
     : assert(map['item_name'] != null),
       assert(map['qty'] != null),
       name = map['item_name'],
       qty = map['qty'];

 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$qty>";
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
    final int total;

  CartPage({
    Key key, 
    this.total}) : super(key: key);


}

class _CartPageState extends State<CartPage> {
  int hargaTotal;
  List picked = [false, false];
  String idUser;
  String _email;
  final db=Firestore.instance;
  bool hargaPromo=false;
  int discountPrice;
  String testHeader;
  
  TextEditingController buyerNameController = new TextEditingController();
  TextEditingController buyerPhoneController = new TextEditingController();
  TextEditingController buyerPromoController = new TextEditingController();
  TextEditingController buyerPaymentController = new TextEditingController();
  TextEditingController buyerEmailController = new TextEditingController();
  TextEditingController buyerMethodController = new TextEditingController();

  int totalItem;
  int totalAmount = 0;
 
    _loadUid() async {             
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = (prefs.getString ('uid')??'');
      _email = (prefs.getString ('email')??'');
      // role = (prefs.getString ('role')??'');
      if(idUser==null){
        CircularProgressIndicator
        (
          backgroundColor: Colors.green,
        );
      }
      print("Load IdUSer");
      print(idUser);
      print(_email);
    });
  }

  _dataProcess() async{
    // await _saveUid();
    _loadUid();
  }

    void initState(){
      _dataProcess();
     hargaTotal = this.widget.total;
      super.initState();

    } 

    queryValues(idItem,priceAkhir) async {
      int totalHarga;
      Firestore.instance
        .collection('owner').document(idUser).collection('item').document(idItem).collection('supplier_sender')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.documents.fold(
        0, (tot, doc) =>
      
       tot + doc.data['stok_tambah']);
       totalHarga=tempTotal;
       print("ZXC");
      
      Firestore.instance.collection('owner').document(idUser).collection('item').document(idItem).updateData({
                          'item_qty': totalHarga,
                          'item_supplierprice': priceAkhir
                        });
        print(totalHarga);
      return totalHarga;
      // debugPrint(totalHarga.toString());
    });
  }

  

  Widget _buildBody(BuildContext context) {

      return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
              children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                // height: MediaQuery.of(context).size.height,
                  height:100,
                width: double.infinity,
              ),
              Container(
                height: 100.0,
                width: double.infinity,
                color: Colors.orange
              ),
             
         
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: IconButton(
                  color: Colors.white,
                    alignment: Alignment.topLeft,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                            new Transaksi()
                            )
                         
                );
                   print('abc');
                    }),    
              ),
              Positioned(
                  top: 50.0,
                  left: 15.0,
                  child: Text(
                    'DETAIL TRANSACTION',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))                 
            ]),
                        _buildNameField(),
                        _buildPhoneField(),
                        _buildEmailField(),
                        _buildPromoField(),
                        CupertinoButton(child: Text('Apply Promo'),
                        
                        onPressed: (){
                          String promoCode=buyerPromoController.text;
                          applyPromo(promoCode);
                        }),
                         StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance.collection('owner').document(idUser).collection('cart').snapshots(),
                            builder: (context, snapshot){
                              if(!snapshot.hasData) return CircularProgressIndicator();
                                if(snapshot.data == null) return CircularProgressIndicator();
                                    if(snapshot.hasData)
                                    {
                                      final record = Record.fromSnapshot(snapshot.data.documents[0]);
                                      if(snapshot.data!=null){
                                      
                                      return Column(
                                        children: snapshot.data.documents.map(
                                          (doc) => itemCard(record.name, 'gray', '248',
                                      'assets/img/login_logo.png', true, 1,doc) ).toList()
                                        ); 
                                      }else{

                                        return CircularProgressIndicator();
                                      }
                                  
                                  }else{
                                    return Column(children: <Widget>[
                                      Text('Please Wait'),
                                    ]);
                                  }
                              }
                            ),
                            SizedBox(
                              height: 20,
                            ),
            
                            hargaPromo ?
                            Text('Total: \Rp  ${hargaTotal.toString()} (${discountPrice.toString()})')
                              :
                            Text('Total: \Rp ' + hargaTotal.toString())
                          ,
                          SizedBox(
                            height: 10,
                          ),
                          _buildPaymentField(),
                          _buildMethodField(),
                            SizedBox(
                            height: 10,
                          ),
                                CupertinoButton(
                                    child: const Text('Choose Payment'),  
                                    color: Colors.orangeAccent,
                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                    
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context2){
                                          return CupertinoAlertDialog(

                                              actions: <Widget>[
                                                
                                              CupertinoDialogAction(
                                              
                                              child: const Text('Other'),
                                              onPressed: () {
                                                Navigator.pop(context2, 'Other');
                                                
                                                // setPayment('debit');
                                                    buyerMethodController.text="Other";
                                                      final snackBar = SnackBar(
                                                            content: Text(
                                                                'Selected Payment Method is Other',
                                                                style: TextStyle(
                                                                  color: Colors.lightGreen,
                                                                decorationColor: Colors.white
                                                                ),
                                                            ),
                                                            backgroundColor: Colors.black54,
                                                      );
                                                      Scaffold.of(context).showSnackBar(snackBar);  
                                              },
                                            ),
                                            CupertinoDialogAction(
                                              child: const Text('Cash'),
                                              onPressed: () {
                                                     buyerMethodController.text="Cash";
                                                // setPayment('cash');
                                                Navigator.pop(context2, 'Cash');
                                                // setRupiahBayar(context2,hargaTotal,namaBuyer,buyerPhone);
                                                      final snackBar = SnackBar(
                                                            content: Text(
                                                                'Selected Payment Method is Cash',
                                                                style: TextStyle(
                                                                  color: Colors.lightGreen,
                                                                decorationColor: Colors.white
                                                                ),
                                                            ),
                                                            backgroundColor: Colors.black54,
                                                      );
                                                      Scaffold.of(context).showSnackBar(snackBar);  
                                              },
                                            ),
                                            CupertinoDialogAction(
                                              child: const Text('Cancel'),
                                              isDestructiveAction: true,
                                              onPressed: () {
                                                Navigator.pop(context2, 'Cancel');
                                              },
                                            ),
                                          ],
                                        );
                                        }
                                      );
                                   
                                    },
                                  ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          )    ,
                          ButtonTheme(
                            minWidth: 250.0,
                            height: 50.0,
                            child: RaisedButton(
                              color: Colors.orange,
                              textColor: Colors.white,
                              onPressed: () {

                                inputHeader();
                              },
                              child: Text("Konfirmasi"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          )     
                  ],
                  
                ),
                
              );
              
  }

    Widget _buildPaymentField() {
    return CupertinoTextField(
      prefix: const Icon(
        CupertinoIcons.tags,
        color: CupertinoColors.black,
        size: 28,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      controller: buyerPaymentController,
      keyboardType: TextInputType.number,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.black,
          ),
        ),
      ),
      placeholder: 'Payment Value',
      onChanged: (newName) {
        setState(() {
          // name = newName;
        });
      },
    );
  }

  
   Widget _buildEmailField() {
    return CupertinoTextField(
      prefix: const Icon(
        CupertinoIcons.mail_solid,
        color: CupertinoColors.black,
        size: 28,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      controller: buyerEmailController,
      keyboardType: TextInputType.text,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.black,
          ),
        ),
      ),
      placeholder: 'Email',
      onChanged: (newName) {
        setState(() {
          // name = newName;
        });
      },
    );
  }
    Widget _buildMethodField() {
    return CupertinoTextField(
      prefix: const Icon(
        CupertinoIcons.circle,
        color: CupertinoColors.black,
        size: 28,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      controller: buyerMethodController,
      keyboardType: TextInputType.text,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.black,
          ),
        ),
      ),
      placeholder: 'Payment Method',
      onChanged: (newName) {
        setState(() {
          // name = newName;
        });
      },
    );
  }

   Widget _buildNameField() {
    return CupertinoTextField(
      prefix: const Icon(
        CupertinoIcons.person_solid,
        color: CupertinoColors.black,
        size: 28,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      controller: buyerNameController,
      keyboardType: TextInputType.text,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.black,
          ),
        ),
      ),
      placeholder: 'Name',
      onChanged: (newName) {
        setState(() {
          // name = newName;
        });
      },
    );
  }
    applyPromo(promoCode) async {

      String promoCodeStr=promoCode.toString();
      // DateTime now = DateTime.now();
      var userQuery = await db.collection('owner').document(idUser).collection('promo').where('promo_code',isEqualTo: promoCodeStr).getDocuments();
      // String formattedTime = DateFormat('yyyy-MM-dd hh:mm').format(now);

      String available=userQuery.documents[0].data['promo_code'];
      // print(available);
      if(available==null){
        print('tidak');
      }else{
          Firestore.instance
            .collection('owner').document(idUser).collection('cart')
            .snapshots()
            .listen((snapshot) {

            int tempTotal = snapshot.documents.fold(
              0, (tot, doc) =>
            
            tot + doc.data['qty']);
            totalItem=tempTotal;
          // debugPrint(totalHarga.toString());
            
            if(totalItem<10){
                print('kurang dari 10');
                setState(() {
                  hargaTotal=(hargaTotal*0.9).toInt();
                  hargaPromo=true;
                  discountPrice=(hargaTotal*0.1).toInt();
                  print(hargaTotal.toString());
              });
              
            }else{
                print('lebih dari 10');
                setState(() {
                      hargaPromo=true;
                    // int konversi=0.85;
                    hargaTotal=(hargaTotal*0.85).toInt();
                          discountPrice=(hargaTotal*0.15).toInt();
                        print(hargaTotal.toString());
                });
            }
          });
      
        }

    return hargaTotal;

  }
  
  Widget _buildPromoField() {
    return CupertinoTextField(
      prefix: const Icon(
        CupertinoIcons.tag_solid,
        color: CupertinoColors.black,
        size: 28,
      ),
      controller: buyerPromoController,
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
      placeholder: 'Promo Code',
      
      onChanged: (newName) {
        setState(() {
          // name = newName;
        });
      },
    );
  }

  Widget _buildPhoneField() {
    return CupertinoTextField(
      prefix: const Icon(
        CupertinoIcons.phone_solid,
        color: CupertinoColors.black,
        size: 28,
      ),
      controller: buyerPhoneController,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      keyboardType: TextInputType.number,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.black,
          ),
        ),
      ),
      placeholder: 'Phone',
      onChanged: (newName) {
        setState(() {
          // name = newName;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding:false,
      body: _buildBody(context),
    
    );
  }


  void inputHeader() async{        
          int hargaBayar = int.tryParse(buyerPaymentController.text);
          int kembalian = hargaBayar-hargaTotal;
          print("succ");
          print("hargaTotal");
          print(hargaTotal.toString());
          print("hargaBayar");
          print(hargaBayar.toString());
          print("kembalian");
          
          DateTime now = DateTime.now();
          String formattedTime = DateFormat('yyyy-MM-dd hh:mm').format(now);
          String buyername = buyerNameController.text;
          String phone = buyerPhoneController.text;
          String email = buyerEmailController.text;
          String promo= buyerPromoController.text;
          String method =buyerMethodController.text;
          String idHeader;
          // final waitList = <Future<void>>[];
            DocumentReference ref;
            if(method=="Cash"){
               if(kembalian>=0 || kembalian==0){
                   ref = await Firestore.instance.collection('header_transaksi').add({
                    'id_header' : '',
                    'tanggal_transaksi': formattedTime, 
                    'nama_pelayan': _email,
                    'nama_member': buyername,
                    'no_telp': phone,
                    'jenis_pembayaran': method,
                    'email_member': email,
                    'promo_kode': promo,
                    'harga_total': hargaTotal,
                    'status_bayar': true,
                    'uid': idUser,
                    'berhasil' : "true"
                  });

                  Firestore.instance.collection('header_transaksi').document(ref.documentID).updateData({
                      'id_header': ref.documentID
                  });
    
                  idHeader=ref.documentID;
                  lifo(idHeader,kembalian,hargaBayar);

                  Navigator.pushReplacement(context, new MaterialPageRoute(
                    builder: (context)=> new SucesfullPagePrint(
                      idUser: idUser,
                      idHeader: idHeader,
                      changeAmount: kembalian,
                      cash: hargaBayar,
                  )));


                }else{
                  print("Tidak Cukup");
                }
            }else{
                ref = await Firestore.instance.collection('header_transaksi').add({
                'id_header' : '',
                'tanggal_transaksi': formattedTime, 
                'nama_pelayan': _email,
                'nama_member': buyername,
                'no_telp': phone,
                'jenis_pembayaran': method,
                'email_member': email,
                'promo_kode': promo,
                'harga_total': hargaTotal,
                'status_bayar': false,
                'uid': idUser,
                'berhasil': "true"
              }); 

                
              Firestore.instance.collection('header_transaksi').document(ref.documentID).updateData({
                  'id_header': ref.documentID
              });

              idHeader=ref.documentID;
              lifo(idHeader,kembalian,hargaBayar);

                    Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (context)=> new PaymentGateway(
                          idHeader: idHeader,
                        )));
            }
 
  }

  lifo(idHeader,kembalian,hargaBayar) async{
      
      CollectionReference cartRef = Firestore.instance.collection('owner').document(idUser).collection('cart');
      QuerySnapshot eventsQuery = await cartRef.getDocuments();

      String emailBuyer = buyerEmailController.text;
      for(DocumentSnapshot ds in eventsQuery.documents){
          int stokBeliCart=ds.data['qty'];
            // int sisa=stokBeliCart;

          Firestore.instance.collection('owner').document(idUser).collection('item').document(ds.data['id_item'].toString()).collection('supplier_sender').orderBy('time',descending: true).getDocuments().then((snapshot){

              int indexArr=0;
              var n = stokBeliCart;

              //mencari sampai dengan quantity cart sisa dengan 0;
              do {
            
                int total=snapshot.documents[indexArr].data['stok_tambah'];
                n = n - total; 
             
                if(snapshot.documents[indexArr].data.isNotEmpty){
                    if(n<=0){
                  n=n*-1;
                  //update quantity stok
                  //selesai
                   
                    try{
                      
                        Firestore.instance.collection('owner').document(idUser).collection('cart').document(ds.documentID).updateData({
                        'qty': 0
                        });

                        Firestore.instance.collection('owner').document(idUser).collection('item').document(ds.data['id_item'].toString()).collection('supplier_sender').document(snapshot.documents[indexArr].documentID).updateData({
                          'stok_tambah': n
                        });

                        
                    }catch(e){

                    }

                    try{
                        print("try Count Last Item");
                        String doc=snapshot.documents[0].data['id_item'];
                        int priceAkhir = snapshot.documents[indexArr].data['harga_beli'];
                        // print("harga beli Akhir${priceAkhir.toString()}");
                        // print("test snapshot idItem Bang:$doc ");
                        queryValues(doc,priceAkhir);
                    }catch(e){
                      print(e.toString());
                    }
                        
                }else{
                    try{

                        Firestore.instance.collection('owner').document(idUser).collection('cart').document(ds.documentID).updateData({
                        'qty': n
                      });

                      Firestore.instance.collection('owner').document(idUser).collection('item').document(ds.data['id_item'].toString()).collection('supplier_sender').document(snapshot.documents[indexArr].documentID).updateData({
                        'stok_tambah': 0
                      });
                    }catch(e){
                      print(e.toString());
                    }
               
                }
                print(n);
                     //update ke db cart quantity
                // print(total.toString());
                //getdocument baru
                indexArr=indexArr+1;
                }
              

              } while (n>=0);
            });

              Firestore.instance.collection("detail_transaksi").add({
                  'uid': idUser,
                  'email_buyer' : emailBuyer,
                  'id_header': idHeader,
                  'kd_item': ds.data['id_item'], 
                  'nama_item': ds.data['item_name'],
                  'qty_beli': ds.data['qty'],
                  'price_pcs': ds.data['price_pcs'],
                });
                
              ds.reference.delete();
         
            }
            
      testHeader=idHeader;

    }

    

  Widget itemCard(itemName, color, price, imgPath, available, i, DocumentSnapshot doc) {
    
    deleteCart(idCart) async{
      Firestore.instance.collection('owner').document(idUser).collection('cart').document(idCart).delete();

    }

    return InkWell(
      onTap: () {
        if (available) {
          // pickToggle(i);
        }
      },
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Material(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 3.0,
              child: Container(
                  padding: EdgeInsets.only(left: 15.0, right: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Row(
                    children: <Widget>[
                   
                      SizedBox(width: 10.0),
                      Container(
                        height: 100.0,
                        width: MediaQuery.of(context).size.width/4,
                        child: 
                        SizedBox(   
                          child: 
                        CachedNetworkImage(
                             placeholder: (context, url) => CircularProgressIndicator(),
                             imageUrl: doc.data['item_photo'],
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                )
                              ),
                              width: 20,
                              height: 20,
                            ),
                        ),
                        )

                      ),
           
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width/3,
                                height: 20,
                                child:  Text(
                                
                                doc.data['item_name'],
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    color: Colors.black54),
                              ),
                              ),
                              available
                                  ? picked[i]
                                      ? Text(
                                          'x1',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              color: Colors.grey),
                                        )
                                      : Container()
                                  : Container()
                            ],
                          ),
                          SizedBox(height: 7.0),
                          available
                              ? Text(
                                  'Quantity: ' + doc.data['qty'].toString(),
                                  style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black54),
                                )
                              : OutlineButton(
                                  onPressed: () {},
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                      style: BorderStyle.solid),
                                  child: Center(
                                    child: Text('Find Similar',
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                            color: Colors.red)),
                                  ),
                                ),
                          SizedBox(height: 7.0),
                          available
                              ? Text(
                                  '\Rp ' + doc.data['price_pcs'].toString(),
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.black54
                                      ),
                                )
                              : Container(),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width/4,
                            height: 100,
                              child: InkWell(
                                child:Icon(Icons.remove_shopping_cart,
                                ),
                                  onTap: (){
                                    print('delete');
                                    deleteCart(doc.documentID);
                                  },
                                ),
                              ),
                        ],
                      )
                    ],
                  )))),
    );
  }
}