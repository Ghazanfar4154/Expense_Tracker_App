import 'package:expense_tracker/model/DataBase_Helper.dart';
import 'package:expense_tracker/view_model/Financial_Input_Model.dart';
import 'package:expense_tracker/view_model/Home_Page_Model.dart';
import 'package:expense_tracker/views/Home_Page.dart';
import 'package:flutter/material.dart';

class FinancialInput extends StatefulWidget {
  FinancialInput({super.key});
  @override
  State<FinancialInput> createState() => _FinancialInputState();
}

class _FinancialInputState extends State<FinancialInput> {
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FinancialInputModel financialInputModel = FinancialInputModel();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return HomePage();
            }));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Input Page"),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Choose Financial Type",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFinancialTypeOption(
                  context,
                  financialInputModel,
                  FinancialType.Income,
                ),
                _buildFinancialTypeOption(
                  context,
                  financialInputModel,
                  FinancialType.Expense,
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildCategorySelector(context, financialInputModel),
            SizedBox(height: 20),
            _buildAmountInput(),
            SizedBox(height: 20),
            _buildAccountSelector(context, financialInputModel),
            SizedBox(height: 20),
            _buildSaveButton(context, financialInputModel),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialTypeOption(BuildContext context, FinancialInputModel financialInputModel, FinancialType type) {
    return InkWell(
      onTap: () {
        setState(() {
          financialInputModel.setType(type);
          financialInputModel.reset();
        });
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: financialInputModel.type == type ? Colors.blue : Colors.white,
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          children: [
            Icon(
              type == FinancialType.Income ? Icons.attach_money : Icons.money_off,
              size: 30,
              color: financialInputModel.type == type ? Colors.white : Colors.black,
            ),
            SizedBox(height: 10),
            Text(
              type == FinancialType.Income ? "Income" : "Expense",
              style: TextStyle(
                fontSize: 18,
                color: financialInputModel.type == type ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context, FinancialInputModel financialInputModel) {
    return GestureDetector(
      onTap: () {
        List<String> items = financialInputModel.getItems();
        if (items.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Select financial category first."),
          ));
        } else {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text(items[index]),
                      onTap: () {
                        financialInputModel.setSelectedCategory(items[index]);
                        setState(() {
                        });
                        Navigator.pop(context);

                      },
                    );
                  },
                ),
              );
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          children: [
            Icon(Icons.category, size: 30, color: Colors.black),
            SizedBox(width: 20),
            Text(
              financialInputModel.selectedCategory,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(color: Colors.blue),
      ),
      child: TextField(
        controller: amountController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Enter amount here",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildAccountSelector(BuildContext context, FinancialInputModel financialInputModel) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) {
            List<String> items = financialInputModel.accountsType;
            return Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      setState(() {
                        financialInputModel.setSelectedAccount(items[index]);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          children: [
            Icon(Icons.account_balance, size: 30, color: Colors.black),
            SizedBox(width: 20),
            Text(
              financialInputModel.selectedAccount,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, FinancialInputModel financialInputModel) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          FinancialItem item = FinancialItem(
            financialType: financialInputModel.type.name.toString(),
            financialCategory: financialInputModel.selectedCategory.toString(),
            financialAmount: double.parse(amountController.text),
            financialAccount: financialInputModel.selectedAccount,
          );
          financialInputModel.insertData(item);
          financialInputModel.reset();
          financialInputModel.resetFinancialType();
          amountController.clear();

          setState(() {

          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(
          "Save",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
