import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:flutter/services.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/damageNremark.dart';

class BagCountPage extends StatefulWidget {
  const BagCountPage({super.key});

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
    return Scaffold(
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
                              " : ${value.spplierList[0]['acc_name'].toString().toUpperCase()}",
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
                              " : ${value.spplierList[0]['acc_code'].toString()}",
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
                              " : ${value.spplierList[0]['acc_ext_place'].toString().toUpperCase()}",
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
        builder: (BuildContext context, Controller value, Widget? child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 12),
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
            ),
            Padding(
              padding: EdgeInsets.only(right: 12, bottom: 12),
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
                    print("count-----${value.totalBagCount.toString()}");
                    //  Navigator.of(context).push(
                    //     PageRouteBuilder(
                    //       opaque: false, // set to false
                    //       pageBuilder: (_, __, ___) => DamageNRemark(
                    //         totalweight: double.parse(summ.toString()),
                    //         weightString: weightString.toString(),
                    //         bagcount: widget.bagcount.toString(),
                    //       ),
                    //     ),
                    //   );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
