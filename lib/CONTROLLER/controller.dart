import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:tsupply/COMPONENTS/custom_snackbar.dart';
import 'package:tsupply/COMPONENTS/external_dir.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/MODEL/accountMasterModel.dart';
import 'package:tsupply/MODEL/advanceModel.dart';
import 'package:tsupply/MODEL/prodModel.dart';
import 'package:tsupply/MODEL/routeModel.dart';
import 'package:tsupply/MODEL/transMasterModel.dart';
import 'package:tsupply/MODEL/transdetailModel.dart';
import 'package:tsupply/MODEL/userModel.dart';

class Controller extends ChangeNotifier {
  //for postreg
  String? fp;
  String? cid;
  ExternalDir externalDir = ExternalDir();
  // List<CD> c_d = [];
  String? sof;
  bool isLoading = false;
  String? appType;
  String? tSeries;
  String? cname;
  ////////
  bool isdbLoading = true;
  List<Map<String, dynamic>> db_list = [];
  bool isYearSelectLoading = false;
  bool isLoginLoading = false;
  List<Map<String, dynamic>> logList = [];
  String? selectedSmName;
  Map<String, dynamic>? selectedItemStaff;
  bool isDBLoading = false;

  ////////////////////////////////////
  RouteModel routee = RouteModel();
  AccountMasterModel acnt = AccountMasterModel();
  UserModel usr = UserModel();
  ProdModel prod = ProdModel();
  AdvanceModel advmod = AdvanceModel();
  TransMasterModel transm = TransMasterModel();
  TransDetailModel transdt = TransDetailModel();
  String? selectedrut;
  String? selectedsuplier;
  Map<String, dynamic>? selectedSupplierMap;
  String? selectedUsrName;
  Map<String, dynamic>? selectedUserMap;
  List<Map<String, dynamic>> routeList = [];
  List<Map<String, dynamic>> spplierList = [];
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> importtransMasterList = [];
  List<Map<String, dynamic>> importtransDetailsList = [];
  List<Map<String, dynamic>> importAdvanceList = [];
  List<Map<String, dynamic>> prodList = [];
  List<Map<String, dynamic>> transdetailsList = [];
  List<Map<String, dynamic>> transmasterList = [];
  List<Map<String, dynamic>> finalSaveinnerList = [];
  List<Map<String, dynamic>> finalAdvanceinnerList = [];
  List<Map<String, dynamic>> finalSaveList = [];
  List<Map<String, dynamic>> finalBagList = [];
  List<Map<String, dynamic>> finalADVBagList = [];
  Map<String, dynamic> transMasterMap = {};
  Map<String, dynamic> advanceMasterMap = {};
  Map<String, dynamic> transDetailsMap = {};
  Map<String, dynamic> finalSaveMap = {};
  Map<String, dynamic> finalAdvanceMap = {};
  Map<String, dynamic> finalBagMap = {};
  Map<String, dynamic> editColctMap = {};
  Map<String, dynamic> editAdvnceMap = {};
  bool finalbagListloading = false;
  bool finaladvncebagloading = false;
  List<bool> downlooaded = [];
  List<bool> downloading = [];
  bool colluploaded = false;
  bool colluploading = false;
  bool advuploaded = false;
  bool advuploading = false;
  String? rootnmforEdit;
  List<String> downloadItems = [
    // "Download All",
    "Route",
    "Supplier Details",
    "Product Details",
    "User Details",
  ];

  List<TextEditingController> colected = [];
  List<TextEditingController> damage = [];
  List<TextEditingController> total = [];
  List<Map<String, dynamic>> filteredlist = [];
  bool isSearch = false;
  double? totalcollected = 0.0;
  Map<String, dynamic>? selectedPro;

  List<Widget> bagRows = [];
  List<Widget> donRows = [];
  List<TextEditingController> controllers = [];
  double totalwgt = 0.0;
  int totalBagCount = 0;
  // List<Map<TextEditingController, bool>> controllers = [];
  // List<bool> isDoneEnabled = [];
  List<ValueNotifier<bool>> isDoneEnabled = [];
  int currentBagCount = 1;
  List<Map<String, dynamic>> perKgList = [
    {"idd": 1, "type": "Percentage"},
    {"idd": 2, "type": "KG"}
  ];
  Map<String, dynamic>? selectedwgt = {"idd": 1, "type": "Percentage"};

  setdownflag() {
    downlooaded = List.generate(downloadItems.length, (index) => false);
    downloading = List.generate(downloadItems.length, (index) => false);
    notifyListeners();
  }

