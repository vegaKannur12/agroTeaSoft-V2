import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/COMPONENTS/custom_snackbar.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:flutter/services.dart';
import 'package:tsupply/SCREENS/HOME/mainhome.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/damageNremark.dart';
import 'dart:io';

class BagCountPage extends StatefulWidget {
  final String nm;
  final String code;
  final String plc;
  const BagCountPage(
      {super.key, required this.nm, required this.plc, required this.code});

  @override
  State<BagCountPage> createState() => _BagCountPageState();
}

class _BagCountPageState extends State<BagCountPage> {
  DateTime date = DateTime.now();
  String? displaydate;
  double summ = 0;
  // int isempty = 0;
  // int isError = 0;
  // List<Widget> bagRows = []; // Store the list of rows with textfield and button
  // List<TextEditingController> controllers =
  // []; // Store controllers for textfields
  // Control done button state (enabled/disabled)
  // int currentBagCount = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false).clearTotalweightString();
      Provider.of<Controller>(context, listen: false).addNewBagRow(context);
      Provider.of<Controller>(context, listen: false).geTseries();
    });
    // addNewBagRow();
    displaydate = DateFormat('dd-MM-yyyy').format(date);
    print(("-----$displaydate"));
  }

  // Function to add a new row for each bag (TextFormField and Done button)

  // Action when the "done" button is pressed

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 193, 213, 252),
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
        body: SingleChildScrollView(
          child: Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) =>
                Container(
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Color.fromARGB(255, 193, 213, 252),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 90,
                                  child: Text(
                                    "SUPPLIER",
                                    style: TextStyle(fontSize: 17),
                                  )),
                              Text(
                                " : ${widget.nm..toString().toUpperCase()}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 90,
                                  child: Text(
                                    "CODE",
                                    style: TextStyle(fontSize: 17),
                                  )),
                              Text(
                                " : ${widget.code.toString()}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 90,
                                  child: Text(
                                    "PLACE",
                                    style: TextStyle(fontSize: 17),
                                  )),
                              Text(
                                " : ${widget.plc.toString().toUpperCase()}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Enter weight of bags",
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  // ...bagRows
                  Consumer<Controller>(
                    builder: (context, controller, child) {
                      return Column(
                        children: [
                          ...controller.bagRows,
                        ],
                      );
                    },
                  )
                  // Column(
                  //   children: [...value.bagRows, ...value.donRows],
                  // )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              value.totalwgt.toString() != "0.0"
                  ? Padding(
                      padding: EdgeInsets.only(left: 12, bottom: 15),
                      child: Row(
                        children: [
                          Text(
                            "Total : ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${value.totalwgt.toString()} KG",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: EdgeInsets.only(right: 12, bottom: 15),
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
                            size: 18, color: Colors.white)
                      ],
                    ),
                    onPressed: () async {
                      if (value.totalBagCount > 0) {
                        await Provider.of<Controller>(context, listen: false)
                            .getSelctedTypePercentageORWgt();
                        print("count-----${value.totalBagCount.toString()}");
                        print("wegt-----${value.totalwgt.toString()}");
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false, // set to false
                            pageBuilder: (_, __, ___) => DamageNRemark(
                              totalweight:
                                  double.parse(value.totalwgt.toString()),
                              weightString: value.totalWeightString.toString(),
                              bagcount: value.totalBagCount.toString(),
                            ),
                          ),
                        );
                      } else {
                        CustomSnackbar snak = CustomSnackbar();
                        snak.showSnackbar(context, "Enter Bag Details..", "");
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
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              await Provider.of<Controller>(context, listen: false)
                  .clearAllAfterSave();
              Navigator.of(context).push(
                PageRouteBuilder(
                    opaque: false, // set to false
                    pageBuilder: (_, __, ___) => MainHome()),
              );
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
