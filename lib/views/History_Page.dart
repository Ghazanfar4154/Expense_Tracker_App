// import 'package:flutter/material.dart';
//
// // Sample data model
// class Expense {
//   final String category;
//   final double amount;
//   final IconData icon;
//   final DateTime dateTime;
//
//   Expense({
//     required this.category,
//     required this.amount,
//     required this.icon,
//     required this.dateTime,
//   });
// }
//
// // Sample data
// List<Expense> expenses = [
//   Expense(
//     category: 'Food',
//     amount: 50.0,
//     icon: Icons.fastfood,
//     dateTime: DateTime.now(),
//   ),
//   Expense(
//     category: 'Transportation',
//     amount: 30.0,
//     icon: Icons.directions_car,
//     dateTime: DateTime.now(),
//   ),
//   Expense(
//     category: 'Entertainment',
//     amount: 70.0,
//     icon: Icons.movie,
//     dateTime: DateTime.now(),
//   ),
// ];
//
// class HistoryPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Calculate total expenses
//     double totalExpenses = expenses.fold(0, (previousValue, element) => previousValue + element.amount);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Expense History',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.blue,
//         elevation: 0,
//       ),
//       body: Container(
//         color: Colors.blue[50],
//         child: ListView.builder(
//           itemCount: expenses.length,
//           itemBuilder: (context, index) {
//             Expense expense = expenses[index];
//             // Calculate percentage dynamically
//             double percentage = (expense.amount / totalExpenses) * 100;
//
//             return Card(
//               elevation: 4,
//               margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.blue,
//                   child: Icon(
//                     expense.icon,
//                     color: Colors.white,
//                   ),
//                 ),
//                 title: Text(
//                   expense.category,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 4),
//                     Text(
//                       'Amount: \$${expense.amount.toStringAsFixed(2)}',
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Date & Time: ${expense.dateTime.toString()}',
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: LinearProgressIndicator(
//                             value: percentage / 100,
//                             backgroundColor: Colors.grey[300],
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           '${percentage.toStringAsFixed(2)}%',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }













// import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';
//
// import '../model/DataBase_Helper.dart';
//
// // Sample data model
// class Expense {
//   final String category;
//   final double amount;
//   final IconData icon;
//   final DateTime dateTime;
//
//   Expense({
//     required this.category,
//     required this.amount,
//     required this.icon,
//     required this.dateTime,
//   });
// }
//
// // Sample data
// List<Expense> expenses = [
//   Expense(
//     category: 'Food',
//     amount: 50.0,
//     icon: Icons.fastfood,
//     dateTime: DateTime.now(),
//   ),
//   Expense(
//     category: 'Transportation',
//     amount: 30.0,
//     icon: Icons.directions_car,
//     dateTime: DateTime.now(),
//   ),
//   Expense(
//     category: 'Entertainment',
//     amount: 70.0,
//     icon: Icons.movie,
//     dateTime: DateTime.now(),
//   ),
//
// ];
//
//
//
// class HistoryPage extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Calculate total expenses
//     double totalExpenses = expenses.fold(0, (previousValue, element) => previousValue + element.amount);
//
//     // Calculate percentages for each category
//     Map<String, double> dataMap = {};
//     expenses.forEach((expense) {
//       dataMap[expense.category] = expense.amount / totalExpenses;
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Expense History',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.blue,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: PieChart(
//               dataMap: dataMap,
//               chartRadius: MediaQuery.of(context).size.width / 3,
//               legendOptions: LegendOptions(
//                 showLegends: true,
//                 legendPosition: LegendPosition.bottom,
//                 showLegendsInRow: true,
//                 legendTextStyle: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               chartValuesOptions: ChartValuesOptions(
//                 showChartValuesInPercentage: true,
//                 showChartValuesOutside: true,
//                 decimalPlaces: 1,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               color: Colors.blue[50],
//               child: ListView.builder(
//                 itemCount: expenses.length,
//                 itemBuilder: (context, index) {
//                   Expense expense = expenses[index];
//                   // Calculate percentage dynamically
//                   double percentage = (expense.amount / totalExpenses) * 100;
//
//                   return Card(
//                     elevation: 4,
//                     margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.blue,
//                         child: Icon(
//                           expense.icon,
//                           color: Colors.white,
//                         ),
//                       ),
//                       title: Text(
//                         expense.category,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 4),
//                           Text(
//                             'Amount: \$${expense.amount.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               color: Colors.grey[700],
//                               fontSize: 16,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'Date & Time: ${expense.dateTime.toString()}',
//                             style: TextStyle(
//                               color: Colors.grey[700],
//                               fontSize: 16,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: LinearProgressIndicator(
//                                   value: percentage / 100,
//                                   backgroundColor: Colors.grey[300],
//                                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                                 ),
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 '${percentage.toStringAsFixed(2)}%',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../model/DataBase_Helper.dart';
class HistoryPage extends StatefulWidget {
  HistoryPage({required this.financialType});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
  final financialType;
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<FinancialItem>>? expenses ;

  Future<List<FinancialItem>> getFinancialItems(String type) async {
    DataBaseHelper dbHelper = DataBaseHelper.instance;

    List<Map<String, dynamic>> maps = await dbHelper.getFinancialValues(type);
    List<FinancialItem> items = [];
    for (Map<String, dynamic> map in maps) {
      items.add(FinancialItem(
        financialType: map['financial_type'],
        financialCategory: map['category'],
        financialAmount: map['amount'],
        financialAccount: map['account'],
        financialDateTime: map['datetime'],
      ));
    }
    return items;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expenses = getFinancialItems(widget.financialType);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: expenses,
          builder: (context,AsyncSnapshot<List<FinancialItem>> snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            else if(snapshot.data!.isEmpty){
              return  Center(child: Text("No Data Found"));
            }
            else{
              // Calculate total expenses
              double totalExpenses = snapshot.data!.fold(0, (previousValue, element) => previousValue + element.financialAmount);
              // Calculate percentages for each category
              Map<String, double> dataMap = {};
              snapshot.data!.forEach((expense) {
                dataMap[expense.financialCategory] = expense.financialAmount / totalExpenses;
              });
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: PieChart(
                      dataMap: dataMap,
                      chartRadius: MediaQuery.of(context).size.width / 3,
                      legendOptions: LegendOptions(
                        showLegends: true,
                        legendPosition: LegendPosition.bottom,
                        showLegendsInRow: true,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: true,
                        decimalPlaces: 1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.blue[50],
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          FinancialItem expense = snapshot.data![index];
                          // Calculate percentage dynamically
                          double percentage = (expense.financialAmount / totalExpenses) * 100;

                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  Icons.fastfood,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                expense.financialCategory,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    'Amount: \$${expense.financialAmount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Time: ${expense.financialDateTime.toString()}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          value: percentage / 100,
                                          backgroundColor: Colors.grey[300],
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '${percentage.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}


