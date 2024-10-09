import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tsupply/MODEL/accountMasterModel.dart';
import 'package:tsupply/MODEL/advanceModel.dart';
import 'package:tsupply/MODEL/prodModel.dart';
import 'package:tsupply/MODEL/routeModel.dart';
import 'package:tsupply/MODEL/transMasterModel.dart';
import 'package:tsupply/MODEL/transdetailModel.dart';
import 'package:tsupply/MODEL/userModel.dart';

class TeaDB {
  DateTime date = DateTime.now();
  String? formattedDate;
  static final TeaDB instance = TeaDB._init();
  static Database? _database;
  TeaDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("marsproducts.db");
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    print("db---init");
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(
      path,
      version: 1, onCreate: _createDB,
      //  onUpgrade: _upgradeDB
    );
  }

  Future _createDB(Database db, int version) async {
    print("table created");
    ///////////////marsproducts store table ////////////////
    await db.execute('''
          CREATE TABLE routeDetailsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            rid INTEGER NOT NULL,
            routename TEXT,
            status INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE accountMasterTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            acid INTEGER NOT NULL,
            acc_code TEXT,
            acc_name TEXT,
            route INTEGER,
            status INTEGER,
            acc_master_type TEXT,
            acc_ser_code TEXT,
            acc_ext_place TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE UserMasterTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uid INTEGER NOT NULL,
            name TEXT,
            username TEXT,
            password TEXT,
            company_id INTEGER,
            branch_id INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE prodDetailsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pid INTEGER NOT NULL,
            product TEXT
           
          )
          ''');
    await db.execute('''
          CREATE TABLE TransMasterTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            trans_id INTEGER NOT NULL,
            trans_series TEXT,
            trans_date TEXT,
            trans_route_id TEXT,
            trans_party_id TEXT,
            trans_party_name TEXT,
            trans_remark TEXT,
            trans_bag_nos TEXT,
            trans_bag_weights TEXT,
            trans_import_id TEXT,
            company_id TEXT,
            branch_id TEXT,         
            user_session TEXT,
            log_user_id TEXT,
            log_date TEXT,
            status INTEGER    
          )
          ''');
    await db.execute('''
          CREATE TABLE TransDetailsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            trans_det_mast_id TEXT,
            trans_det_prod_id TEXT,
            trans_det_col_qty TEXT,
            trans_det_dmg_qty TEXT,
            trans_det_net_qty TEXT,
            trans_det_unit TEXT,
            trans_det_rate_id TEXT,		
            trans_det_value TEXT,		
            trans_det_import_id TEXT,
            company_id TEXT,
            branch_id TEXT,
            log_user_id TEXT,
            user_session TEXT,
            log_date TEXT,
            status INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE AdvanceTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            trans_id INTEGER NOT NULL,
            adv_series TEXT,
            adv_date TEXT,
            adv_route_id TEXT,
            adv_party_id TEXT,
            adv_party_name TEXT,
            adv_pay_mode TEXT,
            adv_pay_acc TEXT,
            adv_amt TEXT,
            adv_narration TEXT,
            adv_acc_date TEXT,
            adv_import_id TEXT,
            company_id TEXT,
            branch_id TEXT,  
            log_date TEXT,          
            status INTEGER
          )
          ''');
  }

