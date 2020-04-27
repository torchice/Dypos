import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:ta_andypos/components/TextFields/inputField.dart';
// import 'package:flutter_mailer/flutter_mailer.dart';
// import 'package:ta_andypos/style/theme.dart' as Theme;
import 'spreadPromo.dart';

class DetailPromo extends StatefulWidget {

  _DetailPromoPage createState() => _DetailPromoPage();
  // final String idItem;

  final String nama,code,date;

  DetailPromo({
    Key key, 
    this.nama,this.code,this.date}) : super(key: key);

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

File image;
String filename;
// class _ShowItemPage extends State<ShowItem>{
class _DetailPromoPage extends State<DetailPromo>{
  
  String idUser;
  // String _category;
  bool updateCheck=false;
  final db = Firestore.instance;
  TextEditingController supplierNameController = new TextEditingController();
  TextEditingController supplierAddressController = new TextEditingController();
  TextEditingController supplierPhoneController = new TextEditingController();

_loadUid() async {             
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = (prefs.getString ('uid')??'');
    });
  }
  
  @override
  void initState(){
    super.initState();
    _loadUid();
  }


    void dispose() {
      super.dispose();
    }




 Widget uploadArea(){
      // Image image = decodeImage(new Io.File(image).readAsBytesSync());
    return Column(
      children: <Widget>[
        Image.file(image, width:300, height: 100,),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
      Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Promo"),
        
        actions: <Widget>[
          Text("asd")
        ],
         backgroundColor: Colors.orangeAccent,
      ),
      body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.all(15.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                    height: 30,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "Detail Promo",
                          textAlign: TextAlign.center,
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
                                controllerFunction: supplierNameController,
                                // initialVal: this.widget.itemName,
                                hintText: "Promo Name: ${this.widget.nama}",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                enabled: updateCheck,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.text_fields,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
                              ),
                              new InputField(
                                obscureText: false,
                                hintText: "Promo Code: ${this.widget.code}",
                                textInputType: TextInputType.text,
                                 enabled: updateCheck,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: CupertinoIcons.tag_solid,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                controllerFunction: supplierAddressController,
                              ),
                              new InputField(
                                // hintText: "Selling Price",
                                 enabled: updateCheck,
                                hintText: "Date End: ${this.widget.date}",
                                obscureText: false,
                                textInputType: TextInputType.number,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.date_range,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                controllerFunction: supplierPhoneController,
                              ),
                             
                              SizedBox(height: 10.0,),
                               RaisedButton(
                                          onPressed: (){
                                            
                                                Navigator.push(context, MaterialPageRoute
                                                  (builder: 
                                                    (context) => SpreadPromo(
                                                      promoCode: this.widget.code,
                                                    )
                                                  )
                                                );
                                          },
                                          child: Text('Spread Promo'),
                                        )
                           
                              // Text("Value uid pref is $idUser")
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }

}
