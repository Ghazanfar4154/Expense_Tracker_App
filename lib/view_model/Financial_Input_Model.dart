import 'package:expense_tracker/model/DataBase_Helper.dart';
import 'package:flutter/material.dart';

enum FinancialType {
  none,
  Income,
  Expense
}
class FinancialInputModel{
  static FinancialType _type = FinancialType.none ;
  List<String> _incomeItems = ["Income 1", "Income 2", "Income 3",
    "Income 4", "Income 5", "Income 6"];
  List<String> _expenseItems = ["Expense 1", "Expense 2", "Expense 3",
    "Expense 4", "Expense 5", "Expense 6"];
  List<String> _accountsItems = ["Cash", "Card"];

  static String _selectedFinancialCategory ="Select Category" ;
  static String _selectedAccount ="Select Account" ;
  String get selectedCategory => _selectedFinancialCategory;
  String get selectedAccount => _selectedAccount;
  FinancialType get type => _type;
  List<String> get incomeItems => _incomeItems;
  List<String> get expenseItems => _expenseItems;
  List<String> get accountsType => _accountsItems;

  DataBaseHelper dataBaseHelper = DataBaseHelper.instance;


  List<String> getItems() {
   if(_type == FinancialType.Income)
     return incomeItems;
   else if(_type == FinancialType.Expense)
     return expenseItems;
   else
     return [];
  }

  void setType(FinancialType newType){
    _type = newType;
  }

  void reset(){
    _selectedFinancialCategory ="Select Category" ;
    _selectedAccount ="Select Account" ;
  }

  void resetFinancialType(){
    _type = FinancialType.none ;
  }

  void setSelectedCategory(String category){
    _selectedFinancialCategory = category;
  }

  void setSelectedAccount(String accountName){
    _selectedAccount = accountName;
  }

  void insertData(FinancialItem item) {
    dataBaseHelper.insert(item);
  }


  void readData() async{
    print(await dataBaseHelper.queryDatabase());
  }

}