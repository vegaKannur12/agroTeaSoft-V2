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
  // DialogRoutee rutdio = DialogRoutee();
  TextEditingController bagno_ctrl = TextEditingController();
  TextEditingController supCode_ctrl = TextEditingController();
  String? errorText = "gg";
  // final TextEditingController _typeAheadController = TextEditingController();
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
    await Provider.of<Controller>(context, listen: false).getSupplierfromDB("");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 193, 213, 252),
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
              SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Color.fromARGB(255, 193, 213, 252),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                      ),
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
                                  "Enter Supplier Code",
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.10,
                      ),
                    ],
                  ),
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
                                child: TextFormField(
                                  onChanged: (value) {
                                    if (supCode_ctrl.text.toString().isEmpty) {
                                      errorText = "";
                                    }
                                  },
                                  onTapOutside: (event) async {
                                    if (supCode_ctrl.text != "" ||
                                        supCode_ctrl.text
                                            .toString()
                                            .isNotEmpty) {
                                      await Provider.of<Controller>(context,
                                              listen: false)
                                          .getSupplierfromDB(supCode_ctrl.text
                                              .toString()
                                              .trim());

                                      if (value.spplierList.isNotEmpty) {
                                        errorText = "";
                                        print("suplier found");
                                        print("sup --${value.spplierList}");
                                      } else {
                                        errorText = "Supplier Not Found..";
                                        CustomSnackbar snak = CustomSnackbar();
                                        snak.showSnackbar(context,
                                            "Supplier Not Found..", "");
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  controller: supCode_ctrl,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 199, 198, 198),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 199, 198, 198),
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
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 7.0, left: 58, bottom: 11.0, right: 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            errorText.toString(),
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 7, top: 65),
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
                          onPressed: () async {
                            if (supCode_ctrl.text != "" ||
                                supCode_ctrl.text.toString().isNotEmpty) {
                              await Provider.of<Controller>(context,
                                      listen: false)
                                  .getSupplierfromDB(
                                      supCode_ctrl.text.toString().trim());

                              if (value.spplierList.isNotEmpty) {
                                errorText = "";
                                print("suplier found");
                                print("sup --${value.spplierList}");
                                await Provider.of<Controller>(context,
                                        listen: false)
                                    .setSelectedsupplier(value.spplierList[0]);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ChangeNotifierProvider.value(
                                      value: context.read<
                                          Controller>(), // Pass the existing instance
                                      child: BagCountPage(),
                                    ),
                                  ),
                                );
                                // Navigator.of(context).push(
                                //   PageRouteBuilder(
                                //     opaque: false, // set to false
                                //     pageBuilder: (_, __, ___) => BagCountPage(
                                //       // bagcount: int.parse(
                                //       //     bagno_ctrl.text.toString().trim()),
                                //     ),
                                //   ),
                                // );
                              } else {
                                errorText = "Supplier Not Found..";
                                CustomSnackbar snak = CustomSnackbar();
                                snak.showSnackbar(
                                    context, "Supplier Not Found..", "");
                              }
                            } else {
                              errorText = "";
                              CustomSnackbar snak = CustomSnackbar();
                              snak.showSnackbar(
                                  context, "Enter Supplier Code", "");
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
            child: const Text('Yes'),
            onPressed: () {
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
