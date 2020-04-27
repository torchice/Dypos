// import 'detailScreen.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as prefix0;
import 'package:ta_andypos/style/theme.dart' as Theme;
// import 'tambahItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import '../drawerBar.dart';
import 'tambahstok.dart' as addStok;
import 'tambahItem.dart' as addDesc; 
import 'showItem.dart';

void main() => runApp(ExampleScreen());

class RIKeys {
  static final riKey1 = const Key('rikey1');
  static final riKey2 = const Key('rikey2');
  static final riKey3 = const Key('rikey3');
}
//SEMENTARA UNTUK LOAD MASTER ITEM MENGGUNAKAN ExampleScreen
class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> with SingleTickerProviderStateMixin {
  String idUser,_email,role;
  final db= Firestore.instance;
  TabController controller;

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
  
  @override
  void initState(){
    
    controller = new TabController(vsync: this, length: 3);
    super.initState();
    _loadUid();
  }
  
  @override
  Widget build(BuildContext context) {
       return new Scaffold(
        appBar: new AppBar(
          actions: <Widget>[
            
          ],
        title: 
        InkWell(
          child:  new Text('Master Item'),
          onTap:(){
              Navigator.push(
                  context,
                MaterialPageRoute(builder: (context) => Home(user: _email)) ,
              );
          }
        ),    
        backgroundColor: Theme.Colors.loginGradientStart,
        bottom: new TabBar(
          controller: controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.home), text: "List",),
            new Tab(icon: new Icon(Icons.list),text: "Add Item",),      
            new Tab(icon: new Icon(Icons.add),text: "Add Stock",),    
          ]
        ),
      ),
      drawer:buildDrawer(context,idUser,_email,role),
        body: new TabBarView(
          controller: controller,
          key: RIKeys.riKey1,
          children: <Widget>[
            new ShowItem(controller: controller,),
            new addDesc.AddItemPage(controller: controller,),
             new addStok.AddStokPage(controller: controller,),
          ]
        ),

      );
  }
 
}

// class _ShopListItem extends StatelessWidget {

//   final Item item;
//   final bool isInCart;
//   final bool isSideLine;
//   dynamic onTap;

//   _ShopListItem({this.item, this.isInCart, this.isSideLine, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     Border border;
//     if (isSideLine) {
//       border = Border(
//           bottom: BorderSide(color: Colors.grey, width: 0.5),
//           right: BorderSide(color: Colors.grey, width: 0.5));
//     } else {
//       border = Border(bottom: BorderSide(color: Colors.grey, width: 0.5));
//     }

//     return InkWell(
//         onTap: () => this.onTap(item),
//         child: Container(
//             decoration: BoxDecoration(border: border),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(top: 16),
//                 ),
//                 Container(
//                   child: AspectRatio(
//                     aspectRatio: 1,
//                     child: Image.network(item.imageUrl),
//                   ),
//                   height: 250,
//                 ),

//                 Padding(
//                   padding: EdgeInsets.only(top: 16),
//                 ),
//                 Text(item.name,
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context)
//                         .textTheme
//                         .title
//                         .apply(fontSizeFactor: 0.8)),
//                 Padding(
//                   padding: EdgeInsets.only(top: 16),
//                 ),
//                 Text(item.formattedPrice,
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context)
//                         .textTheme
//                         .subhead
//                         .apply(fontSizeFactor: 0.8)),
//                 Padding(
//                   padding: EdgeInsets.only(top: 16),
//                 ),
//                 Text(this.isInCart ? "In Cart" : item.formattedAvailability,
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.caption.apply(
//                         fontSizeFactor: 0.8,
//                         color:
//                             isInCart ? Colors.blue : item.availabilityColor)),
                
//               ],
//             )));
//   }
// }



// class _MasterItemPageState extends State<MasterItemPage>
// {
//   ShoppingCart cart = ShoppingCart();

//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final List<Item> items = Item.userItems;
//   // final List<Item> test = Item.fetc

//   Widget build(BuildContext context) {
//     final columnCount = MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4;

//     final width = MediaQuery.of(context).size.width / columnCount;
//     const height = 400;

//     List<Widget> items = [];
//     for (var x = 0; x < this.items.length; x++) {
//       bool isSideLine;
//       if (columnCount == 2) {
//         isSideLine = x % 2 == 0;
//       } else {
//         isSideLine = x % 4 != 3;
//       }
//       final item = this.items[x];

//       items.add(_ShopListItem(
//         item: item,
//         isInCart: cart.isExists(item),
//         isSideLine: isSideLine,
//         onTap: (item) {
//           _scaffoldKey.currentState.hideCurrentSnackBar();

//           if (cart.isExists(item)) {
//             cart.remove(item);
//             _scaffoldKey.currentState.showSnackBar(SnackBar(
//               content: Text('Item is removed from cart!'),
//             ));
//           } else if (item.inStock) {
//             cart.add(item);
//             _scaffoldKey.currentState.showSnackBar(SnackBar(
//               content: Text('Item is added to cart!'),
//             ));
//           } else {
//             _scaffoldKey.currentState.showSnackBar(SnackBar(
//               content: Text('Item is out of stock!'),
//             ));
//           }
//           this.setState(() {});
//         },
//       ));
//     }

//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: Text("Master Item"),
//         ),
//         body: GridView.count(
//           childAspectRatio: width / height,
//           scrollDirection: Axis.vertical,
//           crossAxisCount: columnCount,
//           children: items,
//         ),
        
//         floatingActionButton: FloatingActionButton(
//           onPressed:()=> Navigator.push(context, MaterialPageRoute(builder: (context) => new AddItemPage() )),
//           tooltip: 'Increment',
//           child: Icon(Icons.add),
//         ),
        
//         // floatingActionButton: cart.isEmpty
//         //     ? null
//         //     : FloatingActionButton.extended(
//         //         onPressed: () {
//         //           Navigator.of(context).push(MaterialPageRoute(
//         //               builder: (context) => CartListWidget(
//         //                     cart: this.cart,
//         //                   )));
//         //         },
//         //         icon: Icon(Icons.shopping_cart),
//         //         label: Text("${cart.numOfItems}"),
//         //       ),
//       );

//   }

// }

