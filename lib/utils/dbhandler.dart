import 'dart:io';
import 'package:path/path.dart';
import 'package:shopapp/model/orlderlistModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class DBHandler {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null && _database!.isOpen) {
      return _database;
    }
    try {
      final directory = await getApplicationDocumentsDirectory();
      String path = join(directory.path, 'mydb.db');
      print("Database path: $path");

      _database = await openDatabase(path, version: 1, onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Shop_Stock_Users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            USERNAME TEXT,
            PASSWORD TEXT,
            ROLE TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE Shop_Stock_StockMaster(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            SVRSTKID INTEGER,
            ORGAUTOID INTEGER,
            itm_CD INTEGER,
            PLUCODE TEXT,
            GENNAME TEXT,
            ProductGroup TEXT,
            itm_NAM TEXT,
            SalePrice INTEGER,
            WSPrice INTEGER,
            MRP INTEGER,
            PurPrice INTEGER,
            CostPrice INTEGER,
            EXPDTYN INTEGER,
            VatMaster TEXT,
            VatMasterOut TEXT,
            Stk_opn INTEGER,
            Stk_opn2 INTEGER,
            ALQTY INTEGER,
            UNITS TEXT,
            UNITS1 TEXT,
            Department TEXT,
            subgrp TEXT,
            Icompany TEXT,
            SUPLID INTEGER,
            PRERSUPL TEXT,
            DROPPED INTEGER,
            ISize TEXT,
            TYPE TEXT,
            DisplayGrp TEXT,
            DGID INTEGER,
            DGNDX INTEGER,
            ClrGroup TEXT,
            Material TEXT,
            IColor TEXT,
            NUMBERPERCASE INTEGER,
            LooseRate INTEGER,
            LoosQty INTEGER,
            Stk_Opn_Rate INTEGER,
            StockType TEXT,
            Cost INTEGER,
            Remarks1 TEXT,
            Remarks2 TEXT,
            Remarks3 TEXT,
            AddedBy INTEGER,
            AddedDTM TEXT,
            ModifyBy INTEGER,
            ModifyDTM TEXT,
            SOCID TEXT,
            STKCGSTRate INTEGER,
            STKSGSTRate INTEGER,
            STKIGSTRate INTEGER,
            STKGSTRate INTEGER,
            STKHSNCode INTEGER,
            GSTITMCD INTEGER,
            WSProfitPer INTEGER,
            RTLProfitPer INTEGER,
            SaleDisPer INTEGER,
            NUMBERPERCASE1 INTEGER,
            QtnMargPer INTEGER,
            QtnMargRate INTEGER,
            OldHsnCode INTEGER,
            SVRUPDYN INTEGER,
            CLIENTTRANSID TEXT,
            CLIENTPRFIX TEXT,
            STKSVRSTOCK INTEGER,
            STKDIVNUM INTEGER,
            FinalStock INTEGER,
            CatID INTEGER,
            Category TEXT,
            SubCatID INTEGER,
            SubCategory TEXT,
            PNID INTEGER,
            SizeID INTEGER,
            ProductWork TEXT,
            ProductStyle TEXT,
            ProductDupatta TEXT,
            ProductTL TEXT,
            ProductBL TEXT,
            ProductSL TEXT,
            ProductLining TEXT,
            YouTubeLink TEXT,
            DesignCode TEXT,
            DesignNo INTEGER
          )
        ''');
        db.execute('''
          CREATE TABLE ACC_AccountMaster(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            AccAutoID INTEGER,
            OrgAutoid INTEGER,
            Byr_Cd TEXT,
            Byr_nam TEXT,
            AccAddress TEXT,
            AccAddress1 TEXT,
            AccAddress2 TEXT,
            AccCity TEXT,
            AccState TEXT,
            PhoneNo TEXT,
            PinCode TEXT,
            EMAIL TEXT,
            LCNO TEXT,
            CMNT TEXT,
            GROUPS TEXT,
            GRPHANDLE TEXT,
            GRPUNDER TEXT,
            sbgrp TEXT,
            OPCRBLC INTEGER,
            OPDRBLC INTEGER,
            OPBLS INTEGER,
            COPBLS INTEGER,
            LTYPE TEXT,
            ACTYP TEXT,
            MSSB INTEGER,
            FOB1 TEXT,
            CNTRY1 TEXT,
            EMAIL2 TEXT,
            CONTACTPERSON TEXT,
            CONTACTTITLE TEXT,
            ACCOUNTNO TEXT,
            BALTYPE INTEGER,
            pcap INTEGER,
            MNGRP TEXT,
            PLBAL TEXT,
            LEDTYPE TEXT,
            TDSYN TEXT,
            CSTNO TEXT,
            STNO TEXT,
            TRANSPORT TEXT,
            CUSTYPE TEXT,
            ISDROPPED TEXT,
            RELTYPE TEXT,        
            RELID INTEGER,
            WORKTYPE TEXT,
            PANNO TEXT,
            VATNO TEXT,
            REFNO1 TEXT,
            REFNO2 TEXT,
            REFNO3 TEXT,
            ACCORGAUTOID INTEGER,
            NATURE TEXT,
            ImpCode INTEGER,
            SVRUPDYN INTEGER,
            CLIENTTRANSID TEXT,
            CLIENTPRFIX TEXT,
            MaxCreditDays INTEGER,
            MaxCreditAmount INTEGER,
            CLBalance INTEGER,
            CLBalColor TEXT,
            RecalcDate TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE CMS_Shop_OrderMaster(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            OrderID INTEGER,
            OrderNo INTEGER,
            OrderDate TEXT,
            PartyID TEXT,
            PartyClientID TEXT,
            PartyName TEXT,
            UserCode TEXT,
            UserAutoID TEXT,
            Remarks TEXT,
            AddedDate TEXT,
            VehicleNo TEXT,
            DelDate TEXT,
            AccPartyID TEXT,
            AccPartyName TEXT,
            EntryDateTime TEXT,
            TotAmount TEXT,
            DiscountAmt TEXT,
            GrossAmount TEXT,
            CGSTAmt TEXT,
            SGSTAmt TEXT,
            IGSTAmt TEXT,
            GSTAmt TEXT,
            RofAmt TEXT,
            NetAmount TEXT,
            OrderSource TEXT,
            FullOrderAmount TEXT,
            FlatDiscount TEXT,
            TotItemDiscount TEXT,
            CessAmt TEXT
            IsSynced INTEGER DEFAULT 0
          )
        ''');
        db.execute('''
          CREATE TABLE CMS_Shop_OrderDetails(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            OrderTransID INTEGER,
            OrderID INTEGER,
            SVRSTKID TEXT,
            itm_CD TEXT,
            OrderQty TEXT,
            OrderRate TEXT,
            SaleRate TEXT,
            OrderAmount TEXT,
            OrderRemarks TEXT,
            TrnAmount TEXT,
            Disper TEXT,
            ItemDisAmount TEXT,
            TrnGrossAmt TEXT,
            TrnCGSTAmt TEXT,
            TrnSGSTAmt TEXT,
            TrnIGSTAmt TEXT,
            TrnGSTAmt TEXT,
            TrnNetAmount TEXT,
            FreeQty TEXT,
            TotQty TEXT,
            TrnGSTPer TEXT,
            TrnCessPer TEXT,
            TrnCGSTPer TEXT,
            TrnSGSTPer TEXT,
            TrnIGSTPer TEXT,
            TrnCessAmt TEXT
          )
        ''');
      });
      await _ensureDefaultUser();
      return _database;
    } catch (e) {
      print("Error opening database: $e");
      return null;
    }
  }

  Future<void> _ensureDefaultUser() async {
    final db = await database;
    if (db == null) return;

    final result = await db.query('Shop_Stock_Users');

    if (result.isEmpty) {
      await db.insert(
        'Shop_Stock_Users',
        {
          'USERNAME': 'sadmin',
          'PASSWORD': '9656',
          'ROLE': 'Admin',
        },
      );
      print("Default user added: sadmin / 9656 / Admin");
    }
  }

  Future<Map<String, dynamic>?> validateUser(
      String username, String password, String role) async {
    final db = await database;
    if (db == null) return null;

    final List<Map<String, dynamic>> result = await db.query(
      'Shop_Stock_Users',
      where: 'USERNAME = ? AND PASSWORD = ? AND ROLE = ?',
      whereArgs: [username, password, role],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<List<String>> getAllTables(Database db) async {
    try {
      // Query the sqlite_master table to get all table names
      List<Map<String, dynamic>> tables = await db
          .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');

      // Filter out the 'android_metadata' table and system tables
      List<String> tableNames = tables
          .map((table) => table['name'] as String)
          .where((name) =>
              name != 'android_metadata' && !name.startsWith('sqlite_'))
          .toList();

      return tableNames;
    } catch (e) {
      print("Error fetching tables: $e");
      return [];
    }
  }

  Future<void> checkAllTables() async {
    Database? db = await database; // Open your database

    if (db != null) {
      // Fetch all tables excluding 'android_metadata' and SQLite system tables
      List<String> tableNames = await getAllTables(db);

      // Print the table names
      for (var table in tableNames) {
        print("Table: $table");
      }

      await db.close(); // Close the database
    }
  }

  Future<void> insertItemData(List<Map<String, dynamic>> data) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return;
    }

    try {
      Batch batch = db.batch();
      for (var record in data) {
        batch.insert('Shop_Stock_StockMaster', record,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit();
      print("Data inserted successfully.");
    } catch (e) {
      print("Error inserting data: $e");
    }
  }

  Future<void> insertPartyData(List<Map<String, dynamic>> data) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return;
    }

    try {
      Batch batch = db.batch();
      for (var record in data) {
        // Check if the record with the same AccAutoID already exists
        var existingRecord = await db.query(
          'ACC_AccountMaster',
          where: 'AccAutoID = ?',
          whereArgs: [record['AccAutoID']],
        );

        // If no record exists with the same AccAutoID, insert the new record
        if (existingRecord.isEmpty) {
          batch.insert('ACC_AccountMaster', record,
              conflictAlgorithm: ConflictAlgorithm.replace);
        } else {
          print("Record with AccAutoID ${record['AccAutoID']} already exists.");
        }
      }
      await batch.commit();
      print("Data inserted successfully.");
    } catch (e) {
      print("Error inserting data: $e");
    }
  }

  // Future<void> insertPartyData(List<Map<String, dynamic>> data) async {
  //   Database? db = await database;
  //   if (db == null) {
  //     print("Database not initialized.");
  //     return;
  //   }
  //
  //   try {
  //     Batch batch = db.batch();
  //     for (var record in data) {
  //       batch.insert('ACC_AccountMaster', record, conflictAlgorithm: ConflictAlgorithm.replace);
  //     }
  //     await batch.commit();
  //     print("Data inserted successfully.");
  //   } catch (e) {
  //     print("Error inserting data: $e");
  //   }
  // }

  Future<void> insertOrderData(Map<String, dynamic> data) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return;
    }

    try {
      await db.insert('CMS_Shop_OrderMaster', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("Order data inserted successfully.");
    } catch (e) {
      print("Error inserting order data: $e");
    }
  }

  // Future<void> insertOrderlistData(Map<String, dynamic> data) async {
  //   Database? db = await database;
  //   if (db == null) {
  //     print("Database not initialized.");
  //     return;
  //   }
  //
  //   try {
  //     await db.insert('CMS_Shop_OrderDetails', data, conflictAlgorithm: ConflictAlgorithm.replace);
  //     print("Order data inserted successfully.");
  //   } catch (e) {
  //     print("Error inserting order data: $e");
  //   }
  // }
  //
  // Future<void> insertOrderlistData(List<Map<String, dynamic>> data) async {
  //   Database? db = await database;
  //   if (db == null) {
  //     print("Database not initialized.");
  //
  //     return;
  //   }
  //
  //   try {
  //     // Insert multiple items into the table using a batch insert
  //     Batch batch = db.batch();
  //     for (var item in data) {
  //       batch.insert('CMS_Shop_OrderDetails', item, conflictAlgorithm: ConflictAlgorithm.replace);
  //     }
  //     await batch.commit();
  //     print("Order data inserted successfully.");
  //   } catch (e) {
  //     print("Error inserting order data: $e");
  //   }
  // }

  // ...existing code...

  Future<void> addIsSyncedColumn() async {
    final db = await database;
    if (db == null) return;

    try {
      // Attempt to add the column
      await db.execute(
          'ALTER TABLE CMS_Shop_OrderMaster ADD COLUMN IsSynced INTEGER DEFAULT 0');
      print('IsSynced column added successfully');
    } catch (e) {
      print('Error adding IsSynced column: $e');
    }
  }

  Future<int> updateOrderSyncStatus(int orderId, int syncStatus) async {
    await addIsSyncedColumn(); // Ensure column exists before updating

    final db = await database;
    if (db == null) {
      throw Exception("Database not initialized.");
    }

    return await db.update(
      'CMS_Shop_OrderMaster',
      {'IsSynced': syncStatus},
      where: 'OrderID = ?',
      whereArgs: [orderId],
    );
  }

// ...existing code...

  Future<void> insertOrderlistData(
      List<Map<String, dynamic>> data, orderid) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return;
    }

    try {
      // Delete existing records where OrderID == 4
      await db.delete(
        'CMS_Shop_OrderDetails',
        where: 'OrderID = ?',
        whereArgs: [orderid],
      );
      print("Records with OrderID == 4 deleted successfully.");

      // Insert multiple items into the table using a batch insert
      Batch batch = db.batch();
      for (var item in data) {
        batch.insert('CMS_Shop_OrderDetails', item,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit();
      print("Order data inserted successfully.");
    } catch (e) {
      print("Error inserting order data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> readItemData() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      List<Map<String, dynamic>> result =
          await db.query('Shop_Stock_StockMaster');
      print("Dfdfdfdfdf" + result.toString());
      return result;
    } catch (e) {
      print("Error reading data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> readPartyData() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      List<Map<String, dynamic>> result = await db.query('ACC_AccountMaster');
      return result;
    } catch (e) {
      print("Error reading data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> readOrderData() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      List<Map<String, dynamic>> result =
          await db.query('CMS_Shop_OrderMaster');
      return result;
    } catch (e) {
      print("Error reading order data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> readAllOrderlistData() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      List<Map<String, dynamic>> result =
          await db.query('CMS_Shop_OrderDetails');
      return result;
    } catch (e) {
      print("Error reading order data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> readOrderlistData({int? OrderID}) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      // Build the query conditionally based on the provided OrderID
      String query = 'SELECT * FROM CMS_Shop_OrderDetails';
      if (OrderID != null) {
        query += ' WHERE OrderID = $OrderID';
      }

      // Execute the query
      List<Map<String, dynamic>> result = await db.rawQuery(query);
      return result;
    } catch (e) {
      print("Error reading order data: $e");
      return [];
    }
  }

  // Close database connection
  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null; // Reset the database reference
      print("Database closed.");
    }
  }

  Future<List<Map<String, dynamic>>> userdata() async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return [];
    }

    try {
      String query = 'SELECT * FROM Shop_Stock_Users';
      List<Map<String, dynamic>> result = await db.rawQuery(query);
      print("User data: $result");
      return result;
    } catch (e) {
      print("Error reading user data: $e");
      return [];
    }
  }

  Future<int> deleteOrder(int orderId) async {
    Database? db = await database;
    if (db == null) {
      print("Database not initialized.");
      return 0;
    }

    try {
      return await db.delete(
        'CMS_Shop_OrderMaster',
        where: 'OrderID = ?',
        whereArgs: [orderId],
      );
    } catch (e) {
      print("Error deleting order: $e");
      return 0; // Return 0 to indicate failure
    }
  }

  Future<void> updateAccountAddress(int id, String newAccAddress) async {
    // Get a reference to the database
    final db = await database;

    // Update the record with the new AccAddress for the specific id
    await db!.update(
      'ACC_AccountMaster', // Table name
      {'AccAddress': newAccAddress}, // Fields to update
      where: 'id = ?', // WHERE condition to match the record
      whereArgs: [id], // The id to match
    );
  }
}