  addNewBagRow(BuildContext context) async {
    TextEditingController newController = TextEditingController();
    controllers.add(newController);
    ValueNotifier<bool> doneNotifier = ValueNotifier(false);
    isDoneEnabled.add(doneNotifier);
    bool isRowCompleted = false;
    totalBagCount=0;
    notifyListeners();
    bagRows.add(
      Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(
              " Bag $currentBagCount  ",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: 140,
              height: 55,
              child: TextFormField(
                onChanged: (valu) async {
                  // When the input is valid, enable the "done" button
                  if (valu.toString().isNotEmpty &&
                      int.tryParse(valu.toString()) != null &&
                      int.parse(valu.toString()) > 0) {
                    if (!isRowCompleted) {
                      print("-------------val>0");
                      doneNotifier.value = true;
                      await calculateTotalWeight();
                      // await setIsDoneEnable(true, newController);
                      notifyListeners();
                    }
                  } else {
                    print("-------------val=====0");
                    doneNotifier.value = false;
                    if (valu.toString().isNotEmpty &&
                        int.tryParse(valu.toString()) != null &&
                        int.parse(valu.toString()) < 0) {
                      CustomSnackbar snackbar = CustomSnackbar();
                      snackbar.showSnackbar(
                          context, "Weight must be greater than zero", "");
                    }
                    // await setIsDoneEnable(false, newController);
                    notifyListeners();
                  }
                },
                controller: newController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Bag $currentBagCount',
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: doneNotifier,
              builder: (context, value, child) {
                return IconButton(
                  icon: Icon(
                    Icons.done,
                    color: value
                        ? Colors.green
                        : Colors.grey, // Button is greyed out when disabled
                  ),
                  onPressed: value
                      ? () async {
                          isRowCompleted = true;
                          await onDonePressed(context);
                          doneNotifier.value = false;
                          // await setIsDoneEnable(false, newController);
                          notifyListeners();
                        }
                      : null, // Call when "done" button is pressed
                );
              },
            ),
          ],
        ),
      ),
    );

    // Refresh the UI to display the new row
    currentBagCount++; // Increment the bag count for the next row
    totalBagCount=currentBagCount-1;
    notifyListeners();
    print("total bag count=${totalBagCount}");
    notifyListeners();
  }

  calculateTotalWeight() {
    totalwgt = 0.0;
    for (var controller in controllers) {
      double? value = double.tryParse(controller.text.toString().trim());
      if (value != null) {
        totalwgt += value;
      }
    }
    notifyListeners(); // Notify listeners to update the UI if needed
  }

  // setIsDoneEnable(bool val, TextEditingController newController) {
  //   isDoneEnabled[controllers.indexOf(newController)] = val;

  //   notifyListeners();
  //   print(
  //       "--done ?-------------${isDoneEnabled[controllers.indexOf(newController)]}");
  // }

  onDonePressed(BuildContext context) {
    addNewBagRow(
        context); // Add a new bag row (TextFormField and "done" button)
    notifyListeners();
  }

  getAllDetails(int index, String page, BuildContext context) async {
    try {
      downloading[index] = true;
      notifyListeners();
      await getRouteDetails(0, "", context);
      await getACMasterDetails(0, "");
      downloading[index] = false;
      downlooaded[index] = true;
      notifyListeners();
    } catch (e) {
      downloading[index] = false;
      if (e is SocketException) {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "SocketException: No route to host", "");
        print('SocketException: ${e.message}');
        print('Failed to connect to the server.');
      } else if (e is ClientException) {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('ClientException: ${e.message}');
      } else {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('Unknown error: $e');
      }
      // CustomSnackbar snak = CustomSnackbar();
      // snak.showSnackbar(context, "${e.toString()}", "");
      // print('General Exception: $e');
    }
  }

  Future<RouteModel?> getRouteDetails(
      int index, String page, BuildContext context) async {
    // print("cid...............${cid}");
    try {
      downloading[index] = true;
      notifyListeners();
      // Uri url = Uri.parse("http://192.168.18.168:7000/api/load_routes");
      Uri url = Uri.parse("http://teasoft.trafiqerp.in/api/load_routes");

      ///http://teasoft.trafiqerp.in
      // // SharedPreferences prefs = await SharedPreferences.getInstance();
      // // String? br_id1 = prefs.getString("br_id");

      Map body = {'cid': ""};

      http.Response response = await http.post(
        url,
        body: body,
      );

      print("body ${body}");
      var map = jsonDecode(response.body);
      print("route Map--> $map");
      if (map != null) {
        await TeaDB.instance
            .deleteFromTableCommonQuery('routeDetailsTable', "");
        // List map = [
        //   {"id": 1, "name": "Kannur", "status": 0},
        //   {"id": 2, "name": "Thalassery", "status": 0},
        //   {"id": 3, "name": "Mattannur", "status": 0}
        // ];

        for (var routee in map) {
          print("routeeee----${routee.length}");
          routee = RouteModel.fromJson(routee);
          var rote = await TeaDB.instance.insertrouteDetails(routee);
          print("inserted ${rote}");
        }
        downloading[index] = false;
        downlooaded[index] = true;
        getRoute(" ", context);
        notifyListeners();
        return routee;
      } else {
        print("route Map null");
      }
    } catch (e) {
      downloading[index] = false;
      if (e is SocketException) {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "SocketException: No route to host", "");
        print('SocketException: ${e.message}');
        print('Failed to connect to the server.');
      } else if (e is ClientException) {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('ClientException: ${e.message}');
      } else {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('Unknown error: $e');
      }
      // CustomSnackbar snak = CustomSnackbar();
      // snak.showSnackbar(context, "${e.toString()}", "");
      // print('General Exception: $e');
    }
  }

  // savetransmaster(Map<String, dynamic> mstr) async {
  //   filteredlist.clear();
  //   finalSaveMap.clear();
  //   notifyListeners();
  //   print("trans_id----------${mstr["trans_id"].toString()}");
  //   finalSaveinnerList.add(mstr);
  //   finalSaveMap['transactions'] = finalSaveinnerList;
  //   notifyListeners();
  //   print("final LIST=---------------$finalSaveinnerList");
  //   print(
  //       "final MAP=---------------$finalSaveMap"); //  //  save-api format of transaction

  //   finalSavetoapi(finalSaveMap);

  //   transdetailsList.clear();
  // }
  geTseries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tSeries = await prefs.getString("t_series");
    notifyListeners();
  }

  importFinal(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ts = prefs.getString("t_series");
    String? unm = prefs.getString("uname");
    colluploading = true;
    finalSaveList.clear();
    finalSaveMap.clear();
    finalSaveinnerList.clear(); // Clear finalSaveinnerList at the beginning
    notifyListeners();

    print("Master List: $importtransMasterList");
    print("Details List: $importtransDetailsList");

    for (var i = 0; i < importtransMasterList.length; i++) {
      // matermap.clear();
      // if (transfiltered!.isEmpty) {
      Map<String, dynamic> matermap = {};
      notifyListeners();
      int transid = importtransMasterList[i]["trans_id"];
      print("Processing trans_id: $transid");
      String mastrid = "$ts$transid";
      print("Generated mastrid: $mastrid");
      matermap = Map.from(importtransMasterList[i]); //hidden_status
      matermap["trans_id"] = importtransMasterList[i]["trans_id"];
      matermap["trans_series"] = importtransMasterList[i]["trans_series"];
      matermap["trans_date"] = importtransMasterList[i]["trans_date"];
      matermap["trans_route_id"] = importtransMasterList[i]["trans_route_id"];
      matermap["trans_party_id"] = importtransMasterList[i]["trans_party_id"];
      matermap["trans_party_name"] =
          importtransMasterList[i]["trans_party_name"];
      matermap["trans_remark"] = importtransMasterList[i]["trans_remark"];
      matermap["trans_bag_nos"] = importtransMasterList[i]["trans_bag_nos"];
      matermap["trans_bag_weights"] =
          importtransMasterList[i]["trans_bag_weights"];
      matermap["trans_import_id"] = importtransMasterList[i]["trans_import_id"];
      matermap["company_id"] = importtransMasterList[i]["company_id"];
      matermap["branch_id"] = importtransMasterList[i]["branch_id"];
      matermap["user_session"] = importtransMasterList[i]["user_session"];
      matermap["log_user_id"] = importtransMasterList[i]["log_user_id"];
      matermap["hidden_status"] = "0";
      matermap["row_id"] = "0";
      matermap["log_user_name"] = unm;
      matermap["log_date"] = importtransMasterList[i]["log_date"];
      matermap["status"] = importtransMasterList[i]["status"];
      List<Map<String, dynamic>> detailsList = [];
      for (var j = 0; j < importtransDetailsList.length; j++) {
        print(
            "Checking details for mastrid: $mastrid and trans_det_mast_id: ${importtransDetailsList[j]["trans_det_mast_id"]}");
        // Check if the detail belongs to the current master entry
        if (importtransDetailsList[j]["trans_det_mast_id"].toString() ==
            mastrid) {
          detailsList.add(importtransDetailsList[j]);
        }
      }

      // Attach details to the master entry if available
      if (detailsList.isNotEmpty) {
        matermap["details"] = detailsList;
        finalSaveinnerList.add(matermap);
        // matermap.clear();
        print("Added master with details: $matermap");
      } else {
        print("No details found for trans_id: $transid");
      }
      notifyListeners();
    }
    // Prepare final save map and list
    finalSaveMap['transactions'] = finalSaveinnerList;
    print("Final MAP: $finalSaveMap"); // API-ready map format
    finalSaveList.add(finalSaveMap);
    print("Final LIST: $finalSaveList");
    print("Final LIST length: ${finalSaveList.length}");
    notifyListeners();
    // Send data to API
    finalSaveColltoAPI(finalSaveMap, context); //uncomented in future
  }

  finalSaveColltoAPI(
      Map<String, dynamic> mappfinal, BuildContext context) async {
    print(jsonEncode("Save Map----- > $mappfinal"));
    var mapBody = jsonEncode(mappfinal);
    Uri url = Uri.parse("http://teasoft.trafiqerp.in/api/Trans_Save");
    Map body = {'json_arr': mapBody};
    http.Response response = await http.post(
      url,
      body: body,
    );

    print("save body ${body}");
    print("respons det ${response}");
    print("respons type ${response.runtimeType}");
    // String jsonsDataString = response.body.toString(); // toString of Response's body is assigned to jsonDataString
    // var map  = jsonDecode(jsonsDataString);

    Map map = jsonDecode(response.body);
    // Map map = {
    //   "flag": 0,
    //   "msg": "Insertion Done",
    //   "ret_arr": {2: "AB16", 3: "AB17"}
    // };

    print("save ResultMap--> $map");
    if (map['flag'] == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ts = prefs.getString("t_series");
      print("success");
      Map retArr = map['ret_arr'];
      print("-------$retArr");
      retArr.forEach((key, value) async {
        var acc = await TeaDB.instance.upadteCommonQuery(
            'TransMasterTable', "trans_import_id='$value'", "trans_id=$key");
        var acc1 = await TeaDB.instance.upadteCommonQuery('TransDetailsTable',
            "trans_det_import_id='$value'", "trans_det_mast_id='$ts$key'");
        print('Key: $key, Value: $value');
      });
      colluploading = false;
      colluploaded = true;
      await gettransMastersfromDB("yes");
      await gettransDetailsfromDB("yes");
      notifyListeners();
      // await importFinal2(context, []);
    } else {
      CustomSnackbar snak = CustomSnackbar();
      snak.showSnackbar(context, "Import Failed", "");
    }
  }

  importFinal2(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ts = prefs.getString("t_series");
    String? unm = prefs.getString("uname");
    finalbagListloading = true;
    finalBagList.clear();
    finalBagMap.clear();
    List<Map<String, dynamic>> innerlist = [];
    // finalSaveinnerList.clear(); // Clear finalSaveinnerList at the beginning
    notifyListeners();
    print("Master List: $importtransMasterList");
    print("Details List: $importtransDetailsList");

    for (var i = 0; i < importtransMasterList.length; i++) {
      // matermap.clear();
      // if (transfiltered!.isEmpty) {
      Map<String, dynamic> matermap = {};
      notifyListeners();
      int transid = importtransMasterList[i]["trans_id"];
      print("Processing trans_id: $transid");
      String mastrid = "$ts$transid";
      print("Generated mastrid: $mastrid");
      matermap = Map.from(importtransMasterList[i]); //hidden_status
      matermap["trans_id"] = importtransMasterList[i]["trans_id"];
      matermap["trans_series"] = importtransMasterList[i]["trans_series"];
      matermap["trans_date"] = importtransMasterList[i]["trans_date"];
      matermap["trans_route_id"] = importtransMasterList[i]["trans_route_id"];
      matermap["trans_party_id"] = importtransMasterList[i]["trans_party_id"];
      matermap["trans_party_name"] =
          importtransMasterList[i]["trans_party_name"];
      matermap["trans_remark"] = importtransMasterList[i]["trans_remark"];
      matermap["trans_bag_nos"] = importtransMasterList[i]["trans_bag_nos"];
      matermap["trans_bag_weights"] =
          importtransMasterList[i]["trans_bag_weights"];
      matermap["trans_import_id"] = importtransMasterList[i]["trans_import_id"];
      matermap["company_id"] = importtransMasterList[i]["company_id"];
      matermap["branch_id"] = importtransMasterList[i]["branch_id"];
      matermap["user_session"] = importtransMasterList[i]["user_session"];
      matermap["log_user_id"] = importtransMasterList[i]["log_user_id"];
      matermap["hidden_status"] = "0";
      matermap["row_id"] = "0";
      matermap["log_user_name"] = unm;
      matermap["log_date"] = importtransMasterList[i]["log_date"];
      matermap["status"] = importtransMasterList[i]["status"];
      List<Map<String, dynamic>> detailsList = [];
      for (var j = 0; j < importtransDetailsList.length; j++) {
        print(
            "Checking details for mastrid: $mastrid and trans_det_mast_id: ${importtransDetailsList[j]["trans_det_mast_id"]}");
        // Check if the detail belongs to the current master entry
        if (importtransDetailsList[j]["trans_det_mast_id"].toString() ==
            mastrid) {
          detailsList.add(importtransDetailsList[j]);
        }
      }

      // Attach details to the master entry if available
      if (detailsList.isNotEmpty) {
        matermap["details"] = detailsList;
        innerlist.add(matermap);
        // matermap.clear();
        print("Added master with details: $matermap");
      } else {
        print("No details found for trans_id: $transid");
      }
      notifyListeners();
    }
    // Prepare final save map and list
    finalBagMap['transactions'] = innerlist;
    print("FinalBag MAP: $finalBagMap"); // API-ready map format
    finalBagList.add(finalBagMap);
    print("finalBag LIST: $finalBagList");
    print("finalBagList length: ${finalBagList.length}");
    finalbagListloading = false;
    notifyListeners();
    // Send data to API
    // finalSavetoapi(finalBagMap); //uncomented in future
  }

  importAdvanceBag(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ts = prefs.getString("t_series");
    String? unm = prefs.getString("uname");
    int? uid = prefs.getInt("u_id");
    String? logdate = prefs.getString("log_date");
    finalbagListloading = true;
    finalADVBagList.clear();
    Map<String, dynamic> finaladvncmap = {};
    List<Map<String, dynamic>> innerlist = [];
    notifyListeners();
    print("Advance Master List: $importAdvanceList");
    for (var i = 0; i < importAdvanceList.length; i++) {
      Map<String, dynamic> matermap = {};
      notifyListeners();
      matermap["adv_series"] = importAdvanceList[i]["adv_series"];
      matermap["adv_route_id"] = importAdvanceList[i]["adv_route_id"];
      matermap["adv_party_id"] = importAdvanceList[i]["adv_party_id"];
      matermap["adv_party_name"] = importAdvanceList[i]["adv_party_name"];
      matermap["trans_id"] = importAdvanceList[i]["trans_id"];
      matermap["adv_pay_mode"] = importAdvanceList[i]["adv_pay_mode"];
      matermap["adv_pay_acc"] = importAdvanceList[i]["adv_pay_acc"];
      matermap["adv_amt"] = importAdvanceList[i]["adv_amt"];
      matermap["adv_narration"] = importAdvanceList[i]["adv_narration"];
      matermap["adv_accountable_date"] = importAdvanceList[i]["adv_acc_date"];
      matermap["adv_voucher_no"] = "";
      matermap["company_id"] = importAdvanceList[i]["company_id"];
      matermap["branch_id"] = importAdvanceList[i]["branch_id"];
      matermap["user_session"] = "";
      matermap["log_user_id"] = uid.toString();
      matermap["log_date"] = logdate;
      matermap["adv_import_id"] = importAdvanceList[i]["adv_import_id"];
      matermap["log_user_name"] = unm;
      matermap["hidden_status"] = "0";
      matermap["row_id"] = "0";
      innerlist.add(matermap);
    }
    finaladvncmap['transactions'] = innerlist;
    print("Final ADV BAG: $finaladvncmap");
    finalADVBagList.add(finaladvncmap);
    finaladvncebagloading = false;
    notifyListeners();
  }

  // finalsavePrepering(BuildContext context, List? transfiltered){
  // }
  // finalSavetoapiFiltered(BuildContext context, List<int>? transfiltered) async {
  //   Map<String, dynamic> newMap = {"transactions": []};
  //   // Step 1: Filter the transactions where trans_id is in the list transIdsToCheck
  //   List<dynamic> matchingTransactions = finalBagMap['transactions']
  //       .where(
  //           (transaction) => transfiltered!.contains(transaction['trans_id']))
  //       .toList();
  //   print("mtachnng== $matchingTransactions");
  //   // Step 2: Add the updated transaction to newMap if trans_id = 1 is found
  //   if (matchingTransactions.isNotEmpty) {
  //     matchingTransactions.forEach((transaction) {
  //       newMap['transactions'].add(transaction); // Add other transactions as is
  //     });
  //   }

  //   // Print the new map with updated transactions
  //   print(jsonEncode("nnnnnnnnnnnnnn$newMap"));

  //   var mapBody = jsonEncode(newMap);
  //   Uri url = Uri.parse("http://192.168.18.168:7000/api/Trans_Save");
  //   Map body = {'json_arr': mapBody};
  //   http.Response response = await http.post(
  //     url,
  //     body: body,
  //   );
  //   print("save body ${body}");
  //   print("respons type ${response.runtimeType}");
  //   Map map = jsonDecode(response.body);
  //   // Map map = {
  //   //   "flag": 0,
  //   //   "msg": "Insertion Done",
  //   //   "ret_arr": {2: "AB16", 3: "AB17"}
  //   // };
  //   print("save Map--> $map");
  //   if (map['flag'] == 0) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? ts = prefs.getString("t_series");
  //     print("success");
  //     Map retArr = map['ret_arr'];
  //     print("-------$retArr");
  //     retArr.forEach((key, value) async {
  //       var acc = await TeaDB.instance.upadteCommonQuery(
  //           'TransMasterTable', "trans_import_id='$value'", "trans_id=$key");
  //       var acc1 = await TeaDB.instance.upadteCommonQuery('TransDetailsTable',
  //           "trans_det_import_id='$value'", "trans_det_mast_id='$ts$key'");
  //       print('Key: $key, Value: $value');
  //     });

  //     await gettransMastersfromDB();
  //     await gettransDetailsfromDB();
  //     await importFinal2(context, []);
  //   } else {
  //     CustomSnackbar snak = CustomSnackbar();
  //     snak.showSnackbar(context, "Import Failed", "");
  //   }
  // }

  deleteTrans(int t_id, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ts = prefs.getString("t_series");
    print('tran_id: $t_id');
    var acc = await TeaDB.instance
        .deleteFromTableCommonQuery('TransMasterTable', "trans_id=$t_id");
    var acc1 = await TeaDB.instance.deleteFromTableCommonQuery(
        'TransDetailsTable', "trans_det_mast_id='$ts$t_id'");
    await gettransMastersfromDB("");
    await gettransDetailsfromDB("");
    await importFinal2(context);
    notifyListeners();
  }

  deleteAdvance(int t_id, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ts = prefs.getString("t_series");
    print('tran_id: $t_id');
    var acc = await TeaDB.instance
        .deleteFromTableCommonQuery('AdvanceTable', "trans_id=$t_id");
    await getAdvanceDetailsfromDB("yes");
    await importAdvanceBag(context);
    notifyListeners();
  }
