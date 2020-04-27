import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:date_calendar/date_calendar.dart';

// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:intl/intl.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:datetime_picker_formfield/time_picker_formfield.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class FormKeys {
  static final supplierKey = const Key('supplierKey');
}

class _AddPageState extends State<AddPage>{

  String idUser;
  String _nama;

        
        String finalCode;
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController promoNameController = new TextEditingController();
  TextEditingController promoQtyController = new TextEditingController();
  TextEditingController promoDscController = new TextEditingController();
      // DateTime now = DateTime.now();
   List<GregorianCalendar> days = new List();
   bool _correctDate=false;
 

  final GlobalKey<FormState> _formKeyAddSupplier = new GlobalKey<FormState>();

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
  String dateEnd= 'Date End: ';
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
      

      if(picked != null && picked != selectedDate ){
        if(picked.isBefore(DateTime.now())){
          print("error");
          _correctDate=false;
        }else{
          _correctDate=true;
          print("benar");
        }
        setState(() {
          selectedDate = picked;
          dateEnd = 'Date End: ${selectedDate.toString()}';
        });
        // print("ASDASDAS {$dateEnd}");
      }

  }
  
    String randomTodo(_nama){
      final code = randomAlpha(5);
      final randomNumber = Random().nextInt(9).ceil();

      final code2 = _nama.substring(0, 2);

      setState(() {
          finalCode = code2 + code.toString() + randomNumber.toString(); 
      });
      return finalCode;
    }

  Future<void> insertSupplier() async{
      try{
        if(_correctDate==true){
                _nama=promoNameController.text;
          // _minQty=int.tryParse(promoQtyController.text);
          // _dsc=int.tryParse(promoDscController.text);
          // _dateEnd = selectedDate;

          String formattedTime = DateFormat('yyyy-MM-dd hh:mm').format(selectedDate);  
          print("testId");
          print(idUser);
    
          randomTodo(_nama);
          print(finalCode);
          
          Firestore.instance.collection('owner').document(idUser).collection('promo').add({
            'promo_name': '$_nama ',
            'promo_endDate': formattedTime,
            'promo_code': finalCode.toUpperCase()
          });

          promoNameController.clear();
          promoQtyController.clear();
          promoDscController.clear();
          _showDialog();
        }else{
          print("format salah coeg");
        }
    
        
        // Navigator.push(
        //   context,  
        //   MaterialPageRoute(builder: (context) => Home(user: email)) ,
        // );
      }catch(e){
        print(e.toString());
      }
    }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Promo Sucesfully Added"),
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

  Widget body(BuildContext context){

     Size screenSize = MediaQuery.of(context).size;
          return new Scaffold(
            resizeToAvoidBottomPadding: true,
            body: new SingleChildScrollView(
              child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  new Column(
                    children:<Widget>[
                      SizedBox(
                        height: screenSize.height/10,
                      ),
                       Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 0.0, 20.0, 0.0),
                        child:   TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.text_format, color: Colors.red),
                            labelText: "Promo Name",
                          )
                          ,controller:promoNameController,
                          // focusNode: supplierNameFocus,
                        ),
                      ),
                  
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(30.0, 0.0, 20.0, 0.0),
                      //   child: TextFormField(
                      //     decoration: InputDecoration(
                      //       icon: Icon(Icons.account_balance, color: Colors.red),
                      //       labelText: "Minimum Buy Product",

                      //     )
                      //     ,controller:promoQtyController,
                      //     // focusNode: supplierAddressFocus,
                      //     keyboardType: TextInputType.number,
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(30.0, 0.0, 20.0, 0.0),
                      //   child: TextFormField(
                      //     decoration: InputDecoration(
                      //       icon: Icon(Icons.vertical_align_bottom, color: Colors.red),
                      //       labelText: "Discount (%)",
                      //     )
                      //     ,controller:promoDscController,
                      //     // focusNode: supplierPhoneFocus,
                      //     keyboardType:TextInputType.number,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 0.0, 20.0, 0.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today, color: Colors.red),
                            labelText: dateEnd,
                          )
                          ,
                          enabled: false,
                          // focusNode: supplierPhoneFocus,
                          keyboardType:TextInputType.number,
                        ),
                      ),
                        RaisedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select date end promo'),
                    ),
                      new MaterialButton(
                        child: new Text("Add Promo", style: new TextStyle(color: Colors.white),),
                        color: Colors.lightBlue,
                        onPressed: (){
                          insertSupplier();
                          //  print(days);
                        }
                    )
                          ],
                        )
                    // Text("${selectedDate.toLocal()}"),
        
                  
              ],
            ),
          )
          );}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: body(context),
      key:_formKeyAddSupplier
    );
  }
}