import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class FinancialItem {
  final String financialType;
  final String financialCategory;
  final double financialAmount;
  final String financialAccount;
  String? financialDateTime;

  FinancialItem({
    required this.financialType,
    required this.financialCategory,
    required this.financialAmount,
    required this.financialAccount,
    this.financialDateTime
  });
}

class Budget {
  final String budgetName;
  final double allocatedAmount;
  double spentAmount;

  Budget({
    required this.budgetName,
    required this.allocatedAmount,
    this.spentAmount = 0.0,
  });
}

class DataBaseHelper {
  static const dbName = "my.db";
  static const dbVersion = 1;
  static const itemTableName = "financialItems";
  static const totalTableName = "financialTotals";
  static const budgetTableName = "budgets";
  static final DataBaseHelper instance = DataBaseHelper();

  DataBaseHelper();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  onCreate(Database db, int versionNumber) async {
    await db.execute('''
      CREATE TABLE $itemTableName(
      financial_type TEXT NOT NULL,
      category TEXT NOT NULL,
      amount REAL NOT NULL,
      account TEXT,
      datetime TEXT PRIMARY KEY 
      )
      ''');

    await db.execute('''
      CREATE TABLE $totalTableName(
      total_expense REAL NOT NULL,
      total_income REAL NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE $budgetTableName(
      budget_name TEXT PRIMARY KEY,
      allocated_amount REAL NOT NULL,
      spent_amount REAL NOT NULL
      )
      ''');

    // Insert initial values for totals
    await db.rawInsert('''
      INSERT INTO $totalTableName (total_expense, total_income)
      VALUES (0.0, 0.0)
    ''');
  }

  insert(FinancialItem item) async {
    Database db = await instance.database;
    // Get current date and time
    DateTime now = DateTime.now();
    // Format date
    String formattedDate =
        "${now.year}-${_addLeadingZero(now.month)}-${_addLeadingZero(now.day)}";
    // Format time with seconds
    String formattedTime =
        "${_formatHour(now.hour)}:${_addLeadingZero(now.minute)}:${_addLeadingZero(now.second)} ${_getAmPm(now.hour)}";
    // Combine date and time
    String formattedDateTime = "$formattedDate $formattedTime";

    Map<String, dynamic> row = {
      'financial_type': item.financialType,
      'category': item.financialCategory,
      'amount': item.financialAmount,
      'account': item.financialAccount,
      'datetime': formattedDateTime,
    };

    await db.insert(itemTableName, row);
    // Update total_income if financialType is Income
    if (item.financialType == 'Income') {
      await db.rawUpdate('''
        UPDATE $totalTableName
        SET total_income = total_income + ?
      ''', [item.financialAmount]);
    }
    // Update total_expense if financialType is Expense
    else if (item.financialType == 'Expense') {
      await db.rawUpdate('''
        UPDATE $totalTableName
        SET total_expense = total_expense + ?
      ''', [item.financialAmount]);
      // Update budget spent amount
      await _updateBudgetSpent(item);
    }
  }

