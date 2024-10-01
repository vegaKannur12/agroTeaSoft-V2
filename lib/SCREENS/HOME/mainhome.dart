import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsupply/COMPONENTS/custom_snackbar.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/SCREENS/DIALOGS/dilogRoute.dart';
import 'package:tsupply/SCREENS/DIALOGS/dilogSupplier.dart';
import 'package:tsupply/SCREENS/DRAWER/customdrawer.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/bagcountPage.dart';
import 'package:tsupply/tableList.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  DateTime date = DateTime.now();
  String? displaydate;
  String? transactDate;
  int? u_id;
  String? uname;
  String? upwd;
  int? br_id;
  int? c_id;
  TextEditingController dateInput = TextEditingController();
  DialogSupplier supdio = DialogSupplier();
  DialogRoutee rutdio = DialogRoutee();
  TextEditingController bagno_ctrl = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<Controller>(context, listen: false).geTseries();
    getSharedpref();
    // getedit();
    dateInput.text = "";

    displaydate = DateFormat('dd-MM-yyyy').format(date);
    transactDate = DateFormat('yyyy-MM-dd').format(date);
    dateInput.text = DateFormat('yyyy-MM-dd').format(date);
    // date.toString();

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
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
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
        drawer: CustomDrawer(),
        body: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              Container(
                  // color: Colors.amber,
                  child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 11.0, left: 11, right: 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                rutdio.showRouteDialog(context);
                              },
                              icon: Icon(
                                Icons.location_on_outlined,
                                color: Colors.black,
                              )),
                          Container(
                            child: Text(
                              value.selectedrut == null
                                  ? "Choose Route"
                                  : value.selectedrut!.toUpperCase(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 11.0, left: 11, bottom: 11.0, right: 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.person,
                                color: Colors.black,
                              )),
                          Column(
                            children: [
                              // Add the TypeAheadFormField here
                              Container(
                                width: size.width *
                                    0.8, // Adjust width if necessary
                                child: TypeAheadField(
                                  //   decorationBuilder: (context, child) {
                                  //   return Icon(Icons.abc);
                                  // },
                                  controller: _typeAheadController,

                                  suggestionsCallback: (pattern) async {
                                    return await Provider.of<Controller>(
                                            context,
                                            listen: false)
                                        .getSuggestions(pattern);
                                  },
                                  itemBuilder: (context, suggestio) {
                                    // Cast suggestion to Map<String, dynamic>
                                    final suggestionMap =
                                        suggestio as Map<String, dynamic>;

                                    return ListTile(
                                      title: Text(suggestionMap['acc_code']
                                          .toString()), // Now accessing the 'acc_name' properly
                                    );
                                  },
                                  onSelected: (suggestion) async {
                                    if (suggestion != null) {
                                      final suggestionMap =
                                          suggestion as Map<String, dynamic>;

                                      // Print the acc_name if the suggestion is not null
                                      print(
                                          'Selected Supplier: $suggestionMap');

                                      // Update the TextField with selected supplier
                                      _typeAheadController.text =
                                          suggestionMap['acc_code'];
                                      await Provider.of<Controller>(context,
                                              listen: false)
                                          .setSelectedsupplier(suggestionMap);
                                    }
                                    // Update selected supplier and text field
                                    // _typeAheadController.text =
                                    //     suggestion['acc_name'];
                                    // value.selectedsuplier =
                                    //     suggestion['acc_name']; // You can update the selected supplier in your controller
                                  },
                                  // noItemsFoundBuilder: (context) => Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Text('No Suppliers Found'),
                                  // ),
                                  //  onSelected: (Object? value) {  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                value.selectedSupplierMap != null && value.selectedSupplierMap!.isNotEmpty 
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 11.0, left: 25, bottom: 3, right: 11),
                              child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      // color: Colors.yellow,
                                      width: size.width * 1 / 3.5,
                                      child: Text(
                                        "ACC CODE",
                                        style: TextStyle(
                                          color: Colors.black,
                                        
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                        child: Text(value
                                            .selectedSupplierMap!["acc_code"]
                                            .toString()
                                            .trimLeft(),style: TextStyle(  fontWeight: FontWeight.bold,),))
                                  ])),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, bottom: 11.0, right: 11),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      // color: Colors.yellow,
                                      width: size.width * 1 / 3.5,
                                      child: Text(
                                        "ACC NAME",
                                        style: TextStyle(
                                          color: Colors.black,
                                        
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                        child: Text(value
                                            .selectedSupplierMap!["acc_name"]
                                            .toString()
                                            .trimLeft(),style: TextStyle(  fontWeight: FontWeight.bold,),))
                                  ])),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 11.0, left: 25, bottom: 11.0, right: 11),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(10),
                                        // color: Colors.yellow,
                                        width: size.width * 1 / 3.5,
                                        child: Text(
                                          "Bag Count",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )),
                                    SizedBox(
                                      width: 70,
                                      height: 45,
                                      child: customTextfield(
                                          bagno_ctrl,
                                          1,
                                          TextInputType.number,
                                          (String value) {}),
                                    )
                                  ])),
                          SizedBox(
                            height: 30,
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                child: Text(
                                  "NEXT",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                    if (value.selectedsuplier != "" &&
                            value.selectedsuplier.toString().toLowerCase() !=
                                "null" &&
                            value.selectedsuplier.toString().isNotEmpty &&
                            value.selectedrut != null &&
                            bagno_ctrl.text != "" ) {
                               Navigator.of(context).push(
                                    PageRouteBuilder(
                                        opaque: false, // set to false
                                        pageBuilder: (_, __, ___) => BagCountPage(
                                              bagcount: int.parse(bagno_ctrl.text
                                                  .toString()
                                                  .trim()),
                                            )),
                                  );
                              
                            }
                            else {
                          CustomSnackbar snak = CustomSnackbar();
                          snak.showSnackbar(context, "Fill all fields", "");
                        }
                                 
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          )),
        ),
      ),
    );
  }

  TextFormField customTextfield(TextEditingController contr, int? maxline,
      TextInputType typ, Function? fun) {
    return TextFormField(
      onChanged: (value) {
        if (fun != null) {
          fun(value);
        }
      },
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
              Text('Want to exit from this app'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      );
    },
  );
}
