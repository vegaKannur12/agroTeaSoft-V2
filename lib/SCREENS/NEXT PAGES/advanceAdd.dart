import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/damageNremark.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/finalSavePage.dart';
import 'package:tsupply/tableList.dart';

class AdvanceAddPage extends StatefulWidget {
  final String bagcount;
  final String weightString;
  final String? total;
  final String? damage;
  final String? nettotal;
  final String? remarks;

  const AdvanceAddPage(
      {super.key,
      required this.total,
      required this.damage,
      required this.nettotal,
      required this.weightString,
      required this.bagcount,
      required this.remarks});

  @override
  State<AdvanceAddPage> createState() => _AdvanceAddPageState();
}

class _AdvanceAddPageState extends State<AdvanceAddPage> {
  DateTime date = DateTime.now();
  String? displaydate;
  String? transactDate;
  int? u_id;
  String? uname;
  String? upwd;
  int? br_id;
  int? c_id;
  double summ = 0;
  String? savedate;
  TextEditingController dateInput = TextEditingController();
  TextEditingController adv_amt_ctrl = TextEditingController();
  TextEditingController adv_narratn_ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<Controller>(context, listen: false).geTseries();
    dateInput.text = "";
    getSharedpref();

    //    if (Provider.of<Controller>(context, listen: false).prodList.isNotEmpty) {
    //   selectedPro = Provider.of<Controller>(context, listen: false).prodList[0]; // or leave it null
    // }
    displaydate = DateFormat('dd-MM-yyyy').format(date);
    transactDate = DateFormat('yyyy-MM-dd').format(date);
    dateInput.text = DateFormat('yyyy-MM-dd').format(date);
    print(("-----$displaydate"));
  }

  getSharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    u_id = prefs.getInt("u_id");
    c_id = prefs.getInt("c_id");
    br_id = prefs.getInt("br_id");
    uname = prefs.getString("uname");
    upwd = prefs.getString("upwd");
    // ts = prefs.getString("t_series");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 174, 195, 233),
          title: Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) =>
                Text(
              value.tSeries.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 182, 84, 84)),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                List<Map<String, dynamic>> list =
                    await TeaDB.instance.getListOfTables();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TableList(list: list)),
                );
              },
              icon: Icon(Icons.table_bar),
            ),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add Advance",
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              // Container(
                              //     padding: EdgeInsets.all(10),
                              //     // color: Colors.yellow,
                              //     width: size.width * 1 / 3.5,
                              //     child: Text("Amount")),
                              Flexible(
                                  child: TextField(
                                controller: dateInput,
                                //editing controller of this TextField
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons
                                        .calendar_today), //icon of text field
                                    labelText:
                                        "Accountable Date" //label text of field
                                    ),
                                readOnly: true,
                                //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    print(
                                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate =
                                        // DateFormat('yyyy-MM-dd')
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    savedate = DateFormat('yyyy-MM-dd')
                                        .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
                                    setState(() {
                                      dateInput.text =
                                          savedate!; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                              ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  // color: Colors.yellow,
                                  width: size.width * 1 / 3.5,
                                  child: Text("Amount")),
                              Flexible(
                                  child: customTextfield(adv_amt_ctrl, 1,
                                      TextInputType.number, (String value) {}))
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  // color: Colors.yellow,
                                  width: size.width * 1 / 3.5,
                                  child: Text("Narration")),
                              Flexible(
                                  child: customTextfield(adv_narratn_ctrl, 2,
                                      TextInputType.text, (String value) {}))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              child: Text(
                                "ADD ADVANCE",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                int max = await TeaDB.instance
                                    .getMaxCommonQuery(
                                        'AdvanceTable', 'trans_id', " ");
                                print("int max---- $max");

                                final prefs =
                                    await SharedPreferences.getInstance();
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
                                    adv_amt_ctrl.text.toString();
                                value.advanceMasterMap["adv_narration"] =
                                    adv_narratn_ctrl.text.toString();
                                value.advanceMasterMap["adv_acc_date"] =
                                    dateInput.text.toString();
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
                                adv_amt_ctrl.clear();
                                adv_narratn_ctrl.clear();
                                // dateInput.clear();
                                savedate = "";
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                      opaque: false, // set to false
                                      pageBuilder: (_, __, ___) =>
                                          FinalSavePage(
                                            total: widget.total.toString(),
                                            damage: widget.damage.toString(),
                                            nettotal:
                                                widget.nettotal.toString(),
                                            bagcount:
                                                widget.bagcount.toString(),
                                            weightString:
                                                widget.weightString.toString(),
                                            remarks: widget.remarks.toString(),
                                          )),
                                );
                              },
                            ),
                            TextButton(
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                              ),
                              onPressed: () async {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    opaque: false, // set to false
                                    pageBuilder: (_, __, ___) => FinalSavePage(
                                      total: widget.total.toString(),
                                      damage: widget.damage.toString(),
                                      nettotal: widget.nettotal.toString(),
                                      bagcount: widget.bagcount.toString(),
                                      weightString:
                                          widget.weightString.toString(),
                                      remarks: widget.remarks.toString(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )));
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
