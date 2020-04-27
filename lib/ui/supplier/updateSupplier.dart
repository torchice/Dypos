import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'showSupplier.dart';


class UpdatePage extends StatefulWidget {
  final String name;
  final String address,phone;
  final TabController controller;
  // final AppState state;
  
  UpdatePage({this.name,this.controller,this.address,this.phone});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage>{
    //  final MyInheritedWidget model = MyInheritedWidget;
  String idUser;
  String cek;

  // Appstate state;
  
  // static final _myTabbedPageKey = new GlobalKey<_UpdatePageState>();
  TabController _tabController;
    final GlobalKey<FormState> _formKeyUpdateSupplier = new GlobalKey<FormState>();
  @override
  void initState(){
    // _loadUid();
    // name="abc";
    // buildSupplier(context);
  
   super.initState();
  }
  Widget body(){
     return new StreamBuilder(
      stream: Firestore.instance.collection("friendship").where("id_friendship", isEqualTo: idUser).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return new Padding(
            padding: EdgeInsets.only(top: 50.0),
            child:Center(
              child: new CircularProgressIndicator(),
            )
          );
        }
        if(snapshot.hasData && snapshot.data.documents.isNotEmpty){
          return new Scaffold(
            body : new ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int i){
                return new StreamBuilder(
                  stream: Firestore.instance.collection("user").where("username", isEqualTo: snapshot.data.documents[i].data["friends_id"]).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> dtlSnapshot){
                    if(dtlSnapshot.hasData){
                      return new ListTile(
                        leading: new CircleAvatar(
                          backgroundImage: dtlSnapshot.data.documents[0].data["userpic"] == null || dtlSnapshot.data.documents[0].data["userpic"] == ""?
                          new AssetImage("assets/person.png") : new NetworkImage(dtlSnapshot.data.documents[0].data["userpic"]),
                        ),
                        title: new Text(dtlSnapshot.data.documents[0].data["fullname"]),
                      );
                    }else{
                      return new Container(
                        height: 0.0,
                        width: 0.0,
                      );
                    }
                  }
                );
              }
            ),  
            floatingActionButton: new FloatingActionButton(
              onPressed: (){
            
              },
              child: Icon(Icons.person_add),
            ),
            key: _formKeyUpdateSupplier,       
          );
        }else{
          return new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text("Update"),
                new MaterialButton(
                  child: new Text("Add New Friend", style: new TextStyle(color: Colors.white),),
                  color: Colors.lightBlue,
                  onPressed: (){
                           _tabController.animateTo((_tabController.index + 1) % 2);
                  }
                ),
             
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    // print(model.name);
    // print("test");
    // print(test);
    return Container(
      child: body(),
    );
  }
}
// new SingleChildScrollView(
//           child: new Container(
//             padding: new EdgeInsets.all(15.0),
//             decoration: new BoxDecoration(
//                 image: backgroundImage,
//                 gradient: new LinearGradient(
//                     colors: [
//                       Theme.Colors.loginGradientStart,
//                       Theme.Colors.loginGradientEnd],
//                     begin: const FractionalOffset(0.0, 0.0),
//                     end: const FractionalOffset(1.0, 1.0),
//                     stops: [0.0, 1.0],
//                     tileMode: TileMode.clamp)
//             ),
//             child: new Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 new SizedBox(
//                     height: screenSize.height / 3,
//                     child: new Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         new Text(
//                           "Master Supplier",
//                           textAlign: TextAlign.center,
//                           style: headingStyle,
//                         )
//                       ],
//                     )),
//                 new SizedBox(
//                   height: screenSize.height,
//                   child: new Column(
//                     children: <Widget>[
//                       new Form(
//                         //onWillPop: _warnUserAboutInvalidData,
//                           child: new Column(
//                             children: <Widget>[
//                               new InputField(
//                                 controllerFunction: supplierNameController,
//                                 hintText: "Supplier Name",
//                                 obscureText: false,
//                                 textInputType: TextInputType.text,
//                                 textStyle: textStyle,
//                                 textFieldColor: textFieldColor,
//                                 icon: Icons.people,
//                                 iconColor: Colors.white,
//                                 bottomMargin: 10.0,
//                               ),
//                               Row(
//                                 children: <Widget>[
//                                   Expanded(
//                                     child: TextField(
//                                       decoration: InputDecoration(
//                                         icon: Icon(
//                                           FontAwesomeIcons.calendar,
//                                           size: 22.0,
//                                           color: Color.fromARGB(255, 255, 255, 255),
//                                         ),
//                                         enabled: false,
//                                         hintText: 'Category',
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: buildDropDown(context),
//                                   )
//                                 ],
//                               ),
//                               new InputField(
//                                 hintText: "Address",
//                                 obscureText: false,
//                                 textInputType: TextInputType.text,
//                                 textStyle: textStyle,
//                                 textFieldColor: textFieldColor,
//                                 icon: Icons.people,
//                                 iconColor: Colors.white,
//                                 bottomMargin: 10.0,
//                                 controllerFunction: supplierAddressController
//                               ),
//                               new InputField(
//                                 hintText: "Phone Number",
//                                 obscureText: false,
//                                 textInputType: TextInputType.phone,
//                                 textStyle: textStyle,
//                                 textFieldColor: textFieldColor,
//                                 icon: Icons.phone,
//                                 iconColor: Colors.white,
//                                 bottomMargin: 40.0,
//                                 controllerFunction: supplierPhoneController,
//                               ),
//                               new RaisedButton(
//                                 child: Text('Next'),
//                                 onPressed: () => createData(),
//                               ),
//                             ],
//                           )),

//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         )