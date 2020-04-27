import 'item/master_item.dart';
// import 'kategori/master_kategori.dart';
import 'kategori/master.dart';
import 'member/master.dart';
// import 'master_member.dart';
import 'cashier/master_pelayan.dart';
// import 'master_promo.dart';
import 'promo/masterPromo.dart';
import 'supplier/master_supplier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:ta_andypos/style/theme.dart' as Theme;
import 'editProfile.dart';
import 'login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaksi.dart';
import 'retur_pembelian/master.dart';
import 'retur_penjualan/master.dart';
import 'transaction/master.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'detailScreen.dart';

Widget buildDrawer(BuildContext context,idUser,_email,role){
    if(role=="admin"){
          return Drawer(
      child:
          //untuk admin
          ListView(
          // Important: Remove any padding from the ListView.
          //males mikir 2x add aja dah
          
          padding: EdgeInsets.zero,
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance.collection('owner').document(idUser).snapshots(),
                builder: (BuildContext context, snapshot ){
                  if(!snapshot.hasData) return const Text('loading..');
                  
                  return new UserAccountsDrawerHeader(
                    
                    accountEmail: Text(_email),
                    accountName: Text(snapshot.data['store_name']),
                      // print('test');
                        currentAccountPicture: new GestureDetector(
                          child: new CircleAvatar(
                            backgroundImage: snapshot.data['profile_photo'] == "" || snapshot.data['profile_photo'] == null? 
                            new AssetImage('assets/person.png') :
                            new NetworkImage(snapshot.data['profile_photo'])
                          )

                    ),
                    

                  );
                  
                }
            ),
            StreamBuilder( 
              stream:Firestore.instance.collection('owner').document(idUser).snapshots(),
              builder: (context,snapshot){
                return new GestureDetector(
                  onTap: (){
                      
                  },
                  child:   
                  ListTile(
                    leading: Icon(Icons.store),
                    title: Text('Edit Store Info'),
                    onTap: () {
                        Navigator.push(context, new MaterialPageRoute(
                          
                            builder: (context) =>
                    
                            new EditStorePage(
                              fileImageValue: snapshot.data['profile_photo'],
                            )
                          )
                      );
                    },
                  ), 
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Master Kategori'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterKategoriPage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text('Master Supplier'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer sebelum masuk supplier mending di dispose dlu smua contextna
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterSupplierPage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text('Master Item'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new ExampleScreen())
                );
                

              },
            ),
              ListTile(
                leading: Icon(Icons.person_outline),
              title: Text('Master Pelayan'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterPelayanPage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Master Promo'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterPromoPage())
                );
                // MasterPromoPage
              },
            ),
        
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Master Member'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterMemberPage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text('List Transaksi'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterTransListPage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_returned),
              title: Text('Retur Pembelian'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterReturPembelianPage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_late),
              title: Text('Retur Penjualan'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterReturPenjualanPage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Logout'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pushReplacement(context, new MaterialPageRoute(
                    builder: (context) =>
                    new LoginPage())
                );
              },
            ),
        
          ],
        ),
        );
    }else{
          return Drawer(
      child:
        //untuk pelayan kasir
          ListView(
          // Important: Remove any padding from the ListView.
          //males mikir 2x add aja dah
          
          padding: EdgeInsets.zero,
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance.collection('owner').document(idUser).snapshots(),
                builder: (BuildContext context, snapshot ){
                  return new UserAccountsDrawerHeader(
                    
                    accountEmail: Text(_email),
                    accountName: Text(snapshot.data['store_name']),
                      // print('test');
                        currentAccountPicture: new GestureDetector(
                          child: new CircleAvatar(
                            backgroundImage: snapshot.data['profile_photo'] == "" || snapshot.data['profile_photo'] == null? 
                            new AssetImage('assets/person.png') :
                            new NetworkImage(snapshot.data['profile_photo'])
                          )
                    ),
                  );
                }
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text('Transaksi'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new Transaksi())
                );
              },
            ),
    
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Master Member'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterMemberPage())
                );
              },
            ),
    
            // MasterTransListPage
            ListTile(
              leading: Icon(Icons.assignment_returned),
              title: Text('Retur Pembelian'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterReturPembelianPage())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_late),
              title: Text('Retur Penjualan'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new MasterReturPenjualanPage())
                );
              },
            ),
              ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Logout'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    new LoginPage())
                );
              },
            ),
        
        
          ],
        ),
        );
    }


  }
