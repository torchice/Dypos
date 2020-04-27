import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ta_andypos/style/theme.dart' as Theme;
import 'package:ta_andypos/components/TextFields/inputField.dart';
import 'package:ta_andypos/theme/style.dart';
import 'login_page.dart';

void main() => runApp(BusinessInfoPage());

class HeadBusiness extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      title: 'Business Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes:  <String, WidgetBuilder>{
       
      },
      home: BusinessInfoPage(),
    );
  }
}

class RIKeys {
  static final riKey1 = const Key('rikey1');
  static final riKey2 = const Key('rikey2');
  static final riKey3 = const Key('rikey3');
}

/*class Validations{
  String validateNull(String value) {
    if (value.isEmpty) return 'Please Input Field.';
    return null;
  }
}*/
class BusinessInfoPage extends StatefulWidget {

  // final FirebaseUser emailReg;

    final String email,passwordValue;
    final String idOwner;

   BusinessInfoPage({Key key, this.email, this.passwordValue, this.idOwner}) : super(key: key);
  
  @override
  _BusinessInfoPageState createState() => _BusinessInfoPageState();
  
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

class _BusinessInfoPageState extends State<BusinessInfoPage>
{
  String idUser;
  // String _uid;
  //_uid sama aja kayak idUser tapi variable ini untuk registe
  @override
  void initState(){
    // _loadUid();
    super.initState();
  }
  
  // _loadUid() async {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     setState(() {
  //       _uid = (prefs.getString('uid')??'');
  //       // _email = (prefs.getString('email')??'');
  //     });
  // }
  
  
  String _name,_category,_address,_owner,_phone;

  String dropdownValue;
  final db = Firestore.instance;

  String id;
  
  bool autoValidate=false;
  bool emailExist=false;
  var userNameController;
  var error;

/*  final _formKeyBusiness = GlobalKey<FormState>();*/
  TextEditingController storeNameController = new TextEditingController();
  TextEditingController categoryController = new TextEditingController();
  TextEditingController ownerNameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();

  // final db=Firestore.instance;

  final FocusNode myFocusNodeStoreName = FocusNode();
  final FocusNode myFocusNodeCategory = FocusNode();
  final FocusNode myFocusNodeOwner = FocusNode();
  final FocusNode myFocusNodeAddress = FocusNode();
  final FocusNode myFocusNodePhone = FocusNode();

    Widget buildDropDown(BuildContext context){
      return Container(
        key:RIKeys.riKey1,
        width: 300.0,
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: _category,

              items: <String>[
                'Grocery Store', 'Food & Beverages',
                'Fashion', 'Raw Materials','Others'
                ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
              );
          }).toList(),

              onChanged:(String _categoryChoose) {
                setState(() {
                  dropdownValue = _categoryChoose;
                  _category=_categoryChoose;
                });
              },
              style: TextStyle(
      color: Colors.grey[800],
            ),
          ),
        ),
        )
      );
      }
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    //print(context.widget.toString());
    return new Scaffold(
      key: RIKeys.riKey1,
        body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.all(15.0),
            decoration: new BoxDecoration(
                image: backgroundImage,
                gradient: new LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientStart,
                    Theme.Colors.loginGradientEnd],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)
                ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                    height: screenSize.height / 3,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "BUSINESS INFO",
                          textAlign: TextAlign.center,
                          style: headingStyle,
                        )
                      ],
                    )),
                new SizedBox(
                  height: screenSize.height,
                  child: new Column(
                    children: <Widget>[
                      new Form(
                          //onWillPop: _warnUserAboutInvalidData,
                          child: new Column(
                            children: <Widget>[
                         
                              new InputField(
                                controllerFunction: storeNameController,
                                hintText: "Store Name",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                textStyle: textStyle,
                                textFieldColor: textFieldColor,
                                icon: Icons.store,
                                iconColor: Colors.white,
                                bottomMargin: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.category,
                                          size: 22.0,
                                          color: Color.fromARGB(255, 255, 255, 255),

                                        ),
                                        enabled: false,
                                        hintText: 'Category',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: buildDropDown(context),
                                  )
                                ],
                              ),
                              new InputField(
                                  hintText: "Owner Name",
                                  obscureText: false,
                                  textInputType: TextInputType.text,
                                  textStyle: textStyle,
                                  textFieldColor: textFieldColor,
                                  icon: Icons.people,
                                  iconColor: Colors.white,
                                  bottomMargin: 10.0,
                                  controllerFunction: ownerNameController,

                                  ),
                              new InputField(

                                  hintText: "Address",
                                  obscureText: false,
                                  textInputType: TextInputType.text,
                                  textStyle: textStyle,
                                  textFieldColor: textFieldColor,
                                  icon: Icons.home,
                                  iconColor: Colors.white,
                                  bottomMargin: 10.0,
                                  controllerFunction: addressController,
                                ),
                              new InputField(
                                hintText: "Phone Number",
                                obscureText: false,
                                textInputType: TextInputType.phone,
                                textStyle: textStyle,
                                textFieldColor: textFieldColor,
                                icon: Icons.phone,
                                iconColor: Colors.white,
                                bottomMargin: 40.0,
                                controllerFunction: phoneNumberController,
                              ),
                              new RaisedButton(
                                child:
                                Text('Next'),
                                onPressed: () => createData(),
                              ),
                            ],

                          )),
                    ],
                  ),

                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
    
   Future<void> createData() async{
    _name=storeNameController.text;
    _address=addressController.text;
    _owner=ownerNameController.text;
    _phone=phoneNumberController.text;
       try{

          db.collection('owner').document(this.widget.idOwner).setData(({
            'email': this.widget.email,
            'password': this.widget.passwordValue,
            'store_name': '$_name ',
            'store_type': '$_category',
            'store_address': '$_address',
            'store_owner': '$_owner',
            'store_phone': '$_phone',
            'profile_photo': '',
            'filename':''
         }));

          db.collection('owner').document(this.widget.idOwner).collection('user').add(({
            'email': this.widget.email,
            'password': this.widget.passwordValue,
            'role': 'admin'
         }));

          Navigator.push(context, new MaterialPageRoute(
                builder: (context) =>
                new LoginPage())
          );
         
       }catch(e){
         print(e.message);
       }
  }

}

