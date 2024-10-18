import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/SCREENS/HOME/mainhome.dart';
import 'package:tsupply/tableList.dart';
import 'dart:io';

class FinalSavePage extends StatefulWidget {
  final String bagcount;
  final String weightString;
  final String? total;
  final String? bagweight;
  final String? nettotal;
  final String? remarks;
  final String? moisture;
  final String? others;
  final String? advAmount;
  final String? advNarration;

  const FinalSavePage(
      {super.key,
      required this.total,
      required this.bagweight,
      required this.nettotal,
      required this.weightString,
      required this.bagcount,
      required this.remarks,
      required this.moisture,
      required this.others,
      required this.advAmount,
      required this.advNarration});

  @override
  State<FinalSavePage> createState() => _FinalSavePageState();
}

class _FinalSavePageState extends State<FinalSavePage> {
  DateTime date = DateTime.now();
  String? displaydate;
  String? transactDate;
  int? u_id;
  String? uname;
  String? upwd;
  int? br_id;
  int? c_id;
  double summ = 0;
  String? supName;
  String? supCod;
  String? supPlc;
  String? proName;
  int? supId;
  int? rutid;

  getSharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    u_id = prefs.getInt("u_id");
    c_id = prefs.getInt("c_id");
    br_id = prefs.getInt("br_id");
    uname = prefs.getString("uname");
    upwd = prefs.getString("upwd");
    supName = prefs.getString("sel_accnm");
    supCod = prefs.getString("sel_acccod");
    supPlc = prefs.getString("sel_accplc");
    supId = prefs.getInt("sel_accid");
    rutid = prefs.getInt("sel_rootid");
    proName = prefs.getString("sel_pronm");
    // ts = prefs.getString("t_series");
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Controller>(context, listen: false).geTseries();
    getSharedpref();
    displaydate = DateFormat('dd-MM-yyyy').format(date);
    transactDate = DateFormat('yyyy-MM-dd').format(date);
    print(("-----$displaydate"));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 174, 195, 233),
        // title: Consumer<Controller>(
        //   builder: (BuildContext context, Controller value, Widget? child) =>
        //       Text(
        //     value.tSeries.toString(),
        //     style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         color: Color.fromARGB(255, 182, 84, 84)),
        //   ),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              displaydate.toString(),
              style: TextStyle(
                  color: Color.fromARGB(255, 99, 42, 145),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Consumer<Controller>(
        builder: (BuildContext context, Controller value, Widget? child) =>
            Container(
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Color.fromARGB(255, 174, 195, 233),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Collection Summary",
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                        child: Divider(
                          thickness: 2,
                          color: Color.fromARGB(255, 185, 183, 185),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "SUPPLIER DETAILS",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.08,
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: Text("CODE "),
                    ),
                    Flexible(
                      child: Text(
                        ": ${supCod.toString().toUpperCase()}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.08,
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: Text("NAME "),
                    ),
                    Flexible(
                      child: Text(
                        ": ${supName.toString().toUpperCase()}",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.08,
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: Text("PLACE "),
                    ),
                    Flexible(
                      child: Text(
                        // "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv",
                        ": ${supPlc.toString().toUpperCase()}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "COLLECTION DETAILS",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.08,
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: Text("Bag Count "),
                    ),
                    Flexible(
                      child: Text(
                        ": ${widget.bagcount.toString()}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.only(top: 8, right: 8),
                  color: Colors.green[100],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          ...value.bagListShowWidgets,
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.08,
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: Text("Product "),
                    ),
                    Flexible(
                      child: Text(
                        ": ${proName.toString().toUpperCase()}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.08,
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: Text("Total "),
                    ),
                    Flexible(
                      child: Text(
                        ": ${widget.total.toString()} KG",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.08,
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: Text("Bag Weight "),
                    ),
                    Flexible(
                      child: widget.bagweight.toString() == "0"
                          ? Text(": ----")
                          : Text(
                              ": ${widget.bagweight.toString()} KG",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.08,
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: Text("Moisture "),
                    ),
                    Flexible(
                      child: widget.moisture.toString() == "0.00"
                          ? Text(": ----")
                          : Text(
                              ": ${widget.moisture.toString()} KG",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.08,
                    ),
                    Container(
                      width: size.width * 0.3,
                      child: Text("Others "),
                    ),
                    Flexible(
                      child: widget.others.toString() == "0.00"
                          ? Text(": ----")
                          : Text(
                              ": ${widget.others.toString()} KG",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  color: Color.fromARGB(255, 240, 240, 150),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 8, left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   width: size.width * 0.08,
                        // ),
                        Container(
                          width: size.width * 0.3,
                          child: Text(
                            "Net Total ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            ": ${widget.nettotal.toString()} KG",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                widget.advAmount!.isNotEmpty
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "ADVANCE DETAILS",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              Container(
                                width: size.width * 0.3,
                                child: Text("AMOUNT "),
                              ),
                              Flexible(
                                child: Text(
                                  ": ${widget.advAmount.toString()} ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              Container(
                                width: size.width * 0.3,
                                child: Text("NARRATION "),
                              ),
                              Flexible(
                                child: Text(
                                  ": ${widget.advNarration.toString().isEmpty || widget.advNarration.toString() == "" ? "---" : widget.advNarration.toString()} ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "-------- NO ADVANCE COLLECTED --------",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          "SAVE",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          int max = await TeaDB.instance.getMaxCommonQuery(
                              'TransMasterTable', 'trans_id', " ");
                          print("int max---- $max");
                          print(
                              "sel suppl----------------------${value.selectedsuplier.toString()}");
                          // int transid = await randomNo();
                          final prefs = await SharedPreferences.getInstance();
                          // prefs.setInt("sel_rootid", selectedrout["rid"]);
                          // prefs.setString("sel_rootnm", selectedrout["routename"]);
                          int? rutid = prefs.getInt("sel_rootid");
                          int? supId = prefs.getInt("sel_accid");
                          String? supName = prefs.getString("sel_accnm");
                          String? ts = prefs.getString("t_series");

                          print(
                              "supl id : $supId , supName : $supName , tseris : $ts");

                          value.transMasterMap["trans_id"] = max;
                          value.transMasterMap["trans_series"] = ts;
                          value.transMasterMap["trans_date"] = transactDate;
                          value.transMasterMap["trans_route_id"] =
                              rutid.toString();
                          value.transMasterMap["trans_party_id"] =
                              supId.toString();
                          value.transMasterMap["trans_party_name"] = supName;
                          value.transMasterMap["trans_remark"] =
                              widget.remarks.toString();
                          value.transMasterMap["trans_bag_nos"] =
                              widget.bagcount.toString();
                          value.transMasterMap["trans_bag_weights"] =
                              widget.weightString.toString();
                          // "25,21,65,985";
                          value.transMasterMap["trans_import_id"] = "0";
                          value.transMasterMap["company_id"] = c_id.toString();
                          value.transMasterMap["branch_id"] = br_id.toString();
                          value.transMasterMap["user_session"] = "245";
                          value.transMasterMap["log_user_id"] = u_id.toString();
                          value.transMasterMap["hidden_status"] = "0";
                          value.transMasterMap["row_id"] = "0";
                          value.transMasterMap["log_user_name"] =
                              uname.toString();
                          value.transMasterMap["log_date"] = date.toString();
                          value.transMasterMap["status"] = 0;

                          Map<String, dynamic> transDetailstempMap = {};
                          int? pid = prefs.getInt("sel_proid");
                          String? product = prefs.getString("sel_pronm");
                          String collected = widget.total.toString();

                          String bagweight = widget.bagweight.toString();
                          String moisture = widget.moisture.toString();
                          String others = widget.others.toString();
                          String total = widget.nettotal.toString();
                          print("pid---$pid");
                          print("pName---$product");
                          print(
                              "Coll----damg----totl---$collected---$bagweight---$total");
                          transDetailstempMap["trans_det_mast_id"] = "$ts$max";
                          transDetailstempMap["trans_det_prod_id"] = pid;
                          transDetailstempMap["trans_det_prod_nm"] =
                              product.toString();
                          transDetailstempMap["trans_det_tot_qty"] = collected;
                          transDetailstempMap["trans_det_bag_wt"] = bagweight;
                          transDetailstempMap["trans_det_net_qty"] = total;
                          transDetailstempMap["trans_det_net_moisture"] =
                              moisture;
                          transDetailstempMap["trans_det_others"] = others;
                          transDetailstempMap["trans_det_unit"] = "KG";
                          transDetailstempMap["trans_det_rate_id"] = "0";
                          transDetailstempMap["trans_det_value"] = "0";
                          transDetailstempMap["trans_det_import_id"] = "0";
                          transDetailstempMap["company_id"] = c_id.toString();
                          transDetailstempMap["branch_id"] = br_id.toString();
                          transDetailstempMap["log_user_id"] = u_id.toString();
                          transDetailstempMap["user_session"] = "245";
                          transDetailstempMap["log_date"] = date.toString();
                          transDetailstempMap["status"] = 0;
                          // Create a ProductData object and add it to the list

                          print(
                              "transdetails Map -------${transDetailstempMap}");
                          value.transdetailsList.add(transDetailstempMap);
                          await Provider.of<Controller>(context, listen: false)
                              .insertTransDetailstoDB(value.transdetailsList);
                          print("transdetails List-${value.transdetailsList}");
                          await Provider.of<Controller>(context, listen: false)
                              .insertTransMastertoDB(value.transMasterMap);
                          value.transMasterMap["details"] =
                              value.transdetailsList;
                          print("transMaster Map-${value.transMasterMap}");
                          value.transdetailsList.clear();

                          Fluttertoast.showToast(
                              backgroundColor: Colors.green,
                              msg: "Collection Added",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.black,
                              fontSize: 16.0);

                          if (widget.advAmount!.isNotEmpty) {
                            ///save advance
                            int max = await TeaDB.instance.getMaxCommonQuery(
                                'AdvanceTable', 'trans_id', " ");
                            print("int max---- $max");

                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString("log_date", date.toString());
                            int? rutid = prefs.getInt("sel_rootid");
                            int? supId = prefs.getInt("sel_accid");
                            String? supName = prefs.getString("sel_accnm");
                            String? ts = prefs.getString("t_series");
                            print(
                                "supl id: $supId , supName: $supName , tseris: $ts");

                            value.advanceMasterMap["trans_id"] = max;
                            value.advanceMasterMap["adv_series"] = ts;
                            value.advanceMasterMap["adv_date"] =
                                date.toString();

                            // transactDate;
                            value.advanceMasterMap["adv_route_id"] =
                                rutid.toString();
                            value.advanceMasterMap["adv_party_id"] =
                                supId.toString();
                            value.advanceMasterMap["adv_party_name"] =
                                supName.toString();
                            value.advanceMasterMap["adv_pay_mode"] = "1";
                            value.advanceMasterMap["adv_pay_acc"] = "";
                            value.advanceMasterMap["adv_amt"] =
                                widget.advAmount.toString();
                            value.advanceMasterMap["adv_narration"] =
                                widget.advNarration.toString();
                            value.advanceMasterMap["adv_acc_date"] =
                                transactDate.toString();
                            // "25,21,65,985";
                            value.advanceMasterMap["adv_import_id"] = "0";
                            value.advanceMasterMap["company_id"] =
                                c_id.toString();
                            value.advanceMasterMap["branch_id"] =
                                br_id.toString();
                            value.advanceMasterMap["log_date"] =
                                date.toString();
                            value.advanceMasterMap["status"] = 0;

                            await Provider.of<Controller>(context,
                                    listen: false)
                                .insertAdvancetoDB(value.advanceMasterMap);
                            print(
                                "advanceMasterMap---> ${value.advanceMasterMap}");
                            Fluttertoast.showToast(
                                backgroundColor: Colors.green,
                                msg: "Advance Added",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          }
                          await Provider.of<Controller>(context, listen: false)
                              .setStaffLog();
                          await Provider.of<Controller>(context, listen: false)
                              .clearAllAfterSave();
                          // await Provider.of<Controller>(context, listen: false)
                          //     .getSupplierfromDB(" ");
                          Navigator.of(context).push(
                            PageRouteBuilder(
                                opaque: false, // set to false
                                pageBuilder: (_, __, ___) => MainHome()),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          return await showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                // title: const Text('AlertDialog Title'),
                                content: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text('Want to Discard ?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () async {
                                      await Provider.of<Controller>(context,
                                              listen: false)
                                          .clearAllAfterSave();
                                      // await Provider.of<Controller>(context,
                                      //         listen: false)
                                      //     .getSupplierfromDB("");
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                            opaque: false, // set to false
                                            pageBuilder: (_, __, ___) =>
                                                MainHome()),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          "DISCARD",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListBody(
              children: const <Widget>[
                Text('Want to exit from this app without saving data?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await Provider.of<Controller>(context, listen: false)
                    .clearAllAfterSave();
                // await Provider.of<Controller>(context, listen: false)
                //     .getSupplierfromDB("");
                exit(0);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  TextFormField customTextfield(TextEditingController contr, int? maxline,
      TextInputType typ, Function(String) fun) {
    return TextFormField(
      onChanged: fun,
      keyboardType: typ,
      controller: contr,
      maxLines: maxline,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 199, 198, 198),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 199, 198, 198),
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 3,
            ),
          ),
          hintText: ""),
    );
  }
}
