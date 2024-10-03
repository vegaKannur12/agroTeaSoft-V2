import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/COMPONENTS/custom_snackbar.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/damageNremark.dart';
import 'package:tsupply/tableList.dart';

class BagCountPage extends StatefulWidget {
  final int? bagcount;
  const BagCountPage({super.key, required this.bagcount});

  @override
  State<BagCountPage> createState() => _BagCountPageState();
}

class _BagCountPageState extends State<BagCountPage> {
  DateTime date = DateTime.now();
  String? displaydate;
  List<TextEditingController> _controllers = [];
  double summ = 0;
  int isempty = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < int.parse(widget.bagcount.toString()); i++) {
      _controllers.add(TextEditingController());
    }
    Provider.of<Controller>(context, listen: false).geTseries();
    displaydate = DateFormat('dd-MM-yyyy').format(date);
    print(("-----$displaydate"));
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 193, 213, 252),
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
          // IconButton(
          //   onPressed: () async {
          //     List<Map<String, dynamic>> list =
          //         await TeaDB.instance.getListOfTables();
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => TableList(list: list)),
          //     );
          //   },
          //   icon: Icon(Icons.table_bar),
          // ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Enter weight of ${widget.bagcount} bags",
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
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.bagcount,
                          itemBuilder: ((context, index) {
                            return Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child:
                                      // Text(index.toString()),
                                      SizedBox(
                                    width: 70,
                                    height: 45,
                                    child: customTextfield(
                                      _controllers[index],
                                      1,
                                      TextInputType.number,
                                      (String input) =>
                                          calculateSum(input, index),
                                    ),
                                  )),
                            );
                          })),
                    ),
                  ],
                ),
              )),
      bottomNavigationBar: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            summ != 0.0
                ? Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          "Total ",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ": ${summ.toString()} KG",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  "NEXT",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  String weightString = "";
                  for (int i = 0;
                      i < int.parse(widget.bagcount.toString());
                      i++) {
                    if (_controllers[i].text.isEmpty) {
                      isempty = 1;
                      break;
                    } else {
                      isempty = 0;
                      String temp = _controllers[i].text;
                      if (weightString.isEmpty) {
                        weightString = temp;
                      } else {
                        weightString = '$weightString,$temp';
                      }
                      // weightString += double.parse(_controllers[i].text);
                    }
                  }
                  print("weightString============>$weightString");
                  if (isempty == 0) {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false, // set to false
                        pageBuilder: (_, __, ___) => DamageNRemark(
                          totalweight: double.parse(summ.toString()),
                          weightString: weightString.toString(),
                          bagcount: widget.bagcount.toString(),
                        ),
                      ),
                    );
                  } else {
                    CustomSnackbar snak = CustomSnackbar();
                    snak.showSnackbar(context, "Fill all fields", "");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  calculateSum(String input, int index) {
    // Update the controller text, this is just to ensure we have the latest value
    double newValue = double.tryParse(input) ?? 0;
    // Recalculate the sum by iterating over all controllers
    summ = 0.0; // Reset sum before recalculating
    for (var controller in _controllers) {
      double value =
          double.tryParse(controller.text) ?? 0; // Parse each controller's text
      summ += value; // Accumulate the sum
    }
    setState(() {});
    print("Updated Sum: ${summ.toString()}");
  }

  TextFormField customTextfield(TextEditingController contr, int? maxline,
      TextInputType typ, Function(String) fun) {
    return TextFormField(
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return "This field can't be empty";
      //   }
      //   return null;
      // },
      onChanged: fun,
      keyboardType: typ,
      controller: contr,
      maxLines: maxline,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 5, 5, 5),
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