  Future<void> _updateBudgetSpent(FinancialItem item) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> budgetList = await db.query(budgetTableName,
        where: 'budget_name = ?', whereArgs: [item.financialCategory]);
    if (budgetList.isNotEmpty) {
      double allocatedAmount = budgetList.first['allocated_amount'];
      double currentSpent = budgetList.first['spent_amount'];
      double newSpent = currentSpent + item.financialAmount;

      if (newSpent <= allocatedAmount) {
        await db.rawUpdate('''
          UPDATE $budgetTableName
          SET spent_amount = ?
          WHERE budget_name = ?
        ''', [newSpent, item.financialCategory]);
      } else {
        print('Expense exceeds budget for ${item.financialCategory}');
      }
    }
  }

  String _addLeadingZero(int number) {
    if (number < 10) {
      return '0$number';
    }
    return number.toString();
  }

  String _formatHour(int hour) {
    if (hour == 0) {
      return '12';
    } else if (hour > 12) {
      return '${hour - 12}';
    } else {
      return '$hour';
    }
  }

  String _getAmPm(int hour) {
    return hour < 12 ? 'AM' : 'PM';
  }

  Future<List<Map<String, dynamic>>> getFinancialValues(String type) async {
    Database db = await instance.database;
    return await db.query(
      itemTableName,
      where: "financial_type = ?",
      whereArgs: [type],
    );
  }

  Future<List<Map<String, dynamic>>> getAllBudgets() async {
    Database db = await instance.database;
    return await db.query(budgetTableName);
  }

  Future<void> createBudget(String budgetName, double allocatedAmount) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> budgetList = await db.query(budgetTableName,
        where: 'budget_name = ?', whereArgs: [budgetName]);

    if (budgetList.isEmpty) {
      Map<String, dynamic> row = {
        'budget_name': budgetName,
        'allocated_amount': allocatedAmount,
        'spent_amount': 0.0,
      };
      await db.insert(budgetTableName, row);
    } else {
      print('Budget with name $budgetName already exists.');
    }
  }

  Future<Map<String, dynamic>> getFinancialTotals() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(totalTableName);
    return results.first;
  }

  Future<List<Map<String, dynamic>>> queryDatabase() async {
    return await getFinancialValues("Income");
  }

  Future<List<FinancialItem>> getAllFinancialItems() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> items = await db.query(itemTableName);
    return items.map((item) => FinancialItem(
        financialType: item['financial_type'],
        financialCategory: item['category'],
        financialAmount: item['amount'],
        financialAccount: item['account'],
        financialDateTime: item['datetime']
    )).toList();
  }

  Future<void> exportToCSV() async {
    List<FinancialItem> items = await getAllFinancialItems();
    String csv = "Financial Type,Category,Amount,Account,Date Time\n";
    items.forEach((item) {
      csv += "${item.financialType},${item.financialCategory},${item.financialAmount},${item.financialAccount},${item.financialDateTime}\n";
    });

    Directory directory = await getApplicationDocumentsDirectory();
    File file = File(join(directory.path, 'financial_items.csv'));
    await file.writeAsString(csv);
    print('CSV file exported successfully.');
  }

  Future<void> exportToExcel() async {
    try {
      List<FinancialItem> items = await getAllFinancialItems();

      // Create a new Excel document
      var excel = Excel.createExcel();

      // Add a worksheet
      Sheet sheetObject = excel['Sheet1'];

      // Write header row
      sheetObject.cell(CellIndex.indexByString("A1")).value = TextCellValue("Financial Type");
      sheetObject.cell(CellIndex.indexByString("B1")).value = TextCellValue("Category");
      sheetObject.cell(CellIndex.indexByString("C1")).value = TextCellValue("Amount");
      sheetObject.cell(CellIndex.indexByString("D1")).value = TextCellValue("Account");
      sheetObject.cell(CellIndex.indexByString("E1")).value = TextCellValue("Date Time");

      // Write data rows
      int rowIndex = 2; // Start from row 2 (after header)
      for (FinancialItem item in items) {
        sheetObject.cell(CellIndex.indexByString("A$rowIndex")).value = TextCellValue(item.financialType);
        sheetObject.cell(CellIndex.indexByString("B$rowIndex")).value = TextCellValue(item.financialCategory);
        sheetObject.cell(CellIndex.indexByString("C$rowIndex")).value = TextCellValue(item.financialAmount.toString());
        sheetObject.cell(CellIndex.indexByString("D$rowIndex")).value = TextCellValue(item.financialAccount);
        sheetObject.cell(CellIndex.indexByString("E$rowIndex")).value = TextCellValue(item.financialDateTime.toString());
        rowIndex++;
      }

      // Get external storage directory path
      Directory? externalDirectory = await getExternalStorageDirectory();
      if (externalDirectory != null) {
        String path = join(externalDirectory.path, 'financial_items.xlsx');

        // Save the Excel file
        var excelBytes = excel.encode();
        if (excelBytes != null) {
          File(path)
            ..createSync(recursive: true)
            ..writeAsBytesSync(excelBytes);
          print('Excel file exported successfully. Path: $path');
        } else {
          print('Error encoding Excel file.');
        }
      } else {
        print('Error accessing external storage directory.');
      }
    } catch (error) {
      print('Error exporting to Excel: $error');
    }
  }

}
