import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'updateSupplier.dart' as updatePage;
// import 'addSupplier.dart' as addPage;
// import 'showSupplier.dart' as showPage;
// import 'dart:async';
// import 'detailSupplier.dart';
import 'detailPromo.dart';

class ShowPage extends StatefulWidget {
  final Widget child;
  final String username;
   final TabController controller;
  ShowPage({this.username,this.controller,this.child});

  @override
  _ShowPageState createState() => _ShowPageState();

}


class _ShowPageState extends State<ShowPage>{

      String idUser;
      String name;
      String addres,phone;
      TabController controller;


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

    void confirmationDelete(context,docID){
        showDialog(
                    context: context,
                    builder: (BuildContext context2) {
                      // return object of type Dialog
                      // var option = await AlertDialog()
                      return AlertDialog(
                        title: new Text('Confirmation'),
                        content: new Text('Are you sure delete this Promo?'),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                            SimpleDialogOption(
                              onPressed: () {  
                                    deleteData(idUser, docID);
                                    Navigator.pop(context2);
                              },       
                                child: const Text('Delete'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {  
                                Navigator.pop(context2);
                                },
                                child: const Text('Cancel'),
                            )
                          ]
                        );
                      }
          );
  }

  void gotoDetail(name,code,dateEnd,docID,context){
     showDialog(
                                  context: context,
                                      builder: (BuildContext context2) {
                                      return AlertDialog(
                                          title: new Text('Action'),
                                          content: new Text('confirmation'),  
                                          actions: <Widget>[
                                            SimpleDialogOption(
                                              onPressed:() {
                                                  Navigator.pop(context2);
                                                  Navigator.push(context, MaterialPageRoute
                                                  (builder: 
                                                    (context) => DetailPromo(
                                                    nama: name,
                                                    code: code,
                                                    date: dateEnd,
                                                    
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
                                                Navigator.pop(context2);
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
      await Firestore.instance.collection('owner').document(idUser).collection('promo').document(docID).delete();
    }

    // void _goUpdate(){

    // }
  

  Widget body(context){ 
        return StreamBuilder<QuerySnapshot>(
          stream:  Firestore.instance
          .collection("owner")
          .document(idUser).collection('promo').snapshots(),
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
                                        snapshot.data.documents[index].data['promo_name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: (){
                                        gotoDetail(
                                          snapshot.data.documents[index].data['promo_name'],
                                          snapshot.data.documents[index].data['promo_code'],
                                          snapshot.data.documents[index].data['promo_endDate'],
                    
                                            snapshot.data.documents[index].documentID,
                                            context2
                                          );
                                      },
                                      subtitle:
                                        Text("Waktu Berakhir: ${snapshot.data.documents[index].data['promo_endDate']}"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Builder(
        builder: (context) => body(context)
      ),
      
    );

  }
}
