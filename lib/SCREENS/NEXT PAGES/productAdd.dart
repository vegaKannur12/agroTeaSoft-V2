import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/advanceAdd.dart';
import 'package:tsupply/SCREENS/NEXT%20PAGES/damageNremark.dart';
import 'package:tsupply/tableList.dart';

class ProductAddPage extends StatefulWidget {
  final String bagcount;
  final String weightString;
  final String? total;
  final String? damage;
  final String? nettotal;
  final String? remarks;

  const ProductAddPage(
      {super.key,
      required this.total,
      required this.damage,
      required this.nettotal,
      required this.weightString,
      required this.bagcount,
      required this.remarks});

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  DateTime date = DateTime.now();
  String? displaydate;
  String? transactDate;
  int? u_id;
  String? uname;
  String? upwd;
  int? br_id;
  int? c_id;
  double summ = 0;

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
  void initState() {
    super.initState();
    Provider.of<Controller>(context, listen: false).geTseries();
    getSharedpref();
    //    if (Provider.of<Controller>(context, listen: false).prodList.isNotEmpty) {
    //   selectedPro = Provider.of<Controller>(context, listen: false).prodList[0]; // or leave it null
    // }
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
          IconButton(
            onPressed: () async {
              List<Map<String, dynamic>> list =
                  await TeaDB.instance.getListOfTables();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TableList(list: list)),
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
                                  "Select Product",
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
                                color: Color.fromARGB(255, 165, 162, 165),
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
                      SizedBox(
                        height: 30,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: size
                              .width, // Set the max width to the full screen width
                        ),
                        child: IntrinsicWidth(
                          child: Container(
                            height: size.height * 0.09,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            // width: 117,
                            child: DropdownButton<Map<String, dynamic>>(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10),
                              underline: SizedBox(),
                              padding: EdgeInsets.all(12),
                              hint: Text("Select"),
                              value: value.selectedPro,
                              onChanged:
                                  (Map<String, dynamic>? newValue) async {
                                setState(() {
                                  value.selectedPro = newValue;
                                  print("selected pro---${value.selectedPro}");
                                });
                                await Provider.of<Controller>(context,
                                        listen: false)
                                    .setSelectedProduct(value.selectedPro!);
                              },
                              items: value.prodList
                                  .map<DropdownMenuItem<Map<String, dynamic>>>(
                                      (Map<String, dynamic> pro) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: pro,
                                  child: Text(pro['product']),
                                );
                              }).toList(),
                            ),
                          ),
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
                onPressed: () async {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                        opaque: false, // set to false
                        pageBuilder: (_, __, ___) => AdvanceAddPage(
                              total: widget.total.toString(),
                              damage: widget.damage.toString(),
                              nettotal: widget.nettotal.toString(),
                              bagcount: widget.bagcount.toString(),
                              weightString: widget.weightString.toString(),
                              remarks: widget.remarks.toString(),
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
