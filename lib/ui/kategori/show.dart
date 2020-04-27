import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'updateSupplier.dart' as updatePage;
// import 'addSupplier.dart' as addPage;
// import 'showSupplier.dart' as showPage;
// import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'detail.dart';

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

  // void confirmationDelete(){
  //       SimpleDialogOption(
  //                                               onPressed:(){
  //                                                 Navigator.pop(context);
  //                                                 // ketika menampilkan snackBar maka buildContext yang ditampilkan kadang ada error
  //                                                 // pas bolak balik modul. sepertinya karena BuildContext context, yang diparse 
  //                                                 // tercampur ama home
  //                                                   final snackBar = SnackBar(
  //                                                   content: Text('Confirmation'),
  //                                                   action: SnackBarAction(
  //                                                     label: 'Delete',
  //                                                     onPressed: () {
  //                                                       // deleteData(idUser,snapshot.data.documents[index].documentID);
  //                                                     },
  //                                                   ),
  //                                                 );
  //                                                 Scaffold.of(context).showSnackBar(snackBar);
  //                                               },
  //                                             child: Text('Delete'),
  //                                           );
  // }


    void confirmationDelete(context,docID){
        showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      // var option = await AlertDialog()
                      return AlertDialog(
                        title: new Text('Confirmation'),
                        content: new Text('Are you sure delete this Category?'),
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

  void gotoDetail(name,status,docID){
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
                                                Navigator.push(context, MaterialPageRoute
                                                  (builder: 
                                                    (context) => DetailSupplier(
                                                      nama: name,
                                                      status: status,
                                                 
                                                      idICategory: docID,
                                                    )
                                                  )
                                                );
                                                // this.widget.controller.animateTo(
                                                //   this.widget.controller.index + 1,
                                                // ); 
                                              },
                                              child: Text('Detail'),
                                              
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
      await Firestore.instance.collection('owner').document(idUser).collection('category').document(docID).delete();
    }

    // void _goUpdate(){

    // }
    void showDemoDialog({BuildContext context, Widget child}) {

    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        // setState(() { lastSelectedValue = value; });
      }
    });

  }

  // void deleteData(String idUser, String docID) async{
  //     await Firestore.instance.collection('owner').document(idUser).collection('item').document(docID).delete();
  //   }

    // void updateData(DocumentSnapshot doc) async{
    //   await db.collection('mahasiswa').document(doc.documentID).updateData({'todo' : 'Updated!'});
    // }

    void deactiveData(String idUser, String docID) async{
      print(docID);
      await Firestore.instance.collection('owner').document(idUser).collection('category').document(docID).updateData({
        'status_aktif':false
        }
      );
    }

  void activeData(String idUser, String docID) async{
      await Firestore.instance.collection('owner').document(idUser).collection('category').document(docID).updateData({
        'status_aktif':true
        }
      );
    }


    Widget buildCupertinoDialog(context2, available,docID) {
    return CupertinoAlertDialog(
      actions: <Widget>[
        available ?
        CupertinoDialogAction(
          child: Text('Deactive Category'), 
          onPressed: () {
            Navigator.pop(context2, 'Deactive Category');
            // setPayment('debit');
            
                  deactiveData(idUser,docID);
                  
                  // Scaffold.of(context).showSnackBar(snackBar);  
          },
        ): 

        CupertinoDialogAction(
          child: Text('Active Category'), 
          onPressed: () {
            Navigator.pop(context2, 'Active Category');
            // setPayment('debit');
                  final snackBar = SnackBar(
                        content: Text(
                            'Category Activated',
                            style: TextStyle(
                              color: Colors.lightGreen,
                             decorationColor: Colors.white
                            ),
                        ),
                        backgroundColor: Colors.black54,
                  );
             
                  activeData(idUser,docID);
                  Scaffold.of(context).showSnackBar(snackBar);  
          },
        )
        ,
        CupertinoDialogAction(
          child: const Text('Delete Item'),
          onPressed: () {
            Navigator.pop(context2, 'Delete Item');
                // setPayment('credit');
                deleteData(idUser, docID);
                  final snackBar = SnackBar(
                        content: Text(
                            'Item Deleted',
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
  

  Widget body(context){ 
        return StreamBuilder<QuerySnapshot>(
          stream:  Firestore.instance
          .collection("owner")
          .document(idUser).collection('category').snapshots(),
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
                                        // snapshot.toString(),
                                        "Category Name: ${snapshot.data.documents[index].data['value']}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: (){
                                        gotoDetail(
                                          snapshot.data.documents[index].data['value'],
                                          snapshot.data.documents[index].data['status_aktif'],
        
                                            snapshot.data.documents[index].documentID
                                          );
                                      },
                                      subtitle:
                                      snapshot.data.documents[index].data['status_aktif'] ? 
                                        Text("Aktif")
                                        :
                                        Text("Tidak Aktif")
                                        ,
                                        trailing: 
                                        InkWell(
                                          child:
                                            Icon(Icons.settings),
                                          onTap:(){
                                              showDemoDialog(
                                                context: context,
                                                child:  buildCupertinoDialog(
                                                context,  snapshot.data.documents[index].data['status_aktif'],
                                                     snapshot.data.documents[index].documentID
                                                ),
                                              );
                                          }
                                        ),
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
