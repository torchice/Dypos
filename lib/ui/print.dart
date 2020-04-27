import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as prefix0;
// import 'package:ta_andypos/style/theme.dart' as Theme;
import 'package:flutter/cupertino.dart';
// import 'ui/transaksi.dart';
// import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:flutter/services.dart';
import 'package:escposprinter/escposprinter.dart';

void main() => runApp(new TestPage());

class TestPage extends StatefulWidget {
    final int changeAmount;
    final int cash;
    final String idHeader;

  TestPage({
    Key key, 
    this.changeAmount,this.cash,this.idHeader}) : super(key: key);
  @override
  _TestPageState createState() => new _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List devices = [];
  bool connected = false;
  final db=Firestore.instance;
  String idTrans,kasir,tanggal_transaksi;
  String hargatotal;
  String itemlist;
  // static const Escposprinter = const MethodChannel('samples.flutter.dev/battery');

  @override
  initState() {
    super.initState();
     _list();
     _getHeaderTrans();
  }

  _list() async {
    // print("try");
    List returned;
    // try {
    //   print('try');
    //   returned = await Escposprinter.getUSBDeviceList;
    // } on PlatformException{
    //   // print(p.toString());
    //   //response = 'Failed to get platform version.';
    // }
    try{
        returned = await Escposprinter.getUSBDeviceList;
        print("masuk try");
    }on PlatformException catch(e){
      print('error: $e');
    } 

    setState((){
      devices = returned;
    });
  }

  _connect(int vendor, int product) async {
    bool returned;
    try {
      returned = await Escposprinter.connectPrinter(vendor, product);
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
    if(returned){
      setState((){
        connected = true;
      });
    }
  }

  _getHeaderTrans() async{
    DocumentSnapshot ref = await db.collection('header_transaksi').document(this.widget.idHeader).get();
      //  String idTrans,kasir,tanggal_transaksi,hargatotal;
    idTrans=ref.documentID;
    kasir =ref.data['nama_pelayan'];
    tanggal_transaksi = ref.data['tanggal_transaksi'].toString();
    hargatotal = ref.data['harga_total'].toString();
    var ref2 = await db.collection('detail_transaksi').where('id_header', isEqualTo: this.widget.idHeader).getDocuments();
    //String nama,qty,subtotal
    //totalbayar,amount,bayar
    int jumlah=ref2.documents.length;
    for(int i=0;i<=jumlah;i++){
      print("abc");
      itemlist += ref2.documents[i].data['nama_item']+"  x"+ref2.documents[i].data['qty_beli'] + " price_pcs\n";
    }
    setState(() {
      idTrans=idTrans;
      kasir=kasir;
      tanggal_transaksi=tanggal_transaksi;
      hargatotal=hargatotal;
      itemlist=itemlist;
    });
    
  }

  _print() async {
    try {
      await Escposprinter.printText(
        ' DyPOS Point Of Sales\n Jl.Ngagel Jaya Tengah no 73-77 \n Telp: 081-216-530-559 \n\n ID Transaction: $idTrans   Tanggal: ${tanggal_transaksi.toString()}\n Kasir: $kasir \n ----------------------------------\n $itemlist \n ----------------------------------\n Total   = ${hargatotal.toString()} \n Bayar   = ${this.widget.cash.toString()}\n Kembali = ${this.widget.changeAmount.toString()}\n\n Terimakasih Telah melakukan pembelian  di toko kami.\n');
      // Escposprinter.println('asd');
  
    } on PlatformException {
      // response = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(

        body:
          Container(
              width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.white
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
            child:Column(
              children: <Widget>[
                    // Text('Change Amount: ${this.changeAmount.toString()}'),
                    Padding(
                        padding: EdgeInsets.fromLTRB(25,25,25,0),  
                        child: new Center(
                          child: 
                            Text('Transaction',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontFamily: 'WorkSansSemiBold'
                              ),
                            ),
                            
                          
                        ),
                    ),
                     Padding(
                      padding: EdgeInsets.all(0.0),  
                        child: new Center(
                          child: 
                            Text(' Completed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontFamily: 'WorkSansSemiBold'
                              ),
                            ),
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.0),
                        child: new Image(
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.fill,
                          image: new AssetImage('assets/img/complete_payment.png')),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                        child: Text('Change Amount :',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'WorkSansSemiBold'
                              ),
                            ),
                    ),
                     Padding(
                      padding: EdgeInsets.all(0.0),
                        child: Text('${this.widget.changeAmount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'WorkSansSemiBold'
                              ),
                            ),
                    ),
                     Padding(
                      padding: EdgeInsets.fromLTRB(10.0,5,10,10),
                        child: 
                                 CupertinoButton(
                                    child: Text('Print'),  
                                    color: Colors.orangeAccent,

                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 37.0),
                                    onPressed: () {
                                      
                                        _print();
                                    },
                                  ),
                    ),
                     Padding(
                      padding: EdgeInsets.all(10.0),
                        child: 
                          CupertinoButton(
                                    child: Text('Complete'),  
                                    color: Colors.orangeAccent,
                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                    onPressed: () {
                                        // // Navigator.push(context, new MaterialPageRoute(
                                        // //     builder: (context) =>
                                        // //     // new Transaksi())
                                        // // );
                                    },
                                  ),
                    ),
                        Padding(
                      padding: EdgeInsets.all(10.0),
                        child: 
                        
                        Column(
                          
                          children: <Widget>[
                            Text("Connected Devices"),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 125,
                              child:  
                              ListView(
                                    scrollDirection: Axis.vertical,
                                    children: _buildList(devices),
                              ),
                            ),
                        
                          ],
                        )
                    ),
               
                     
                    // Text('Transaction Complete')
              ],
            ),
          )
         ,
      ),
    );
  }

  List<Widget> _buildList(List devices){
    return devices.map((device) => new ListTile(
      onTap: () {
        _connect(int.parse(device['vendorid']), int.parse(device['productid']));
      },
      leading: new Icon(Icons.usb),
      title: new Text(device['manufacturer'] + " " + device['product']),
      subtitle: new Text(device['vendorid'] + " " + device['productid']),
    )).toList();
  }
}