import 'package:dhatch_front_end/model/customer.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  static Database? _db;
  final String _tableName = "customer";
  final String _customerPhoneNumber = "customerPhoneNumber";
  final String _customerName = "customerName";
  final String _customerGender = "customerGender";
  final String _customerEmail = "customerEmail";

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "customer_db.db");
    final database = openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_tableName (
        $_customerPhoneNumber TEXT PRIMARY KEY,
        $_customerName TEXT,
        $_customerGender TEXT,
        $_customerEmail TEXT
        )''');
      },
    );
    return database;
  }

  Future<void> addCustomer(String customerPhoneNumber) async {
    final db = await database;
    await db.insert(_tableName, {
      _customerPhoneNumber: customerPhoneNumber,
    });
  }

  Future<Customer> getCustomer(String customerPhoneNumber) async {
    final db = await database;
    final customerList = await db.query(_tableName,
        where: '_customerPhoneNumber = ?', whereArgs: [customerPhoneNumber]);
    final customer = customerList
        .map((e) => Customer(
              customerPhoneNumber: e['customerPhoneNumber'] as String,
              customerName: e['customerName'] as String,
              customerGender: e['customerGender'] as String,
              customerEmail: e['customerEmail'] as String,
            ))
        .toList()
        .first;
    return customer;
  }

  Future<void> updateCustomer(Customer customer) async {
    final db = await database;
    await db.update(
        _tableName,
        {
          _customerName: customer.customerName,
          _customerGender: customer.customerGender,
          _customerEmail: customer.customerEmail
        },
        where: '_customerPhoneNumber = ?',
        whereArgs: [customer.customerPhoneNumber]);
  }

  void deleteCustomer(String customerPhoneNumber) async {
    final db = await database;
    await db.delete(_tableName,
        where: '_customerPhoneNumber = ?', whereArgs: [customerPhoneNumber]);
  }
}
