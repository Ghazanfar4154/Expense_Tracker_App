import 'package:expense_tracker/view_model/Financial_Input_Model.dart';
import 'package:expense_tracker/view_model/Home_Page_Model.dart';
import 'package:expense_tracker/views/Financial_Input.dart';
import 'package:expense_tracker/views/History_Page.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../model/DataBase_Helper.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<FinancialTotals> financialTotals = HomePageModel.getFinancialTotals();

  Future<void> _exportToExcel(BuildContext context) async {
    try {
      await DataBaseHelper.instance.exportToExcel();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Excel file exported successfully.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting to Excel: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker Dashboard'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  title: Text('Save Excel'),
                  onTap: () {
                    _exportToExcel(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: financialTotals,
          builder: (context, AsyncSnapshot<FinancialTotals> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              FinancialTotals data = snapshot.data!;
              double income = data.totalIncome;
              double expenses = data.totalExpense;
              double remainingBalance = income - expenses;
              double percentSpent = (expenses / income) * 100;
              double percentRemaining = percentSpent;
              if (expenses == income) {
                percentRemaining = 0;
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        buildCard(
                          title: 'Total Income',
                          value: income,
                          color: Colors.green,
                          gradientColors: [Colors.green, Colors.teal],
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return HistoryPage(financialType: "Income");
                            }));
                          },
                        ),
                        SizedBox(height: 16),
                        buildCard(
                          title: 'Total Expenses',
                          value: expenses,
                          color: Colors.red,
                          gradientColors: [Colors.red, Colors.orange],
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return HistoryPage(financialType: "Expense");
                            }));
                          },
                        ),
                        SizedBox(height: 16),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Remaining Balance',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                LinearPercentIndicator(
                                  percent: percentRemaining / 100,
                                  animation: true,
                                  lineHeight: 20,
                                  center: Text(
                                    '\$${remainingBalance.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  linearStrokeCap: LinearStrokeCap.butt,
                                  progressColor: percentSpent >= 90 ? Colors.red : Colors.blue,
                                  backgroundColor: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Budgets',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.budgets.length,
                          itemBuilder: (context, index) {
                            BudgetCategory budget = data.budgets[index];
                            double percentFilled = (budget.amountSpent / budget.amountAllocated);
                            return buildBudgetCard(
                              name: budget.name,
                              amountAllocated: budget.amountAllocated,
                              amountSpent: budget.amountSpent,
                              percentFilled: percentFilled,
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            _showNewBudgetDialog(context);
                          },
                          child: Text('Create Budget'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Text("Data Not Found");
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) {
                return FinancialInput();
              }));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildCard({required String title, required double value, required Color color, required List<Color> gradientColors, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                '\$${value.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBudgetCard({
    required String name,
    required double amountAllocated,
    required double amountSpent,
    required double percentFilled,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Allocated: ${amountAllocated.toStringAsFixed(2)}\$',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Spent: ${amountSpent.toStringAsFixed(2)}\$',
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
              ],
            ),
            SizedBox(height: 8),
            LinearPercentIndicator(
              percent: percentFilled,
              animation: true,
              lineHeight: 20,
              center: Text(
                '${(percentFilled * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: Colors.greenAccent,
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showNewBudgetDialog(BuildContext context) {
    String categoryName = '';
    double amount = 0.0;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        FinancialInputModel financialInputModel = FinancialInputModel();
        return ListView.builder(
          itemCount: financialInputModel.expenseItems.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(financialInputModel.expenseItems[index]),
              onTap: () {
                setState(() {
                  categoryName = financialInputModel.expenseItems[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    ).then((value) {
      if (categoryName.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Create New Budget"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Category: $categoryName'),
                    TextField(
                      onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
                      decoration: InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (amount > 0) {
                      DataBaseHelper.instance.createBudget(categoryName, amount);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                        return HomePage();
                      }));
                      setState(() {});
                    } else {
                    }
                  },
                  child: Text('Create'),
                ),
              ],
            );
          },
        );
      }
    });
  }
}
