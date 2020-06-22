import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as prefix0;
// import 'package:ta_andypos/style/theme.dart' as Theme;
import 'package:flutter/cupertino.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'ui/transaksi.dart';
// import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:flutter/services.dart';
import 'package:escposprinter/escposprinter.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';

void main() => runApp(new SucesfullPagePrint());

// class ProblemWidget extends StatelessWidget{
//   final db = Firestore.instance;
//   @override
//   Widget build(BuildContext context){
//     return StreamBuilder<Object>(
//       stream: Firebaseauth.,
//     )
//   }
// }
class TestSucess extends StatelessWidget{
    Widget build(BuildContext context){
    return Text('Selesai');
  }
}

class SucesfullPagePrint extends StatefulWidget {
    final int changeAmount;
    final int cash;
    final String idHeader;
    final String idUser;


  SucesfullPagePrint({
    Key key, 
    this.changeAmount,this.cash,this.idHeader,this.idUser}) : super(key: key);
  @override
  _SucesfullPagePrintState createState() => new _SucesfullPagePrintState();
}

class _SucesfullPagePrintState extends State<SucesfullPagePrint> {
  List devices = [];
  String jenisPembayaran;
  bool connected = false;
  final db=Firestore.instance;
  String idTrans,kasir,tanggalTrans;
  int hargatotal;
  String itemlist;
  String buyer;
  // static const Escposprinter = const MethodChannel('samples.flutter.dev/battery');
  int changeAmount;
  int cash;
  @override
  initState() {
    //  reduceStok(this.widget.idHeader);
  
     _getHeaderTrans();
      _list();
       super.initState();
  }

    queryValues(idItem,priceAkhir) async {
    int totalHarga;
     Firestore.instance
        .collection('owner').document(this.widget.idUser).collection('item').document(idItem).collection('supplier_sender')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.documents.fold(
        0, (tot, doc) =>
      
       tot + doc.data['stok_tambah']);
       totalHarga=tempTotal;
       print("ZXC");
      
      Firestore.instance.collection('owner').document(this.widget.idUser).collection('item').document(idItem).updateData({
                          'item_qty': totalHarga,
                          'item_supplierprice': priceAkhir
                        });
        print(totalHarga);
      return totalHarga;
      // debugPrint(totalHarga.toString());
    });
  }

  _list() async {
    // print("try");
    List returned;

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
    tanggalTrans = ref.data['tanggal_transaksi'].toString();
    hargatotal = ref.data['harga_total'];
    buyer=ref.data['nama_member'];
    var ref2 = await db.collection('detail_transaksi').where('id_header', isEqualTo: this.widget.idHeader).getDocuments();
    jenisPembayaran = ref.data['jenis_pembayaran'];

    int jumlah=ref2.documents.length;
    int i;
    itemlist="";
    for(i=0;i<=jumlah;i++){
      print("abc");
      String namaItem=ref2.documents[i].data['nama_item'];
      int qtybeli=ref2.documents[i].data['qty_beli'];
      int pricepcs=ref2.documents[i].data['price_pcs'];
      int jumlahAkhir=qtybeli*pricepcs;
      if(itemlist==""){
        itemlist="$namaItem  x ${qtybeli.toString()} Rp.${pricepcs.toString()}   = ${jumlahAkhir.toString()} \n";
      }else{
          itemlist = itemlist+"$namaItem  x ${qtybeli.toString()} Rp.${pricepcs.toString()}   = ${jumlahAkhir.toString()} \n";
      }
 
      print(itemlist);
    }
    // setState(() {
    //   idTrans=idTrans;
    //   kasir=kasir;
    //   hargatotal=hargatotal;
    //   itemlist=itemlist;
    // });
    
  }
  // Widget _text(BuildContext context){
  //   return QrImage(
  //     data: "asd",
  //     size: 200,
  //     backgroundColor: Colors.white,
  //   );
  // }
  


  _print() async {
    if(jenisPembayaran=="Cash"){
      
        try {
          await Escposprinter.printText(
            ' DyPOS Point Of Sales\n Jl.Ngagel Jaya Tengah no 73-77 \n Telp: 081-216-530-559 \n\n ID Transaction : $idTrans   Tanggal        : ${tanggalTrans.toString()}\n Customer       : $buyer \n Kasir          : $kasir \n ----------------------------------\n $itemlist \n ----------------------------------\n Total   = ${hargatotal.toString()} \n Bayar   = ${this.widget.cash.toString()}\n Kembali = ${this.widget.changeAmount.toString()}\n\n Terimakasih Telah melakukan pembelian   di toko kami.\n\n\n\n\n\n\n\n\n\n\n\n'
            
            );
            
            // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
            // Printer.connect().printBarcode(Barcode.upcA(barData));
            
            // Escposprinter.printRawData()
            // await Escposprinter.printRawData(text)
          // Escposprinter.println('asd');
      
        } on PlatformException {
          // response = 'Failed to get platform version.';
        }
    }else{
        try {
          await Escposprinter.printText(
            ' DyPOS Point Of Sales\n Jl.Ngagel Jaya Tengah no 73-77 \n Telp: 081-216-530-559 \n\n ID Transaction : $idTrans   Tanggal        : ${tanggalTrans.toString()}\n Customer       : $buyer \n Kasir          : $kasir \n ----------------------------------\n $itemlist \n ----------------------------------\n Total   = ${hargatotal.toString()} \n Bayar   = ${hargatotal.toString()} \n Kembali = 0 \n\n Terimakasih Telah melakukan pembelian   di toko kami.\n\n\n\n\n\n\n\n\n\n\n\n');
          // Escposprinter.println('asd');
      
        } on PlatformException {
          // response = 'Failed to get platform version.';
        }
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
                        child: Text('${this.widget.changeAmount.toString()}',
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
                                        Navigator.pushReplacement(context, MaterialPageRoute(
                                            builder: (context) =>
                                            new Transaksi())
                                        );
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
                              )
                              
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