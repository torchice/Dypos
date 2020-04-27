import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ta_andypos/components/TextFields/inputField.dart';
// import 'updateSupplier.dart' as updatePage;
// import 'addSupplier.dart' as addPage;
// import 'showSupplier.dart' as showPage;
// import 'dart:async';
// import 'detailSupplier.dart';
import 'insertRetur.dart';

class ShowPage extends StatefulWidget {
  final Widget child;
  final String username;
   final TabController controller;
  ShowPage({this.username,this.controller,this.child});

  @override
  _ShowPageState createState() => _ShowPageState();

  //  static _ShowPageState of(BuildContext context) {
  //   return (context.inheritFromWidgetOfExactType(MyInheritedWidget) as MyInheritedWidget).addres;
  // }
}

class _ShowPageState extends State<ShowPage>{
  // MyInheritedWidget dataInherit;
      
      String idUser;
      String name;
      String addres,phone;
      TabController controller;
      bool matched=false;

    
  TextEditingController idTransText = new TextEditingController();
  String _myField;
  String get myField =>_myField;

  void onMyFieldChange(String newValue) {
    setState(() {
      _myField = newValue;
    });
  }

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
                        content: new Text('Retur this transaction?'),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                            SimpleDialogOption(
                              onPressed: () {  
                                    // deleteData(idUser, docID);
                                          Navigator.pop(context);
                                     Navigator.push(context, MaterialPageRoute
                                                  (builder: 
                                                    (context) => InsertRetur(
                                                      idHeaderTrans:docID ,
                                                      nameBuyer: name,
                                                    )
                                                  )
                                                );
                              
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

  void gotoDetail(name,phone,address,docID){
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
                                                // Navigator.push(context, MaterialPageRoute
                                                //   (builder: 
                                                //     (context) => DetailSupplier(
                                                //       nama: name,
                                                //       phone: phone,
                                                //       alamat: address,
                                                //       idItem: docID,
                                                //     )
                                                //   )
                                                // );
                                                // this.widget.controller.animateTo(
                                                //   this.widget.controller.index + 1,
                                                // ); 
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
  itemCard(idHeader,namaMember){
    return InkWell(
      child: Padding(
         padding: EdgeInsets.all(10.0),
          child: Material(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 3.0,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Text(idHeader)
                    ,
                    Text(namaMember)
                  ],
                ),
              )
            )
          ),
    );
  }

  // Widget _buildShowSupplier(BuildContext context, List<DocumentSnapshot> snapshot){
  
  // }

    void doesntFound(context){
      print("doesnt");
     showDialog(
                                  context: context,
                                      builder: (BuildContext context2) {
                                      return AlertDialog(
                                          title: new Text('Error'),
                                          content: new Text('ID Document doesnt exist'),  
                                          actions: <Widget>[
                                            SimpleDialogOption(
                                              onPressed:() {
                                                // print(docID);
                                                Navigator.pop(context2);
                                              },
                                              child: Text('Yes'),
                                            ),
                                          ],

                                        );
                                      }
                                  );
  }


//context yang di parse adalah punya child yang dinitstate untuk nampilin widget,diperlukan biar gak  State waktu snackBar
//context2/c yang ada adalah context dr builder yang dibikin
  void applyHeader() async{
        CollectionReference cartRef = Firestore.instance.collection('header_transaksi');
        QuerySnapshot eventsQuery = await cartRef.getDocuments();

        for(DocumentSnapshot ds in eventsQuery.documents){
          print(idTransText.text);
          print(ds.data['id_header']);
          if(ds.data['id_header']==idTransText.text){
            print("ketemu");
            matched=true;
               Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    InsertRetur(
                      idHeaderTrans: ds.data['id_header'],
                      nameBuyer: ds.data['nama_member'],
                    ))
                );
          }

        }
      print(matched);
        if(matched==false){
          doesntFound(context);
        }    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: <Widget>[
          TextFormField(
            controller: idTransText,
            decoration: InputDecoration(
              hintText: "   ID Header Trans"
            ),
          ),
          RaisedButton(
            color: Colors.orangeAccent,
            child: Text(
              'Apply'
            ),
            textColor: Colors.white,
            onPressed: (){
              applyHeader();
            },
          ),
          Flexible(
            child: StreamBuilder(
                stream: Firestore.instance.collection('header_transaksi').where('uid', isEqualTo: idUser).snapshots(),
                builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData) return const Text('loading..');
                      final int cardLength = snapshot.data.documents.length;
                      return new ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      itemCount: cardLength,
                      itemBuilder: (context, int index) {
                        final DocumentSnapshot _card= snapshot.data.documents[index];
                        return InkWell(
                          child:     
                            ListTile(
                            title: new Text("ID Header : ${_card['id_header']}"),
                            subtitle: new Text("Nama Buyer: ${_card['nama_member']}"),
                            ),
                            onTap: (){
                            },
                        ); 
                      },
                    ); 
                }
            ),
          )
        ],
      )
      
    );

  }
}
