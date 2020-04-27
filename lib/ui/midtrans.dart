import 'package:flutter/material.dart';
// import 'package:flutter_midtrans/flutter_midtrans.dart';
// import 'package:flutrans/flutrans.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ta_andypos/succesfull.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'transaksi.dart';
// import 'package:ta_andypos/style/theme.dart' as Theme;
import 'package:flutter/cupertino.dart';
// import 'package:ping_discover_network/ping_discover_network.dart';


void main() => runApp(new PaymentGateway());

// final flutrans = new FluTrans();

class PaymentGateway extends StatefulWidget {
    final String idHeader;
  // TestPage({
  //   Key key, 
  //   this.changeAmount,this.cash,this.idHeader}) : super(key: key);
  PaymentGateway({
    Key key, this.idHeader
  });
  // @override
  // _TestPageState createState() => new _TestPageState();
  @override
  _PaymentGatewayState createState() => new _PaymentGatewayState();
   
}

class _PaymentGatewayState extends State<PaymentGateway> {
  // FlutterBlue flutterBlue = FlutterBlue.instance;
    // int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
            backgroundColor: Colors.orangeAccent,
      body: Column(
        children: <Widget>[
          Expanded(
            child: WebviewScaffold(
                url: "https://dypos.web.id/index.php/Vtweb?idHeader="+ this.widget.idHeader,
            clearCookies: false,
            withJavascript: true,
            withZoom: true,
            ),
          ),
          Column(
            children: <Widget>[
              
              RaisedButton(
                onPressed: (){
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                      builder: (context) =>
                      new SucesfullPagePrint(
                        idHeader: this.widget.idHeader,
                        changeAmount: 0,
                      ))
                    );
                },
                child: Text("Finish"),
              )
            ],
          )
          
        ],
      )
    );

    
  }
}