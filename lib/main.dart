import 'package:expense_tracker/views/Home_Page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: HomePage()),
    );
  }
}





// import 'package:expense_tracker/views/Financial_Input.dart';
// import 'package:flutter/material.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("DashBoard"),
//           bottom:TabBar(tabs: [
//               Tab(
//                 child: Text("Expense"),
//               ),
//               Tab(
//                 child: Text("Inncome"),
//               ),
//               Tab(
//                 child: Text("Accounts"),
//               ),
//             ])
//         ),
//         body: Column(
//           children: [
//             TabBarView(children: [
//
//             ])
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (_){
//               return FinancialInput();
//             }));
//           },
//           child: Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }


