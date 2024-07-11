import '../model/DataBase_Helper.dart';

class BudgetCategory {
  final String name;
  final double amountAllocated;
  final double amountSpent;

  BudgetCategory({
    required this.name,
    required this.amountAllocated,
    required this.amountSpent,
  });
}

class FinancialTotals {
  final double totalIncome;
  final double totalExpense;
  final List<BudgetCategory> budgets;

  FinancialTotals({
    required this.totalIncome,
    required this.totalExpense,
    required this.budgets,
  });
}

class HomePageModel {
  static Future<FinancialTotals> getFinancialTotals() async {
    DataBaseHelper db = DataBaseHelper.instance;
    Map<String, dynamic> totals = await db.getFinancialTotals();
    double totalIncome = totals['total_income'] ?? 0.0;
    double totalExpense = totals['total_expense'] ?? 0.0;

    // Retrieve budgets
    List<Map<String, dynamic>> budgetList = await db.getAllBudgets();
    List<BudgetCategory> budgets = [];
    for (var budgetData in budgetList) {
      budgets.add(BudgetCategory(
        name: budgetData['budget_name'],
        amountAllocated: budgetData['allocated_amount'],
        amountSpent: budgetData['spent_amount'],
      ));
    }

    return FinancialTotals(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      budgets: budgets,
    );
  }
}


// class HomePageModel {
//   static Future<FinancialTotals> getFinancialTotals() async {
//     // Simulated data
//     return FinancialTotals(
//       totalIncome: 1000.0,
//       totalExpense: 500.0,
//       budgets: [
//         BudgetCategory(
//           name: 'Groceries',
//           amountAllocated: 200.0,
//           amountSpent: 150.0,
//         ),
//         BudgetCategory(
//           name: 'Utilities',
//           amountAllocated: 150.0,
//           amountSpent: 100.0,
//         ),
//         BudgetCategory(
//           name: 'Entertainment',
//           amountAllocated: 100.0,
//           amountSpent: 80.0,
//         ),
//         BudgetCategory(
//           name: 'Transportation',
//           amountAllocated: 200.0,
//           amountSpent: 180.0,
//         ),
//         BudgetCategory(
//           name: 'Dining Out',
//           amountAllocated: 150.0,
//           amountSpent: 120.0,
//         ),
//       ],
//     );
//   }
// }