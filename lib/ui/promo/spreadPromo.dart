import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'updateSupplier.dart' as updatePage;
// import 'addSupplier.dart' as addPage;
// import 'show.dart' as showPage;
// import 'detailMember.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import '../home.dart';
import 'package:ta_andypos/style/theme.dart' as Theme;
// import 'dart:async';
// import 'detailSupplier.dart';
// import 'insertRetur.dart';

class SpreadPromo extends StatefulWidget {
  final Widget child;
  final String username;
  final String promoCode;
   final TabController controller;
  SpreadPromo({this.username,this.controller,this.child,this.promoCode});

  @override
  _SpreadPromoState createState() => _SpreadPromoState();

  //  static _ShowPageState of(BuildContext context) {
  //   return (context.inheritFromWidgetOfExactType(MyInheritedWidget) as MyInheritedWidget).addres;
  // }
}

class _SpreadPromoState extends State<SpreadPromo>{
  // MyInheritedWidget dataInherit;
  final db=Firestore.instance;
      
      String idUser;
      String name;
      String addres,phone;
      TabController controller;
  
  String _myField;
  String get myField =>_myField;
  String _email;
  String storeName;
  void onMyFieldChange(String newValue) {
    setState(() {
      _myField = newValue;
    });
  }

  _loadUid() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        idUser = (prefs.getString('uid')??'');
        _email = (prefs.getString('email')??'');
      });
  }
  _getStore() async{
    Firestore.instance.collection('owner').getDocuments().then((snapshot){
      snapshot.documents.forEach(
        (f) {
          if(f.documentID==idUser){
            setState(() {
             storeName = f.data['store_name'];
            });
          }
        }
  
        );
      // snapshot.documents[idUser].data[]
    });

    //  var userQuery = await db.collection('owner').where('email', isEqualTo: _email).getDocuments();
    // // print("getStore");
    // setState(() {
    //  storeName = userQuery.documents[0].data['store_name'];
    // });
    // print(_email);
    // // print();
    // print(storeName);
  }
  @override
  void initState(){
    _loadUid();
    _getStore();
    // name="abc";
    // buildSupplier(context);
   
   super.initState();
  }

    void confirmationDelete(context,docID,name){
        showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      // var option = await AlertDialog()
                      return AlertDialog(
                        title: new Text('Confirmation'),
                        content: new Text('Detail Member'),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                            SimpleDialogOption(
                              onPressed: () {  
                                    // deleteData(idUser, docID);
                                    Navigator.pop(context);
                                    // Navigator.push(context, MaterialPageRoute
                                    //               (builder: 
                                    //                 (context) => DetailMember(
                                    //                   idHeaderTrans:docID ,
                                    //                   nameBuyer: name,
                                    //                 )
                                    //               )
                                    //             );
                              
                              },       
                                child: const Text('Yes'),
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

  void gotoDetail(){
     showDialog(
                                  context: context,
                                      builder: (BuildContext context2) {
                                      return AlertDialog(
                                          title: new Text('Action'),
                                          content: new Text('confirmation'),  
                                          actions: <Widget>[
                                            SimpleDialogOption(
                                              onPressed:() {
                                                Navigator.pop(context);
                                   
                                              },
                                              child: Text('Retur'),
                                              
                                            ),
                                             SimpleDialogOption(
                                              onPressed:() {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                              
                                            ),
                                            // buildSupplier(context),
                                        
                                          ],

                                        );
                                      }
                                  );
  }

    void deleteData(String idUser, String docID) async{
      await Firestore.instance.collection('owner').document(idUser).collection('supplier').document(docID).delete();
    }

    // void _goUpdate(){

    // }
  

  Widget body(context){
        return StreamBuilder<QuerySnapshot>(
          stream:  Firestore.instance
          .collection("header_transaksi").where('uid',isEqualTo: idUser).snapshots(),
            builder: (context, snapshot) {
              // MyInheritedWidget.of(context).name= snapshot.data.documents[index].data['supplier_name'];
              // dataInherit.addres
              if (snapshot?.data == null) return Text("Loading");
                    return ListView.builder(
                    itemBuilder: (BuildContext context2, int index) => 
                    Card(
                          elevation: 2.0,
                          child:
                          InkWell(
                              child: ListTile(
                                      title: Text(
                                        "Email:${snapshot.data.documents[index].data['email_member']}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: (){
                                        // gotoDetail(
                                        //   snapshot.data.documents[index].data['promo_name'],
                                        //   snapshot.data.documents[index].data['promo_code'],
                                        //   snapshot.data.documents[index].data['promo_endDate'],
                    
                                        //     snapshot.data.documents[index].documentID
                                        //   );
                                      },
                                      subtitle:
                                        // Text("Nama: ${snapshot.data.documents[index].data['nama_member']}"),
                                        RaisedButton(
                                          onPressed: (){
                                            
                                              FlutterMailer.send( 
                                              MailOptions(
                                                body: '$storeName : Use Code ${this.widget.promoCode} and get 10% off on your next purchase with no min purchase and 15% with 10 pcs min purchase',
                                                subject: '$storeName PROMO',
                                                
                                                recipients: [snapshot.data.documents[index].data['email_member']],
                                                isHTML: true,
                                                // bccRecipients: [_email],
                                                // ccRecipients: [_email],
                                              )
                                            );
                                          },
                                          child: Text('Send PROMO'),
                                        )
                                    
                                        // trailing: Text(snapshot.data.documents[index].data['supplier_address']),
                                    ),
                                    
                          ),
                        ),
                        
                    itemCount:snapshot.data.documents.length,
                  );
            },
          );
  }

  // Widget _buildShowSupplier(BuildContext context, List<DocumentSnapshot> snapshot){
  
  // }



//context yang di parse adalah punya child yang dinitstate untuk nampilin widget,diperlukan biar gak  State waktu snackBar
//context2/c yang ada adalah context dr builder yang dibikin


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Builder(
        builder: (context) => body(context)
      ),appBar: new AppBar(
          actions: <Widget>[
            
          ],
        title: 
        InkWell(
          child:  new Text('List Member'),
          onTap:(){
              Navigator.push(
                  context,
                MaterialPageRoute(builder: (context) => Home(user: _email)) ,
              );
          }
        ),    
        backgroundColor: Theme.Colors.loginGradientStart,
      
      ),
      
    );

  }
}
