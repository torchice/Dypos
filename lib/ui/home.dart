// import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ta_andypos/ui/item/tambahItem.dart';
import 'reviews.dart';
import 'item/master_item.dart';
// import 'package:ta_andypos/style/theme.dart' as Theme;
// import 'master_item.dart';
import 'drawerBar.dart';
import 'item/tambahItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'transaksi.dart';
// import 'package:barcode_scan/barcode_scan.dart';

class Home extends StatefulWidget {

  Widget build (BuildContext context){
    return MaterialApp(
      routes:  <String, WidgetBuilder>{
        '/tambahItem' :(BuildContext context) => new TambahItem(),
      },
    );
  }

  const Home({
    Key key,
    this.user}):super(key:key);
/*  final FirebaseUser user;*/
    final String user;
  @override

  _HomeState createState() => _HomeState();
  
  _HomeState initState() => _HomeState();

}

class _HomeState extends State<Home> {

  var reviews;
  String id;
  final db = Firestore.instance;
  // final _formKey = GlobalKey<FormState>();
  String name;
  bool reviewFlag = false;
  String _email;
  // String _uid;
  String idUser;
  String role;  
  
  Future<String> getIdUser(_email) async{
    print("sebelum ID User");
   print(_email);
   
    // ini untuk cari nilai dari doc ID login
    var userQuery = await db.collection('databaseLogin').where('email', isEqualTo: _email).getDocuments();

    if(userQuery.documents.isNotEmpty){

      print("Check New Module");
         idUser=userQuery.documents[0].data['uid'];
      print(idUser);
      return idUser;
    }else{
      print(idUser);
      return "empty";
    }
          
  }
  
  void checkDevice() async {
    print("check Device");
  final stream = NetworkAnalyzer.discover('192.168.137', 9100);

stream.listen((NetworkAddress addr) {
  if (addr.exists) {
      print('Found device: ${addr.ip}');
    }
  }).onDone(() => print('Finish'));

  }

  Future<String> getRole(_email) async{
   print("sebelum Role");
   print(_email);

    // ini untuk cari rolenya
    var userQuery = await db.collection('databaseLogin').where('email', isEqualTo: _email).getDocuments();

    if(userQuery.documents.isNotEmpty){

      print("Check New Module");
  
      role=userQuery.documents[0].data['role'];
  
      print(idUser);
      return idUser;
    }else{
      print(idUser);
      return "empty";
    }

  }

   _saveUid() async {
    print('async 1');
    // untuk load documentID email yang digunakan untuk login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = this.widget.user;
    await prefs.setString('email', _email);
    //uid adalah variabel dari PREFERENCE YANG AKAN DIGUNAKAN
    //_uid adalah inputan dari USER DOC ID YANG AKAN VALUENYA SESUAI DENGAN r YANG TELAH LOGIN
    print(this.widget.user);
    // var userQuery = await db.collection('owner').where('email', isEqualTo: this.widget.user).getDocuments();

    await getIdUser(_email);
    await getRole(_email);
    
    await prefs.setString('role', role); 
    prefs.setString('uid',idUser);

  }

  checkDevice2() async{
        print("check Device2");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"

// IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
// print('Running on ${iosInfo.utsname.machine}'); 
  }
   @override
  void initState(){
    _dataProcess();
  //  checkDevice2();
    checkDevice();
    
    super.initState();
    
    ReviewService()
      .getLatestReview('male')
      .then((QuerySnapshot docs){
      if(docs.documents.isNotEmpty){
        reviewFlag=true;
        reviews = docs.documents[0].data;
      }
    });
  }
  _dataProcess() async{
    await _saveUid();
    await _loadUid();
  }
  // SharedPreferences sp;
  //docID_user diubah menjadi idUser, case kalau sharedPreferences error
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
  


  Card buildItem(DocumentSnapshot doc){
    return Card(
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:45.0),
            Text(
              'name: ${doc.data['name']}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'todo: ${doc.data['todo']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height:12),
         
          ],
        ),
      ));
      }

  TextFormField buildTextFormField(){
      return TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Your Text",
          fillColor: Colors.grey[300],
          filled:true,
        )
        ,onSaved: (value) => name = value,
      );
    }

  Widget build2(BuildContext context){
    return Scaffold(
      body: SizedBox(
        child: Text('test'),
      )
    );
  }

  int _selectedIndex = 0;

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
  if(_selectedIndex==0){
    print('home');
  }else if(_selectedIndex==1){
    print('123');
       Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new ExampleScreen())
                );
    
  }else{
    print("321");
         Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new Transaksi())
                );
  }
}



  Widget build(BuildContext context) {
    
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
              backgroundColor: Colors.orangeAccent,
          title: Text('DYPOS POINT OF SALE',
          style: TextStyle(
            fontSize: 20,
          ),),
     ),body:Container(
       
    // Size screenSize = MediaQuery.of(context).size;
       child: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        //  mainAxisSize: MainAxisSize.min,r
         
         children: <Widget>[
           Padding(
             padding: const EdgeInsets.all(30.0),
             child: 
           Text("Welcome to DyPOS",
           style: TextStyle(
             fontSize: 30,
             color: Colors.blueAccent[200],
             fontFamily: "WorkSansBold",
           ),
           ),
           ),
          Text("Newest Item",
             style: TextStyle(
             fontSize: 20,
             fontFamily: "WorkSansMedium",
             color: Colors.red[200]
           ),
           ),
           Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(70),
                    width: screenSize.width/2,
                    height: screenSize.width/2,
                    child:     
                    StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance.collection('owner').document(idUser).collection('item').orderBy('time_added', descending:true).snapshots(),
                            builder: (context, snapshot){
                                if(!snapshot.hasData){return CircularProgressIndicator();}
                                if(snapshot.data.documents.length>0){
                                    return   CachedNetworkImage(
                                progressIndicatorBuilder: (context, url, progress) =>
                                    CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                                imageUrl:
                                    snapshot.data.documents[0].data["item_photo"],
                              );

                                  }else{
                                    return Container(
                                        child: new Image.asset('assets/item.png'),
                                        height: 60.0,
                                        
                                      );
                                  }
                              }
                            ),
                                  
                  ),
                  // Image.asset('assets/item.png'),
                 
                ],
              )


         ],
       ),
     ),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_input_component),
          title: Text('Item'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_travel),
          title: Text('Transaction'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    ),
      drawer: buildDrawer(context,idUser,_email,role)
    );
  }


}
