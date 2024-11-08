import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/COMPONENTS/custom_snackbar.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/SCREENS/HOME/mainhome.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/bagcountPage.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/productAdd.dart';
import 'package:tsupply/tableList.dart';
import 'dart:io';

class DamageNRemark extends StatefulWidget {
  final String bagcount;
  final double? totalweight;
  final String weightString;

  const DamageNRemark(
      {super.key,
      required this.totalweight,
      required this.weightString,
      required this.bagcount});
  @override
  State<DamageNRemark> createState() => _DamageNRemarkState();
}

class _DamageNRemarkState extends State<DamageNRemark> {
  DateTime date = DateTime.now();
  String? displaydate;
  double summ = 0;
  TextEditingController total_ctrl = TextEditingController();
  TextEditingController damge_ctrl = TextEditingController();
  TextEditingController moist_ctrl = TextEditingController();
  TextEditingController others_ctrl = TextEditingController();
  TextEditingController nettot_ctrl = TextEditingController();
  TextEditingController remark_ctrl = TextEditingController();
  double moistInkg = 0.0;
  double othersInkg = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false).geTseries();

      Provider.of<Controller>(context, listen: false)
          .setTotalAfterDeduction(widget.totalweight!, "init");
    });
    displaydate = DateFormat('dd-MM-yyyy').format(date);
    total_ctrl.text = "${widget.totalweight.toString()} Kg";
    nettot_ctrl.text = "${widget.totalweight.toString()} Kg";
    print(("-----$displaydate"));
  }

  @override
  Widget build(BuildContext context) {
    print("${widget.weightString}=========${widget.totalweight}----");
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                    "Weight Details (in KG)",
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
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
                          height: size.height * 0.04,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  // color: Colors.yellow,
                                  width: size.width * 1 / 3.5,
                                  child: Text("TOTAL")),
                              SizedBox(
                                width: 140,
                                height: 55,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: total_ctrl,
                                    decoration: InputDecoration(
                                        border: InputBorder.none, hintText: ""),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  // color: Colors.yellow,
                                  width: size.width * 1 / 3.5,
                                  child: Text("BAG WEIGHT")),
                              SizedBox(
                                  width: 200,
                                  height: 55,
                                  child: customTextfield(
                                      damge_ctrl,
                                      1,
                                      TextInputType.number,
                                      (String input) => nettotCalulate())),
                              Text("  Kg")
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  // color: Colors.yellow,
                                  width: size.width * 1 / 3.5,
                                  child: Text("NET TOTAL")),
                              SizedBox(
                                width: 140,
                                height: 55,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: nettot_ctrl,
                                    decoration: InputDecoration(
                                        border: InputBorder.none, hintText: ""),
                                  ),
                                ),
                              ),

                              // SizedBox(
                              //     height: 60,
                              //     width: 60,
                              //     child: customTextfield(nettot_ctrl, 1,
                              //         TextInputType.number, (String value) {}),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  // color: Colors.yellow,
                                  width: size.width * 1 / 3.5,
                                  child: Text("MOISTURE")),
                              Row(
                                children: [
                                  Text(" in ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18)),
                                  SizedBox(
                                    width: 75,
                                    height: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 12, right: 12),
                                      child:
                                          DropdownButton<Map<String, dynamic>>(
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        hint: Text(""),
                                        value: value.selectedwgtMoist,
                                        onChanged: (Map<String, dynamic>?
                                            newValue) async {
                                          setState(() {
                                            moist_ctrl.clear();
                                            moistInkg = 0.0;
                                            value.selectedwgtMoist = newValue;
                                            print(
                                                "selected moist---${value.selectedwgtMoist}");
                                          });
                                          // await Provider.of<Controller>(context, listen: false)
                                          //     .setSelectedroute(selectedRoute!);
                                        },
                                        items: value.perKgList.map<
                                                DropdownMenuItem<
                                                    Map<String, dynamic>>>(
                                            (Map<String, dynamic> pk) {
                                          return DropdownMenuItem<
                                              Map<String, dynamic>>(
                                            value: pk,
                                            child: Text(
                                              pk['type']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 80,
                                height: 55,
                                child: TextFormField(
                                  // readOnly: true,
                                  controller: moist_ctrl,
                                  onChanged: (value) {
                                    if (moist_ctrl.text.isEmpty) {
                                      setState(() {
                                        moistInkg = 0.0;
                                        deductionCalulate(0.0, "moist");
                                      });
                                    }
                                  },
                                ),
                              ),

                              // SizedBox(
                              //     height: 60,
                              //     width: 60,
                              //     child: customTextfield(nettot_ctrl, 1,
                              //         TextInputType.number, (String value) {}),)
                              moist_ctrl.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        value.selectedwgtMoist!["type"] == "KG"
                                            ? convertToKG(
                                                moist_ctrl.text
                                                    .toString()
                                                    .trim(),
                                                "moist",
                                                "kg")
                                            // deductionCalulate(
                                            //     double.parse(
                                            //         moist_ctrl.text.toString().trim()),
                                            //     "moist")
                                            : convertToKG(
                                                moist_ctrl.text
                                                    .toString()
                                                    .trim(),
                                                "moist",
                                                "per");
                                      },
                                      icon: Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ))
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        // value.selectedwgtMoist!["type"] == "%" &&
                        moistInkg > 0.0 && moist_ctrl.text.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Container(
                                  color: Color.fromARGB(255, 247, 247, 135),
                                  child: Text(
                                    "  ${moistInkg.toStringAsFixed(2)} Kg",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                              )
                            : const Text(""),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                // color: Colors.yellow,
                                width: size.width * 1 / 3.5,
                                child: Text("OTHERS"),
                              ),
                              Row(
                                children: [
                                  Text(" in ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18)),
                                  SizedBox(
                                    width: 75,
                                    height: 80,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 15, left: 10, right: 10),
                                      child:
                                          DropdownButton<Map<String, dynamic>>(
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        hint: Text(""),
                                        value: value.selectedwgtOthers,
                                        onChanged: (Map<String, dynamic>?
                                            newValue) async {
                                          setState(() {
                                            others_ctrl.clear();
                                            othersInkg = 0.0;
                                            value.selectedwgtOthers = newValue;
                                            print(
                                                "selected others---${value.selectedwgtOthers}");
                                          });
                                          // await Provider.of<Controller>(context, listen: false)
                                          //     .setSelectedroute(selectedRoute!);
                                        },
                                        items: value.perKgList.map<
                                                DropdownMenuItem<
                                                    Map<String, dynamic>>>(
                                            (Map<String, dynamic> pk) {
                                          return DropdownMenuItem<
                                              Map<String, dynamic>>(
                                            value: pk,
                                            child: Text(
                                              pk['type']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 80,
                                height: 55,
                                child: TextFormField(
                                  // readOnly: true,
                                  controller: others_ctrl,
                                  onChanged: (value) {
                                    if (others_ctrl.text.isEmpty) {
                                      setState(() {
                                        othersInkg = 0.0;
                                        deductionCalulate(0.0, "other");
                                      });
                                    }
                                  },
                                  // onFieldSubmitted: (valu) => value
                                  //             .selectedwgtOthers!["type"] ==
                                  //         "KG"
                                  //     ? convertToKG(
                                  //         others_ctrl.text.toString().trim(),
                                  //         "other",
                                  //         "kg")
                                  //     //  deductionCalulate(
                                  //     //     double.parse(others_ctrl.text
                                  //     //         .toString()
                                  //     //         .trim()),
                                  //     //     "other")
                                  //     : convertToKG(
                                  //         others_ctrl.text.toString().trim(),
                                  //         "other",
                                  //         "per")
                                ),
                              ),
                              others_ctrl.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        value.selectedwgtOthers!["type"] == "KG"
                                            ? convertToKG(
                                                others_ctrl.text
                                                    .toString()
                                                    .trim(),
                                                "other",
                                                "kg")
                                            //  deductionCalulate(
                                            //     double.parse(others_ctrl.text
                                            //         .toString()
                                            //         .trim()),
                                            //     "other")
                                            : convertToKG(
                                                others_ctrl.text
                                                    .toString()
                                                    .trim(),
                                                "other",
                                                "per");
                                      },
                                      icon: Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ))
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        // value.selectedwgtOthers!["type"] == "%" &&
                        othersInkg > 0.0 && others_ctrl.text.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Container(
                                  color: Color.fromARGB(255, 247, 247, 135),
                                  child: Text(
                                    "  ${othersInkg.toStringAsFixed(2)} Kg",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                              )
                            : const Text(""),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  // color: Colors.yellow,
                                  width: size.width * 1 / 3.5,
                                  child: Text("Remarks")),
                              SizedBox(
                                height: 70,
                                width: 200,
                                child: customTextfield(
                                  remark_ctrl,
                                  3,
                                  TextInputType.text,
                                  (String input) {},
                                ),
                              )

                              // SizedBox(
                              //     height: 60,
                              //     width: 60,
                              //     child: customTextfield(nettot_ctrl, 1,
                              //         TextInputType.number, (String value) {}),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        bottomNavigationBar: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 15),
                child: Row(
                  children: [
                    Text(
                      "Total : ",
                      style: TextStyle(
                          color: Color.fromARGB(255, 243, 100, 64),
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${value.totAftrDeduct.toStringAsFixed(2)} Kg",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 7, bottom: 15),
                child: SizedBox(
                  height: 70,
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "NEXT",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 16, color: Colors.white)
                      ],
                    ),
                    onPressed: () async {
                      if (moist_ctrl.text.isNotEmpty && moistInkg == 0.0 ||
                          others_ctrl.text.isNotEmpty && othersInkg == 0.0) 
                        {
                        print("improper calc");
                        CustomSnackbar snak = CustomSnackbar();
                        snak.showSnackbar(
                            context,
                            "Click tick mark to calculate moisture and others..",
                            "");
                      } else {
                        String trimmedNet =
                            nettot_ctrl.text.toString().replaceAll(" Kg", "");
                        String trimmedTot =
                            total_ctrl.text.toString().replaceAll(" Kg", "");
                        await Provider.of<Controller>(context, listen: false)
                        .getProductsfromDB();
                        Navigator.of(context).push(
                          PageRouteBuilder(
                              opaque: false, // set to false
                              pageBuilder: (_, __, ___) => ProductAddPage(
                                    total: trimmedTot,
                                    bagweight: damge_ctrl.text.isEmpty ||
                                            damge_ctrl.text.toString() == ""
                                        ? "0"
                                        : damge_ctrl.text,
                                    nettotal:
                                        value.totAftrDeduct.toStringAsFixed(2),
                                    bagcount: widget.bagcount.toString(),
                                    weightString:
                                        widget.weightString.toString(),
                                    moisture: moistInkg.toStringAsFixed(2),
                                    others: othersInkg.toStringAsFixed(2),
                                    remarks: remark_ctrl.text
                                                .toString()
                                                .isEmpty ||
                                            remark_ctrl.text.toString() == ""
                                        ? ""
                                        : remark_ctrl.text.toString(),
                                  )),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  nettotCalulate() async {
    String trimmedTot = total_ctrl.text.toString().replaceAll(" Kg", "");
    String trimmedDam = damge_ctrl.text.toString().replaceAll(" Kg", "");
    double tot = double.tryParse(trimmedTot) ?? 0;
    double dam = double.tryParse(trimmedDam) ?? 0;
    double netTot = tot - dam;
    nettot_ctrl.text = "${netTot.toString()} Kg";
    await Provider.of<Controller>(context, listen: false)
        .setTotalAfterDeduction(netTot, "init");

    setState(() {});
    print("Total-Damage==: $tot-$dam = ${nettot_ctrl.text.toString()}");
  }

  deductionCalulate(double ded, String type) async {
    if (type == "moist") {
      print("deduct moist=$ded");

      String trimmedNet = nettot_ctrl.text.toString().replaceAll(" Kg", "");
      double tot = double.tryParse(trimmedNet) ?? 0;
      // double dam = double.tryParse(ded.toString()) ?? 0;
      double netTot = tot - (ded + othersInkg);
      // nettot_ctrl.text = netTot.toString();
      await Provider.of<Controller>(context, listen: false)
          .setTotalAfterDeduction(netTot, "calc");
      // setState(() {});
      // print("Total-Deduction Moist==: $tot-$dam = ${netTot.toString()}");
    } else if (type == "other") {
      // String trimmedNet = nettot_ctrl.text.toString().replaceAll(" Kg", "");
      // double tot = double.tryParse(trimmedNet) ?? 0;
      // double dam = double.tryParse(ded.toString()) ?? 0;
      // double netTot = tot - dam;
      // nettot_ctrl.text = netTot.toString();
      String trimmedNet = nettot_ctrl.text.toString().replaceAll(" Kg", "");
      double tot = double.tryParse(trimmedNet) ?? 0;
      // double dam = double.tryParse(ded.toString()) ?? 0;
      double netTot = tot - (ded + moistInkg);
      await Provider.of<Controller>(context, listen: false)
          .setTotalAfterDeduction(netTot, "calc");
    }
    setState(() {});
  }

  convertToKG(String val, String type, String wgttype) {
    String trimmedNet = nettot_ctrl.text.toString().replaceAll(" Kg", "");
    double net = double.tryParse(trimmedNet) ?? 0;
    double per = double.tryParse(val.toString()) ?? 0;

    if (type == "moist") {
      if (wgttype == "kg") {
        moistInkg = per;
      } else {
        moistInkg = net * (per / 100);
      }

      deductionCalulate(moistInkg, type);
      print("% = $per \nNet = $net\n moistin kg =$moistInkg");
      print("Moist in kg---${moistInkg.toString()}");
    } else if (type == "other") {
      if (wgttype == "kg") {
        othersInkg = per;
      } else {
        othersInkg = net * (per / 100);
      }

      deductionCalulate(othersInkg, type);
      print("% = $per \nNet = $net\n others in kg =$othersInkg");
      print("Others in kg---${othersInkg.toString()}");
    }

    setState(() {});
    // setState(() {});
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
              color: const Color.fromARGB(255, 5, 5, 5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 5, 5, 5),
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
              Text('Want to go back? Your details will be cleared..'),
            ],
          ),
        ),
        actions: <Widget>[
          Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) =>
                TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await Provider.of<Controller>(context, listen: false)
                    .clearAllAfterSave();
                Navigator.of(context).push(
                  PageRouteBuilder(
                      opaque: false, // set to false
                      pageBuilder: (_, __, ___) => MainHome()
                      // BagCountPage(
                      //                     code: value.spplierList[0]["acc_code"]
                      //                         .toString(),
                      //                     nm: value.spplierList[0]["acc_name"]
                      //                         .toString(),
                      //                     plc: value.spplierList[0]
                      //                             ["acc_ext_place"]
                      //                         .toString(),
                      //                   ),
                      ),
                );
                // exit(0);
              },
            ),
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
