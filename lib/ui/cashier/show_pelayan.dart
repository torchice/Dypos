import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_pelayan.dart';
// import 'updateSupplier.dart' as updatePage;
// import 'addSupplier.dart' as addPage;
// import 'showSupplier.dart' as showPage;
// import 'dart:async';
// import 'detailSupplier.dart';

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

class MyInheritedWidget extends InheritedWidget {
  // final MyInheritedState data;
  final String name,addres,phone;
  final String idUser;
  final TabController controller;
  
  // final CollectionReference fs=Firestore.instance
  //         .collection("owner")
  //         .document(idUser).collection('supplier');

  MyInheritedWidget({
    @required this.name,this.addres,this.phone, this.controller, Widget child,this.idUser
  }) : super(child:child);

  
  @override
  bool updateShouldNotify(MyInheritedWidget old) => true;
  // @override 
  // bool updateShouldNotify(MyInheritedWidget old){
  //     return name != old.name;
  
  // }
  // static MyInheritedWidget of(BuildContext context) => context.inheritFromWidgetOfExactType(MyInheritedWidget);

}

// class SupplierData {
//   String name,address,phone;

  
//   final StreamController _streamController = StreamController.broadcast();

//   Stream get stream => _streamController.stream;

//   Sink get sink => _streamController.sink;
// }

// class InheritedStateContainer extends InheritedWidget{
//   final StateContainerState data;

//   InheritedStateContainer({
//     Key key,
//     @required this.data,
//     @required Widget child,
//   }) : super(key: key, child: child);

//   @override
// //   bool updateShouldNotify(InheritedStateContainer old)=> true;
// // }
// class dataUpdate
// {
//   final InheritedWidget test;
//   dataUpdate(this.test);
// }

// class SupplierDetails{
//   final String name,address,phone,idUser;

//   SupplierDetails.fromMap(Map<String, dynamic> map)
//   : assert(map['supplier_name'] !=null),
//     assert(map['supplier_address'] !=null),
//     assert(map['supplier_phone'] !=null),
//     assert(map['supplier_name'] !=null),
//     name= map['supplier_name'],
//     address= map['supplier_address'],
//     phone= map['supplier_phone'],
//     idUser= map['supplier_name'];

//     SupplierDetails.fromSnapshot(DocumentSnapshot snapshot) :this.fromMap(snapshot.data);
// }

// class SupplierCard extends StatelessWidget{
//   final SupplierDetails supplierDetails;

//   SupplierCard({this.supplierDetails});

//   @override

//   Widget build(BuildContext context){
     
//   }
// }

class _ShowPageState extends State<ShowPage>{
  // MyInheritedWidget dataInherit;
      
      String idUser;
      String name;
      String addres,phone;
      TabController controller;
      // String _email;
  
  String _myField;
  String get myField =>_myField;

  void onMyFieldChange(String newValue) {
    setState(() {
      _myField = newValue;
    });
  }
  
  // static _ShowPageState of(BuildContext context) {
  //   return (context.inheritFromWidgetOfExactType(MyInheritedWidget)
  //           as MyInheritedWidget)
  //       .addres;
  // }

    // static final _showSupplierKey = new GlobalKey<_ShowPageState>();
  

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

  void gotoDetail(_email,name,password,docID){
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
                                                    (context) => DetailCashier(
                                                      emailCashier: _email,
                                                      name: name,
                                                      passwordCashier: password,
                                                      idItem: docID,
                                                    )
                                                  )
                                                );
                                                this.widget.controller.animateTo(
                                                  this.widget.controller.index + 1,
                                                ); 
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
      await Firestore.instance.collection('owner').document(idUser).collection('supplier').document(docID).delete();
    }

    // void _goUpdate(){

    // }
  

  Widget body(context){ 
        return StreamBuilder<QuerySnapshot>(
          stream:  Firestore.instance
          .collection("owner")
          .document(idUser).collection('cashier').snapshots(),
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
                                        snapshot.data.documents[index].data['cashier_email'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: (){
                                        gotoDetail(
                                          snapshot.data.documents[index].data['cashier_email'],
                                          snapshot.data.documents[index].data['cashier_name'],
                                            snapshot.data.documents[index].data['cashier_password'],
                                            snapshot.data.documents[index].documentID
                                          );
                                      },
                                      subtitle:
                                        
                                        Text( snapshot.data.documents[index].data['cashier_name']),
                                        trailing: 
                                        InkWell(
                                          child:
                                            Icon(Icons.delete_forever),
                                          onTap:(){
                                            confirmationDelete(context, snapshot.data.documents[index].documentID);
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