// importFinal() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? ts = prefs.getString("t_series");
  //   finalSaveList.clear();
  //   finalSaveMap.clear();
  //   notifyListeners();

  //   Map<String, dynamic> matermap = {};
  //   for (var i = 0; i < importtransMasterList.length; i++) {
  //     matermap.clear();
  //     notifyListeners();
  //     int transid = importtransMasterList[i]["trans_id"];
  //     print("transddd==$transid");
  //     String mastrid = "$ts$transid";
  //     matermap = Map.from(importtransMasterList[i]);
  //     // matermap = importtransMasterList[i];
  //     List<Map<String, dynamic>> detailsList = [];
  //     for (var j = 0; j < importtransDetailsList.length; j++) {
  //       if (importtransDetailsList[j]["trans_det_mast_id"].toString() ==
  //           mastrid) {
  //         detailsList.add(importtransDetailsList[j]);
  //       }
  //     }
  //     matermap["details"] = detailsList;
  //     notifyListeners();
  //     print("mastreMap====$matermap");

  //     notifyListeners();
  //     print("trans_id----------${matermap["trans_id"].toString()}");
  //     finalSaveinnerList.add(matermap);

  //     notifyListeners();
  //   }
  //   print("final INNER LIST=---------------$finalSaveinnerList");
  //   finalSaveMap['transactions'] = finalSaveinnerList;
  //   print(
  //       "final MAP=---------------$finalSaveMap"); //  //  save-api format of transaction

  //   finalSaveList.add(finalSaveMap);
  //   notifyListeners();
  //   print("final LIST=---------------$finalSaveList");
  //   print("final LIST length=---------------${finalSaveList.length}");
  //   // transdetailsList.clear();
  //   finalSavetoapi(finalSaveMap);
  // }

  importAdvanceFinal(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ts = prefs.getString("t_series");
    String? unm = prefs.getString("uname");
    int? uid = prefs.getInt("u_id");
    String? logdate = prefs.getString("log_date");
    advuploading = true;
    finalAdvanceMap.clear();
    finalAdvanceinnerList.clear();
    notifyListeners();
    print("Advance Master List: $importAdvanceList");
    for (var i = 0; i < importAdvanceList.length; i++) {
      Map<String, dynamic> matermap = {};
      notifyListeners();
      matermap["adv_series"] = importAdvanceList[i]["adv_series"];
      matermap["adv_route_id"] = importAdvanceList[i]["adv_route_id"];
      matermap["adv_party_id"] = importAdvanceList[i]["adv_party_id"];
      matermap["trans_id"] = importAdvanceList[i]["trans_id"];
      matermap["adv_pay_mode"] = importAdvanceList[i]["adv_pay_mode"];
      matermap["adv_pay_acc"] = importAdvanceList[i]["adv_pay_acc"];
      matermap["adv_amt"] = importAdvanceList[i]["adv_amt"];
      matermap["adv_accountable_date"] = importAdvanceList[i]["adv_acc_date"];
      matermap["adv_voucher_no"] = "";
      matermap["company_id"] = importAdvanceList[i]["company_id"];
      matermap["branch_id"] = importAdvanceList[i]["branch_id"];
      matermap["user_session"] = "";
      matermap["log_user_id"] = uid.toString();
      matermap["log_date"] = logdate;
      matermap["adv_import_id"] = importAdvanceList[i]["adv_import_id"];
      matermap["log_user_name"] = unm;
      matermap["hidden_status"] = "0";
      matermap["row_id"] = "0";

      finalAdvanceinnerList.add(matermap);
    }

    finalAdvanceMap['transactions'] = finalAdvanceinnerList;
    print("Final ADV MAP: $finalAdvanceMap");
    notifyListeners();

    finalSaveADVtoAPI(finalAdvanceMap, context);
  }

  finalSaveADVtoAPI(
      Map<String, dynamic> mappfinal, BuildContext context) async {
    print(jsonEncode("Advnc Save Map----- > $mappfinal"));

    var mapBody = jsonEncode(mappfinal);
    Uri url = Uri.parse("http://teasoft.trafiqerp.in/api/advance_save");
    Map body = {'json_arr': mapBody};
    http.Response response = await http.post(
      url,
      body: body,
    );
    print("Advnc save body ${body}");
    print("Advnc respons type ${response.runtimeType}");
    Map map = jsonDecode(response.body);
    // Map map = {
    //   "flag": 0,
    //   "msg": "Insertion Done",
    //   "ret_arr": {2: "AB16", 3: "AB17"}
    // };
    print("Advnc save ResultMap--> $map");
    if (map['flag'] == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ts = prefs.getString("t_series");
      print("adv success");
      Map retArr = map['ret_arr'];
      print("-------$retArr");
      retArr.forEach((key, value) async {
        var acc = await TeaDB.instance.upadteCommonQuery(
            'AdvanceTable', "adv_import_id='$value'", "trans_id=$key");

        print('Key: $key, Value: $value');
      });
      advuploading = false;
      advuploaded = true;
      await getAdvanceDetailsfromDB("yes");
      notifyListeners();
      // await importFinal2(context, []);
    } else {
      CustomSnackbar snak = CustomSnackbar();
      snak.showSnackbar(context, "Advance Import Failed", "");
    }
  }

  getRoute(String? sid, BuildContext context) async {
    String areaName;
    print("staff...............${sid}");
    try {
      List areaList = await TeaDB.instance.getRoutefromDB(sid!);
      print("areaList----${areaList}");
      routeList.clear();
      for (var item in areaList) {
        routeList.add(item);
      }
      print("added to routeList----${routeList}");
      notifyListeners();
    }
    // on SocketException catch (e) {
    //   CustomSnackbar snak = CustomSnackbar();
    //   snak.showSnackbar(context, "${e.toString()}", "");
    //   print('SocketException: $e');
    // } on http.ClientException catch (e) {
    //   CustomSnackbar snak = CustomSnackbar();
    //   snak.showSnackbar(context, "${e.toString()}", "");
    //   print('ClientException: $e');
    // }
    catch (e) {
      if (e is SocketException) {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('SocketException: ${e.message}');
        print('Failed to connect to the server.');
      } else if (e is ClientException) {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('ClientException: ${e.message}');
      } else {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('Unknown error: $e');
      }
      // CustomSnackbar snak = CustomSnackbar();
      // snak.showSnackbar(context, "${e.toString()}", "");
      // print('General Exception: $e');
    }
    notifyListeners();
  }

  // setSelectedroute(Map selectedrout) async
  // {
  //   selectedrut = selectedrout["routename"];
  //   print(selectedrout["rid"].runtimeType);
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setInt("sel_rootid", selectedrout["rid"]);
  //   prefs.setString("sel_rootnm", selectedrout["routename"]);
  //   print("roottt---$selectedrut");
  //   notifyListeners();
  // }
  setRoute(int routeId) async {
    // selectedrut = selectedrout["routename"];
    // print(selectedrout["rid"].runtimeType);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("sel_rootid", routeId);

    print("cur roottt---$routeId");
    notifyListeners();
  }

  setSelectedProduct(Map selectedprod) async {
    // selectedrut = selectedrout["routename"];
    print(selectedprod["pid"].runtimeType);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("sel_proid", selectedprod["pid"]);
    prefs.setString("sel_pronm", selectedprod["product"]);
    print("pro selected---$selectedprod");
    notifyListeners();
  }

  setSelectedsupplier(Map<String, dynamic> selsupplier) async {
    selectedSupplierMap = selsupplier;
    selectedsuplier = selsupplier["acc_name"];
    print(selsupplier["acid"].runtimeType);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("sel_rootid", selsupplier["route"]);
    prefs.setInt("sel_accid", selsupplier["acid"]);
    prefs.setString("sel_accnm", selsupplier["acc_name"]);
    prefs.setString("sel_acccod", selsupplier["acc_code"]);
    prefs.setString("sel_accplc", selsupplier["acc_ext_place"]);

    print("sel supplier---${selsupplier["route"]}, ${selsupplier["acc_code"]}");
    notifyListeners();
  }

  Future<AccountMasterModel?> getACMasterDetails(int index, String page) async {
    // print("cid...............${cid}");
    try {
      // Uri url = Uri.parse("http://192.168.18.168:7000/api/load_suppliers");
      Uri url = Uri.parse("http://teasoft.trafiqerp.in/api/load_suppliers");
      // // SharedPreferences prefs = await SharedPreferences.getInstance();
      // // String? br_id1 = prefs.getString("br_id");
      Map body = {'cid': " "};
      downloading[index] = true;
      // print("compny----${cid}");
      http.Response response = await http.post(
        url,
        body: body,
      );

      print("body ${body}");
      var map = jsonDecode(response.body);
      print("mapsuppli ${map}");
      await TeaDB.instance.deleteFromTableCommonQuery('accountMasterTable', "");
      // List map = [
      //   {
      //     "id": 11,
      //     "acc_name": "Supply1",
      //     "route": 2,
      //     "status": 0,
      //     "acc_master_type": "SU"
      //   },
      //   {
      //     "id": 12,
      //     "acc_name": "Supply2",
      //     "route": 2,
      //     "status": 0,
      //     "acc_master_type": "CU"
      //   },
      //   {
      //     "id": 13,
      //     "acc_name": "Supply3",
      //     "route": 2,
      //     "status": 0,
      //     "acc_master_type": "SU"
      //   },
      // ];
      for (var acnt in map) {
        print("accdetails----${acnt.length}");
        acnt = AccountMasterModel.fromJson(acnt);
        var acc = await TeaDB.instance.insertACmasterDetails(acnt);
        print("inserted ${acc}");
      }
      downloading[index] = false;
      downlooaded[index] = true;
      notifyListeners();
      return acnt;
    } catch (e) {
      print(e);
      return null;
    }
  }

  getRouteNamefromDB(int? rid) async {
    List accList =
        await TeaDB.instance.getRouteNamefromDB(int.parse(rid.toString()));
    rootnmforEdit = accList[0]["routename"].toString();
    notifyListeners();
  }

  getSuggestions(String query) {
    // filteredlist = spplierList
    //     .where((e) => e["acc_ser_code"]
    //         .toString()
    //         .toLowerCase()
    //         .contains(query.toLowerCase()))
    //     .toList();
    // notifyListeners();
    filteredlist = spplierList.where((e) {
      String accSerCode = e["acc_ser_code"].toString().toLowerCase();
      String accName = e["acc_name"].toString().toLowerCase();

      return accSerCode.contains(query.toLowerCase()) ||
          accName.contains(query.toLowerCase());
    }).toList();
    // //matches.retainWhere((s) =>   s.toLowerCase().contains(query.toLowerCase()));
    return filteredlist;
  }

  getSupplierfromDB(String? sercod) async {
    print("ser COD...............${sercod}");
    try {
      filteredlist.clear();
      spplierList.clear();
      notifyListeners();
      List accList =
          await TeaDB.instance.getSupplierListfromDB(sercod.toString());
      print("accList----$accList");
      spplierList.clear();
      notifyListeners();
      for (var item in accList) {
        spplierList.add(item);
      }
      filteredlist = spplierList;
      print("added to supplierList----$spplierList");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  clearAllAfterSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("sel_proid");
    prefs.remove("sel_pronm");
    prefs.remove("sel_accid");
    prefs.remove("sel_accnm");
    prefs.remove("sel_accplc");
    selectedSupplierMap = {};
    selectedsuplier = "";

    notifyListeners();
  }

  getProductsfromDB() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      double sum = 0.0;
      List proList = await TeaDB.instance.getProductListfromDB();
      print("prodList----${proList}");
      prodList.clear();
      // prodList = [
      //   {"id": 1, "pid": 1, "product": "Afddgdgdfgfghf"},
      //   {"id": 2, "pid": 2, "product": "Bnbnbmhmhmhmh"},
      // ];
      for (var item in proList) {
        prodList.add(item);
      }
      selectedPro = prodList[0];
      prefs.setInt("sel_proid", selectedPro!["pid"]);
      prefs.setString(
          "sel_pronm", selectedPro!["product"].toString().trimLeft());

      // var lengthh = prodList.length;
      // colected = List.generate(lengthh, (index) => TextEditingController());
      // damage = List.generate(lengthh, (index) => TextEditingController());
      // total = List.generate(lengthh, (index) => TextEditingController());
      // for (int i = 0; i < lengthh; i++) {
      //   colected[i].text = "0";
      //   damage[i].text = "0";
      //   total[i].text = "0";
      //   sum = sum + double.parse(colected[i].text.toString());
      //   print("colected 1st............$colected");
      // }
      // totalcollected = sum;
      // print("totalcollected----${totalcollected.toString()}");
      print("added to prodctList----$prodList");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  setEditcollectList(Map<String, dynamic> colMap) {
    double sum = 0.0;
    editColctMap.clear();
    notifyListeners();
    editColctMap = colMap;
    List<dynamic> details = editColctMap['details'];
    for (int i = 0; i < details.length; i++) {
      colected[i].text = details[i]['trans_det_col_qty'].toString();
      damage[i].text = details[i]['trans_det_dmg_qty'].toString();
      total[i].text = details[i]['trans_det_net_qty'].toString();
      sum = sum + double.parse(colected[i].text.toString());
      print("edit collect list............$colected");
    }
    totalcollected = sum;
    print("totalcollected- on edit---${totalcollected.toString()}");
    notifyListeners();
  }

  setEditAdvList(Map<String, dynamic> colMap) {
    editAdvnceMap.clear();
    notifyListeners();
    editAdvnceMap = colMap;
    print("Edit adv Map--$editAdvnceMap");
    notifyListeners();
  }

  getUsersfromDB() async {
    try {
      List usrList = await TeaDB.instance.getUserListfromDB();
      print("userList----${usrList}");
      userList.clear();
      for (var item in usrList) {
        userList.add(item);
      }
      print("added to userList----${userList}");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  gettransMastersfromDB(String? conditn) async {
    try {
      List trList = await TeaDB.instance.gettransMasterfromDB(conditn);
      // print("translist----${trList}");
      importtransMasterList.clear();
      for (var item in trList) {
        importtransMasterList.add(item);
      }
      print("added to translist----${importtransMasterList}");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  gettransDetailsfromDB(String? conditn) async {
    try {
      List dtlList = await TeaDB.instance.gettransDetailsfromDB(conditn);
      // print("transDETlist----${dtlList}");
      importtransDetailsList.clear();
      for (var item in dtlList) {
        importtransDetailsList.add(item);
      }
      print("added to transDETlist----${importtransDetailsList}");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  getAdvanceDetailsfromDB(String? conditn) async {
    try {
      List advList = await TeaDB.instance.getAdvanceDetailsfromDB(conditn);
      // print("transDETlist----${dtlList}");
      importAdvanceList.clear();
      for (var item in advList) {
        importAdvanceList.add(item);
      }
      print("added to importAdvanceList----${importAdvanceList}");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  updateUserDetails(String datenow) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("u_id", selectedUserMap!['uid']);
    prefs.setString("uname", selectedUserMap!['username']);
    prefs.setString("upwd", selectedUserMap!['password']);
    prefs.setInt("c_id", selectedUserMap!['company_id']);
    prefs.setInt("br_id", selectedUserMap!['branch_id']);
    // prefs.setString("log_date", datenow);
    notifyListeners();
  }

  verifyStaff(String pwd, BuildContext context) {
    print("pwd , selpwd ====$pwd ,${selectedUserMap!['password']}");
    if (pwd.toLowerCase() ==
        selectedUserMap!['password'].toString().trim().toLowerCase()) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<ProdModel?> getProductDetails(int index, String page) async {
    // print("cid...............${cid}");
    try {
      downloading[index] = true;
      notifyListeners();
      Uri url = Uri.parse("http://teasoft.trafiqerp.in/api/load_products");
      // // SharedPreferences prefs = await SharedPreferences.getInstance();
      // // String? br_id1 = prefs.getString("br_id");
      Map body = {'cid': ""};

      http.Response response = await http.post(
        url,
        body: body,
      );

      print("Prod body ${body}");
      var map = jsonDecode(response.body);
      print("Prod Map--> $map");

      await TeaDB.instance.deleteFromTableCommonQuery('prodDetailsTable', "");
      // List map = [
      //   {"id": 1, "name": "Kannur", "status": 0},
      //   {"id": 2, "name": "Thalassery", "status": 0},
      //   {"id": 3, "name": "Mattannur", "status": 0}
      // ];

      for (var pro in map) {
        print("productt----${pro.length}");

        prod = ProdModel.fromJson(pro);
        var proo = await TeaDB.instance.insertproductDetails(prod);
        print("inserted ${proo}");
      }
      downloading[index] = false;
      downlooaded[index] = true;
      notifyListeners();
      return prod;
    } catch (e) {
      print(e);
      return null;
    }
  }

  updateTotal(int index) async {
    double collectedValue = double.tryParse(colected[index].text) ?? 0.0;
    double damageValue = double.tryParse(damage[index].text) ?? 0.0;
    double totalValue = collectedValue - damageValue;
    total[index].text = totalValue.toString();
    await calcsum();
    print("tot---->${totalcollected.toString()}");
    notifyListeners();
  }

  calcsum() {
    double sum = 0.0;
    var lengthh = prodList.length;
    for (int i = 0; i < lengthh; i++) {
      double dd = double.tryParse(colected[i].text.toString()) ?? 0.0;
      sum = sum + dd;
      print("colected 1st............$colected");
    }
    totalcollected = sum;
    notifyListeners();
  }

  registeration(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("t_series", "CD");
    // prefs.setString("t_series", "CD");
  }

  Future<UserModel?> getUserDetails(int index, String page) async {
    try {
      downloading[index] = true;
      notifyListeners();
      Uri url = Uri.parse("http://teasoft.trafiqerp.in/api/load_users");
      // // SharedPreferences prefs = await SharedPreferences.getInstance();
      // // String? br_id1 = prefs.getString("br_id");
      Map body = {'cid': ""};
      http.Response response = await http.post(
        url,
        body: body,
      );
      print("User body ${body}");
      var map = jsonDecode(response.body);
      print("User Map--> $map");
      if (map != null) {
        await TeaDB.instance.deleteFromTableCommonQuery('UserMasterTable', "");
        // List map = [
        //   {"id": 1, "name": "Kannur", "status": 0},
        //   {"id": 2, "name": "Thalassery", "status": 0},
        //   {"id": 3, "name": "Mattannur", "status": 0}
        // ];
        for (var uss in map) {
          print("userrr----${uss.length}");
          usr = UserModel.fromJson(uss);
          var userr = await TeaDB.instance.insertUserDetails(usr);
          print("user inserted ${userr}");
        }
        downloading[index] = false;
        downlooaded[index] = true;
        getUsersfromDB();
        notifyListeners();
        return usr;
      } else {
        print("user map null");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  insertTransDetailstoDB(List<Map<String, dynamic>> details) async {
    final dbHelper = TeaDB.instance;
    for (var detail in details) {
      var transDetail = TransDetailModel.fromMap(detail);
      await dbHelper.insertTransDetail(transDetail);
    }
  }

  insertTransMastertoDB(Map<String, dynamic> transMasterM) async {
    transm = TransMasterModel.fromJson(transMasterM);
    var trn = await TeaDB.instance.inserttransMasterDetails(transm);
  }

  insertAdvancetoDB(Map<String, dynamic> advanceMap) async {
    advmod = AdvanceModel.fromJson(advanceMap);
    var adv = await TeaDB.instance.insertAdvancetoDB(advmod);
  }

  // addNewBagRow() {
  //   TextEditingController newController = TextEditingController();
  //   controllers.add(newController);
  //   notifyListeners();
  //   bagRows.add(
  //     Padding(
  //       padding: const EdgeInsets.all(10),
  //       child: Row(
  //         children: [
  //           Text(
  //             " Bag $currentBagCount  ",
  //             style: TextStyle(fontSize: 18),
  //           ),
  //           SizedBox(
  //             width: 140,
  //             height: 55,
  //             child: TextFormField(

  //               onChanged: (value) {
  //                 if (value.isNotEmpty &&
  //                     int.tryParse(value) != null &&
  //                     int.parse(value) > 0) {
  //                   onRowchange();
  //                   notifyListeners();
  //                 }
  //               },
  //               controller: newController,
  //               keyboardType: TextInputType.number,
  //               decoration: InputDecoration(
  //                 border: OutlineInputBorder(),
  //                 labelText: 'Enter Bag $currentBagCount',
  //               ),
  //             ),
  //           ),
  //           // ...donRows
  //         ],
  //       ),
  //     ),
  //   );
  //   currentBagCount++; // Increment the bag count for the next row
  //   print("current bagCount---${currentBagCount-1}");
  //   notifyListeners();
  // }

  // addNewDoneRow() {

  //   donRows.add(
  //     Row(
  //       children: [
  //         IconButton(
  //           // Disable the button if the condition is not met
  //           icon: Icon(Icons.done, color: Colors.green),
  //           onPressed: () {
  //             onDonePressed();
  //           },
  //         )
  //       ],
  //     ),
  //   );
  //   notifyListeners();
  // }

  // onRowchange() async {
  //   await addNewDoneRow();
  // }

  // void onDonePressed() async {
  //    donRows.clear();
  //    notifyListeners();
  //   await addNewBagRow();
  // }

  searchSupplier(String val) {
    filteredlist = spplierList;
    if (val.isNotEmpty) {
      isSearch = true;
      notifyListeners();
      filteredlist = spplierList
          .where((e) => e["acc_name"]
              .toString()
              .toLowerCase()
              .contains(val.toLowerCase()))
          .toList();
    } else {
      isSearch = false;
      notifyListeners();
      filteredlist = spplierList;
    }
    // qty =
    //     List.generate(filteredlist.length, (index) => TextEditingController());
    // isAdded = List.generate(filteredlist.length, (index) => false);
    // response = List.generate(filteredlist.length, (index) => 0);
    // for (int i = 0; i < filteredlist.length; i++) {
    //   qty[i].text = "1.0";
    //   response[i] = 0;
    // }
    print("filtered_CAT_List----------------$filteredlist");
    notifyListeners();
  }
}
