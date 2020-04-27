import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ta_andypos/models/CRUDModel.dart';
// import 'router.dart';
// import 'locator.dart';

import 'package:ta_andypos/ui/login_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Point Of Sales',
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}

// void main() {
//   setupLocator();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(builder: (_) => locator<CRUDModel>()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: '/',
//         title: 'Product App',
//         theme: ThemeData(),
//         onGenerateRoute: Router.generateRoute,
//       ),
//     );
//   }
// }