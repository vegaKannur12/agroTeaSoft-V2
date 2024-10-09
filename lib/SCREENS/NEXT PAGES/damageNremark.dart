import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/productAdd.dart';
import 'package:tsupply/tableList.dart';

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
  TextEditingController nettot_ctrl = TextEditingController();
  TextEditingController remark_ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<Controller>(context, listen: false).geTseries();
    displaydate = DateFormat('dd-MM-yyyy').format(date);
    total_ctrl.text = widget.totalweight.toString();
    nettot_ctrl.text = widget.totalweight.toString();
    print(("-----$displaydate"));
  }

  @override
  Widget build(BuildContext context) {
    print("${widget.weightString}=========${widget.totalweight}----");
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
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 10),
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
                            ),
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
                                    (String input) => nettotCalulate()))
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
                            SizedBox(
                              width: 140,
                              height: 55,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<Map<String, dynamic>>(
                          hint: Text("Select Route"),
                          value: value.selectedwgt,
                          onChanged: (Map<String, dynamic>? newValue) async {
                            setState(() {
                              value.selectedwgt = newValue;
                              print("selected root---${value.selectedwgt}");
                            });
                            // await Provider.of<Controller>(context, listen: false)
                            //     .setSelectedroute(selectedRoute!);
                          },
                          items: value.perKgList
                              .map<DropdownMenuItem<Map<String, dynamic>>>(
                                  (Map<String, dynamic> pk) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: pk,
                              child: Text(pk['type']),
                            );
                          }).toList(),
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
                                child: customTextfield(remark_ctrl, 3,
                                    TextInputType.text, (String input) {}))

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
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 7),
            child: SizedBox(
              height: 60,
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
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                        opaque: false, // set to false
                        pageBuilder: (_, __, ___) => ProductAddPage(
                              total: total_ctrl.text,
                              damage: damge_ctrl.text.isEmpty ||
                                      damge_ctrl.text.toString() == ""
                                  ? "0"
                                  : damge_ctrl.text,
                              nettotal: nettot_ctrl.text,
                              bagcount: widget.bagcount.toString(),
                              weightString: widget.weightString.toString(),
                              remarks: remark_ctrl.text.toString().isEmpty ||
                                      remark_ctrl.text.toString() == ""
                                  ? ""
                                  : remark_ctrl.text.toString(),
                            )),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  nettotCalulate() {
    double tot = double.tryParse(total_ctrl.text.toString()) ?? 0;

    double dam = double.tryParse(damge_ctrl.text.toString()) ?? 0;
    double netTot = tot - dam;
    nettot_ctrl.text = netTot.toString();

    setState(() {});
    print("Total-Damage==: $tot-$dam = ${nettot_ctrl.text.toString()}");
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