////////////////////// staff route details insertion /////////////////////
  Future insertrouteDetails(RouteModel adata) async {
    final db = await database;
    var query3 =
        'INSERT INTO routeDetailsTable(rid, routename,status) VALUES(${adata.rid}, "${adata.routename}",${adata.status})';
    var res = await db.rawInsert(query3);
    print(query3);
    print(res);
    return res;
  }

  Future insertproductDetails(ProdModel pdata) async {
    final db = await database;
    var query3 =
        'INSERT INTO prodDetailsTable(pid, product) VALUES(${pdata.pid}, "${pdata.product}")';
    var res = await db.rawInsert(query3);
    print(query3);
    print(res);
    return res;
  }

  Future insertACmasterDetails(AccountMasterModel adata) async {
    final db = await database;
    var query3 =
        'INSERT INTO accountMasterTable(acid,acc_code,acc_name,route,status,acc_master_type,acc_ser_code,acc_ext_place) VALUES(${adata.id}, "${adata.acc_code}","${adata.acc_name}",${adata.route},${adata.status},"${adata.acc_master_type}","${adata.acc_ser_code}","${adata.acc_ext_place}")';
    var res = await db.rawInsert(query3);
    print(query3);
    print(res);
    return res;
  }

  Future insertUserDetails(UserModel udata) async {
    final db = await database;
    var query3 =
        'INSERT INTO UserMasterTable(uid,name,username,password,company_id,branch_id) VALUES(${udata.uid},"${udata.name}", "${udata.username}", "${udata.password}", ${udata.company_id}, ${udata.branch_id})';
    var res = await db.rawInsert(query3);
    print(query3);
    print(res);
    return res;
  }

  Future inserttransMasterDetails(TransMasterModel tdata) async {
    final db = await database;
    var query3 =
        'INSERT INTO TransMasterTable(trans_id, trans_series ,trans_date ,trans_route_id,trans_party_id ,trans_party_name,trans_remark ,trans_bag_nos ,trans_bag_weights ,trans_import_id ,company_id,branch_id ,user_session,log_user_id,log_date,status) VALUES(${tdata.tid}, "${tdata.trans_series}", "${tdata.trans_date}","${tdata.trans_route_id}", "${tdata.trans_party_id}", "${tdata.trans_party_name}", "${tdata.trans_remark}", "${tdata.trans_bag_nos}", "${tdata.trans_bag_weights}", "${tdata.trans_import_id}", "${tdata.company_id}", "${tdata.branch_id}", "${tdata.user_session}", "${tdata.log_user_id}", "${tdata.log_date}", ${tdata.status})';
    var res = await db.rawInsert(query3);
    print(query3);
    print(res);
    return res;
  }

  Future<int> insertTransDetail(TransDetailModel detail) async 
  {
    final db = await instance.database;

    var res = await db.insert('TransDetailsTable', detail.toMap());
    print("trans det insert----todb---$res");
    return res;
  }

  Future inserttransDetails(TransDetailModel ddata) async {
    final db = await database;
    var query3 =
        'INSERT INTO TransDetailsTable(trans_det_mast_id,trans_det_prod_id,trans_det_col_qty ,trans_det_dmg_qty ,trans_det_net_qty,trans_det_unit ,trans_det_import_id ,company_id ,branch_id,log_user_id,user_session,log_date,status) VALUES("${ddata.trans_det_mast_id}", "${ddata.trans_det_prod_id}","${ddata.trans_det_col_qty}","${ddata.trans_det_dmg_qty}","${ddata.trans_det_net_qty}","${ddata.trans_det_unit}","${ddata.trans_det_import_id}","${ddata.company_id}","${ddata.branch_id}","${ddata.log_user_id}","${ddata.user_session}","${ddata.log_date}",${ddata.status})';
    var res = await db.rawInsert(query3);
    print(query3);
    print(res);
    return res;
  }

  Future insertAdvancetoDB(AdvanceModel adata) async {
    final db = await database;
    var query3 =
        'INSERT INTO AdvanceTable(trans_id,adv_series,adv_date,adv_route_id,adv_party_id,adv_party_name,adv_pay_mode,adv_pay_acc,adv_amt,adv_narration,adv_acc_date,adv_import_id,company_id,branch_id,log_date,status) VALUES(${adata.adv_trans_id}, "${adata.adv_series}", "${adata.adv_date}","${adata.adv_route_id}", "${adata.adv_party_id}","${adata.adv_party_name}", "${adata.adv_pay_mode}", "${adata.adv_pay_acc}", "${adata.adv_amt}", "${adata.adv_narration}", "${adata.adv_acc_date}","${adata.adv_import_id}","${adata.company_id}","${adata.branch_id}","${adata.log_date}",${adata.status})';
    var res = await db.rawInsert(query3);
    print(query3);
    print(res);
    return res;
  }

  Future<List<Map<String, dynamic>>> getRoutefromDB(String? sid) async {
    List<Map<String, dynamic>> list = [];
    Database db = await instance.database;
    list = await db.rawQuery('SELECT rid,routename FROM routeDetailsTable');
    return list;
  }
  Future<List<Map<String, dynamic>>> getRouteNamefromDB(int? rid) async {
    List<Map<String, dynamic>> list = [];
    Database db = await instance.database;
    list = await db.rawQuery('SELECT routename FROM routeDetailsTable WHERE rid=$rid');
    return list;
  }

  Future<List<Map<String, dynamic>>> gettransMasterDetfromDB(int? tid) async {
    List<Map<String, dynamic>> list = [];
    Database db = await instance.database;
    list = await db.rawQuery(
        'SELECT trans_id,trans_series,trans_date,trans_route_id,trans_party_id,trans_party_name,trans_remark, trans_bag_nos,trans_bag_weights,trans_import_id, company_id,branch_id,user_session, log_user_id,log_date,status FROM TransMasterTable where trans_id=$tid');
    print("List===$list");
    return list;
  }

  Future<List<Map<String, dynamic>>> getSupplierListfromDB(String? serid) async {
    print("rid----> $serid");
    List<Map<String, dynamic>> list = [];
    Database db = await instance.database;
    if (serid == "" || serid!.isEmpty || serid.toString().toLowerCase()=="null") {
      list = await db.rawQuery(
          'SELECT acid,acc_code,acc_name,route,acc_ser_code,acc_ext_place FROM accountMasterTable where acc_master_type="SU"');
    } else {
      list = await db.rawQuery(
          'SELECT acid,acc_code,acc_name,route,acc_ser_code,acc_ext_place FROM accountMasterTable where acc_ser_code ="$serid" and acc_master_type="SU"');
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> getProductListfromDB() async {
    List<Map<String, dynamic>> list = [];
    Database db = await instance.database;
    list = await db.rawQuery('SELECT * FROM prodDetailsTable');
    return list;
  }

  Future<List<Map<String, dynamic>>> getUserListfromDB() async {
    List<Map<String, dynamic>> list = [];
    Database db = await instance.database;
    list = await db.rawQuery('SELECT * FROM UserMasterTable');
    return list;
  }

  Future<List<Map<String, dynamic>>> gettransMasterfromDB(
      String? conditn) async {
    List<Map<String, dynamic>> list = [];
    Database db = await instance.database;
    if (conditn == "yes") {
      list = await db.rawQuery(
          "SELECT trans_id, trans_series ,trans_date ,trans_route_id,trans_party_id ,trans_party_name,trans_remark ,trans_bag_nos,trans_bag_weights,trans_import_id,company_id,branch_id,user_session,log_user_id,log_date,status FROM TransMasterTable WHERE trans_import_id='0'");
    }
    // else if(conditn=="tid")
    // {
    //   list = await db.rawQuery(
    //       "SELECT trans_id, trans_series ,trans_date ,trans_party_id ,trans_party_name,trans_remark ,trans_bag_nos,trans_bag_weights,trans_import_id,company_id,branch_id,user_session,log_user_id,log_date,status FROM TransMasterTable WHERE trans_id=$tid");
    // }
    else {
      list = await db.rawQuery(
          "SELECT trans_id, trans_series ,trans_date,trans_route_id ,trans_party_id ,trans_party_name,trans_remark ,trans_bag_nos,trans_bag_weights,trans_import_id,company_id,branch_id,user_session,log_user_id,log_date,status FROM TransMasterTable");
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> gettransDetailsfromDB(
      String? conditn) async {
    List<Map<String, dynamic>> list = [];
    Database db = await instance.database;
    if (conditn == "yes") {
      list = await db.rawQuery(
          "SELECT trans_det_mast_id,trans_det_prod_id,trans_det_col_qty, trans_det_dmg_qty,trans_det_net_qty,trans_det_unit,trans_det_rate_id,trans_det_value,trans_det_import_id,company_id,branch_id,log_user_id,user_session,log_date,status FROM TransDetailsTable WHERE trans_det_import_id ='0'");
    } else {
      list = await db.rawQuery(
          "SELECT trans_det_mast_id,trans_det_prod_id,trans_det_col_qty, trans_det_dmg_qty,trans_det_net_qty,trans_det_unit,trans_det_rate_id,trans_det_value,trans_det_import_id,company_id,branch_id,log_user_id,user_session,log_date,status FROM TransDetailsTable");
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> getAdvanceDetailsfromDB(
      String? conditn) async {
    List<Map<String, dynamic>> list = [];
    Database db = await instance.database;
    if (conditn == "yes") {
      list = await db.rawQuery(
          "SELECT trans_id,adv_series,adv_date,adv_route_id,adv_party_id,adv_party_name,adv_pay_mode,adv_pay_acc,adv_amt,adv_narration,adv_acc_date,adv_import_id,company_id,branch_id,status FROM AdvanceTable WHERE adv_import_id ='0'");
    } else {
      list = await db.rawQuery(
          "SELECT trans_id,adv_series,adv_date,adv_route_id,adv_party_id,adv_party_name,adv_pay_mode,adv_pay_acc,adv_amt,adv_narration,adv_acc_date,adv_import_id,company_id,branch_id,status FROM AdvanceTable");
    }
    return list;
  }

  upadteCommonQuery(String table, String fields, String condition) async {
    Database db = await instance.database;
    print("condition for update...$table....$fields.............$condition");
    var query = 'UPDATE $table SET $fields WHERE $condition ';
    print("qyery-----$query");
    var res = await db.rawUpdate(query);
    print("response-update------$res");
    return res;
  }

  deleteFromTableCommonQuery(String table, String? condition) async {
    print("table--condition -$table---$condition");
    Database db = await instance.database;
    if (condition == null || condition.isEmpty || condition == "") {
      print("no condition");
      await db.delete('$table');
    } else {
      print("condition");

      await db.rawDelete('DELETE FROM "$table" WHERE $condition');
    }
  }

  getListOfTables() async {
    Database db = await instance.database;
    var list = await db.query('sqlite_master', columns: ['type', 'name']);
    print(list);
    list.map((e) => print(e["name"])).toList();
    return list;
  }

  getTableData(String tablename) async {
    Database db = await instance.database;
    print(tablename);
    var list = await db.rawQuery('SELECT * FROM $tablename');
    print(list);
    return list;
  }

  getMaxCommonQuery(String table, String field, String? condition) async {
    var res;
    int max;
    var result;
    Database db = await instance.database;
    print("condition---${condition}");
    if (condition == " ") {
      result = await db.rawQuery("SELECT * FROM '$table'");
    } else {
      result = await db.rawQuery("SELECT * FROM '$table' WHERE $condition");
    }
    // print("result max---$result");
    if (result != null && result.isNotEmpty) {
      if (condition == " ") {
        res = await db.rawQuery("SELECT MAX($field) max_val FROM '$table'");
      } else {
        res = await db.rawQuery(
            "SELECT MAX($field) max_val FROM '$table' WHERE $condition");
      }

      print('res[0]["max_val"] ----${res[0]["max_val"]}');
      // int convertedMax = int.parse(res[0]["max_val"]);
      max = res[0]["max_val"] + 1;
      print("max value.........$max");
      print("SELECT MAX($field) max_val FROM '$table' WHERE $condition");
    } else {
      print("else");
      max = 1;
    }
    print("max common-----$res");
    print(res);
    return max;
  }
}
