// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseService {
//   static final DatabaseService instance = DatabaseService._constructor();

//   DatabaseService._constructor();

//   final String _tableName = "customer";
//   final String _customerPhoneNumber = "customerPhoneNumber";
//   final String _customerName = "customerName";
//   final String _customerGender = "customerGender";
//   final String _customerEmail = "customerEmail";

//   Future<Database> getDatabase() async {
//     final databaseDirPath = await getDatabasesPath();
//     final databasePath = join(databaseDirPath, "customer_db.db");
//     final database = openDatabase(
//       databasePath,
//       onCreate: (db, version) {
//         db.execute('''
//         CREATE TABLE $_tableName (
//         _customerPhoneNumber 
        
//         )
       
// ''');
//       },
//     );
//   }
// }
