import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'updateSupplier.dart' as updatePage;
// import 'addSupplier.dart' as addPage;
// import 'show.dart' as showPage;
// import 'show.dart';
// import 'dart:async';
// import 'detailSupplier.dart';
// import 'insertRetur.dart';

class ShowTrans extends StatefulWidget {
  final Widget child;
  final String username;
   final TabController controller;
  ShowTrans({this.username,this.controller,this.child});

  @override
  _ShowTransState createState() => _ShowTransState();

  //  static _ShowPageState of(BuildContext context) {
  //   return (context.inheritFromWidgetOfExactType(MyInheritedWidget) as MyInheritedWidget).addres;
  // }
}

class _ShowTransState extends State<ShowTrans>{
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
  int total;
  bool match=false;

  void onMyFieldChange(String newValue) {
    setState(() {
      _myField = newValue;
    });
  }
  
  TextEditingController idTransText = new TextEditingController();

    _loadUid() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          idUser = (prefs.getString('uid')??'');
          _email = (prefs.getString('email')??'');
        });
    }
    _getStore() async{
      var userQuery = await db.collection('owner').where('email', isEqualTo: _email).getDocuments();
      // print("getStore");
      setState(() {
      storeName = userQuery.documents[0].data['store_name'];
      });
      // print();
    }

    @override
    void initState(){
      _loadUid();
      _getStore();
      // name="abc";
      // buildSupplier(context);
    
    super.initState();
    }

    void updateData(docID) async{
      
      Firestore.instance.collection('header_transaksi').document(docID).updateData({
        'berhasil': "false",
        'status_bayar': false
      });
      
      CollectionReference cartRef = Firestore.instance.collection('detail_transaksi');
      QuerySnapshot eventsQuery = await cartRef.getDocuments();
      int asd = eventsQuery.documents.length;
        
      for(var i = 0; i < asd; i++) {
        print(i);
        print(eventsQuery.documents[i].data['id_header']);
        print(docID);
        if(eventsQuery.documents[i].data['id_header']== docID){
            Firestore.instance.collection('detail_transaksi').document(eventsQuery.documents[i].documentID).updateData({
              'berhasil': "false",
              'status_bayar': false
              });
            }
        }
      }
      // String emailBuyer = buyerEmailController.text;
     

  void gotoDetail(context, docID){
     showDialog(
                                  context: context,
                                      builder: (BuildContext context2) {
                                      return AlertDialog(
                                          title: new Text('Action'),
                                          content: new Text('Cancel Transaction?'),  
                                          actions: <Widget>[
                                            SimpleDialogOption(
                                              onPressed:() {
                                                // print(docID);
                                                Navigator.pop(context2);
                                                // Navigator.pop(context);
                                                updateData(docID);
                                              },
                                              child: Text('Yes'),
                                              
                                            ),
                                             SimpleDialogOption(
                                              onPressed:() {
                                                Navigator.pop(context2);
                                              },
                                              child: Text('NO'),
                                              
                                            ),
                                            // buildSupplier(context),
                                        
                                          ],

                                        );
                                      }
                                  );
  }

    void doesntFound(){
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
                                                Navigator.pop(context);
                                              },
                                              child: Text('Yes'),
                                            ),
                                          ],

                                        );
                                      }
                                  );
  }

    void deleteData(String idUser, String docID) async{
      await Firestore.instance.collection('owner').document(idUser).collection('supplier').document(docID).delete();
    }

    void applyHeader() async{
        CollectionReference cartRef = Firestore.instance.collection('header_transaksi');
        QuerySnapshot eventsQuery = await cartRef.getDocuments();

        for(DocumentSnapshot ds in eventsQuery.documents){
          print(idTransText.text);
          print(ds.data['id_header']);
          if(ds.data['id_header']==idTransText.text){
            print("ketemu");
            gotoDetail(context, ds.data['id_header']);
            match=true;
              //  Navigator.push(context, new MaterialPageRoute(
              //       builder: (context) =>
                    
              //       // InsertRetur(
              //       //   idHeaderTrans: ds.data['id_header'],
              //       // ))
              //   );
          }
        }
        if(match==false){
          doesntFound();
        }    
  }

    // void _goUpdate(){

    // }
  

  Widget body(context){
    
        return StreamBuilder<QuerySnapshot>(
          stream:  Firestore.instance
          .collection("header_transaksi").where('uid', isEqualTo: idUser).snapshots(),
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
                                        "ID Transaksi :${snapshot.data.documents[index].documentID}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: (){
                                        gotoDetail(
                                          context,
                                          snapshot.data.documents[index].documentID,
                                          
                                        );
                                      },
                                      subtitle:
                                        // Text("Nama: ${snapshot.data.documents[index].data['nama_member']}"),
                                        snapshot.data.documents[index].data['status_bayar'] ?
                                         Text("Sucess"): Text("Fail")
                                    
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
            child: body(context),
          )
          ])
      
    );

  }
}
