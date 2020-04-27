import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as prefix0;
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:ta_andypos/style/theme.dart' as Theme;
import 'package:ta_andypos/components/TextFields/inputField.dart';
// import 'package:ta_andypos/theme/style.dart';
import 'home.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'drawerBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'master_item.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:image/image.dart';

void main() => runApp(EditStorePage());

class EditStore extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add New Item',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes:  <String, WidgetBuilder>{
      },
      home: EditStorePage(),
    );
  }
}

File image;
String filename;

class RIKeys {
  static final riKey1 = const Key('rikey1');
  static final riKey2 = const Key('rikey2');
  static final riKey3 = const Key('rikey3');
}

class EditStorePage extends StatefulWidget {
  // final FirebaseUser emailReg;

  final String email,passwordValue;
  final TabController controller;
  final String fileImageValue;
  EditStorePage({Key key, this.email, this.passwordValue,this.controller,this.fileImageValue}) : super(key: key);

  @override
  _EditStorePageState createState() => _EditStorePageState();

}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/img/login_logo.png'),
  fit: BoxFit.cover,
);

TextStyle headingStyle = new TextStyle(
  color: Colors.white,
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

class _EditStorePageState extends State<EditStorePage>
{
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String _name,_gambar;
  String _address,_owner,_phone;
  String dropdownValue;
  final db = Firestore.instance;
  String id;
  String idUser;
  String _email;
  bool updateCheck=false;
  String role;
  bool autoValidate=false;
  bool emailExist=false;

  Card buildItem(BuildContext context ,DocumentSnapshot doc){
    return Card(
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:20.0),
            SizedBox(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                          this.widget.fileImageValue == "" ?
                            Container(
                              child: new Image.asset('assets/person.png'),
                              height: 60.0,
                            )
                            :
                            CachedNetworkImage(
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  imageUrl:this.widget.fileImageValue,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                      ),
                                    ),
                                    height: 200,
                                    width: 200,
                                  )),
                                  SizedBox(
                                    height: 10,
                                  ),
                            
                    image == null ? 
                              Text('Select Image')
                              :uploadArea(),
                                SizedBox(height: 20,),
                                InputField(
                                controllerFunction: storeNameController,
                                hintText: "Store Name: ${doc.data['store_name']} ",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                enabled: updateCheck,
                                icon: Icons.store,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
              ),
                     InputField(
                                controllerFunction: storeAddressController,
                                hintText: "Store Address: ${doc.data['store_address']}",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                   enabled: updateCheck,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.edit_location,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
            ),
                     InputField(
                                // controllerFunction: itemNameController,
                                hintText: "Store Type: ${doc.data['store_type']}",
                                obscureText: false,
                                textInputType: TextInputType.text,

                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                enabled: false,
                                icon: Icons.dashboard,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
            ),
                     InputField(
                                controllerFunction: storeOwnerController,
                                hintText: "Store Owner: ${doc.data['store_owner']}",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                   enabled: updateCheck,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.people,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
            ),
                     InputField(
                                controllerFunction: storePhoneController,
                                hintText: "Store Phone: ${doc.data['store_phone']}",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                   enabled: updateCheck,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.phone,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
              ),
                new RaisedButton(
                                  child:
                                  Text('Update'),
                                  onPressed: (){
                                      updateData(context,doc.documentID);
                                  }                               
                                ),
                                //       new RaisedButton(
                                //   child:
                                //   Text('Delete'),
                                //   onPressed: (){
                                //        deleteData();
                                //   }                               
                                // ),
                                // new SwitchListTile(value: _enabled, onChanged: (bool value){
                                //   setState(){
                                //     _enabled=value;
                                //   }
                                // })
                ],
              ),
              
            ),
          ],
        ),
      ));
      }

  @override
  void initState(){
   
    _loadUid();
     super.initState();
  }
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

  TextEditingController storeNameController = new TextEditingController();
  TextEditingController storeAddressController = new TextEditingController(); 
  TextEditingController storeOwnerController = new TextEditingController();
  TextEditingController storePhoneController = new TextEditingController();
  // TextEditingController storeTypeController = new TextEditingController();

  final FocusNode myFocusNodeStoreName = FocusNode();
  final FocusNode myFocusNodeCategory = FocusNode();
  final FocusNode myFocusNodeOwner = FocusNode();
  final FocusNode myFocusNodeAddress = FocusNode();
  final FocusNode myFocusNodePhone = FocusNode();

  
 Future _getImage() async{
    var selectedImage =  await ImagePicker.pickImage(source: ImageSource.gallery);
    setState((){
      image=selectedImage;
      filename=basename(image.path);
      print("path");
      print(image.path);
      print(filename);
    });
  }

  Widget uploadArea(){
    return Column(
      children: <Widget>[
        Text(
          'New Photo'
        ),
        Image.file(image, width:300, height: 200,),
      ],
    );
  }

  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
             Align(
            alignment: Alignment.center,
            child:
              InkWell(
                child:
                Icon(
                  Icons.update,
                  size:30.0,
                ),
                onTap: (){
                  setState(() {
                    if(updateCheck==false){
                      updateCheck=true;
                    }else{
                      updateCheck=false;
                    }
                  });
                },
              ),
          
          ),
        ],
        title: 
        InkWell(
          child:  
            new Text('Store Info'),
          onTap:(){
            image=null;
            filename=null;
              Navigator.push(
                  context,
                MaterialPageRoute(builder: (context) => Home(user: _email)) ,
              );
          }
        ),
         backgroundColor: Colors.orangeAccent,
      ),
      //  appBar: AppBar(
        key: RIKeys.riKey2,
        drawer: buildDrawer(context,idUser,_email,role),
        body: 
        ListView(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
            stream: db.collection('owner').where('email', isEqualTo: _email).snapshots(),
            builder: (context, snapshot){
              if(snapshot.data == null) return CircularProgressIndicator();
                if(snapshot.hasData){
                  return Column(
                    children: snapshot.data.documents.map(
                      (doc) => buildItem(context, doc)).toList()
                    ); 
                }else{
                  return Column(children: <Widget>[
                    Text('Please Wait'),
                  ]);
                }
              },
            ),
          ],
        )
        ,
        floatingActionButton: FloatingActionButton(
          onPressed:()=> _getImage(),
          tooltip: 'Increment',
          child: Icon(Icons.photo_library),
        ),
        );
  }

  

    void deleteImage(image){
      image=null;
    }
    @override
    void dispose() {
      image=null;
      super.dispose();
    }

    void deleteData() async{
      
      StorageReference storageReferance = FirebaseStorage.instance.ref();
      storageReferance.child('Profile_Photo/scaled_1570174692193.jpg').delete();
      // StorageReference ref = FirebaseStorage.instance.ref().child("https://firebasestorage.googleapis.com/v0/b/testing2-35bbb.appspot.com/o/scaled_1570680294670.png?alt=media&token=f2d60a53-49de-4bcb-b816-dd216dfc3230");
      // ref.delete();
    }

    void updateData(context,docID) async{

      if(image!=null){
          StorageReference ref = FirebaseStorage.instance.ref().child(idUser).child('profile_photo').child(filename);
          StorageUploadTask uploadTask = ref.putFile(image);
        
          var url = await(await uploadTask.onComplete).ref.getDownloadURL();
          _gambar = url.toString();
      }
      else{
        _gambar="";
      }
      
      // if(storeNameController)
      _name = storeNameController.text;
      _address = storeAddressController.text;
      _owner = storeOwnerController.text;
      _phone = storePhoneController.text;
        
        db.collection('owner').document(idUser).updateData({
          'store_address': _address,
          'store_name': _name,
          'store_owner': _owner,
          'store_phone': _phone,
          'profile_photo': _gambar,
          'filename': filename
        });

      _showDialog(context);

    }
    
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Store Sucesfully Updated"),
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

}

