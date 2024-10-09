import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:flutter/services.dart';

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
        child: Container(
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
                          "Enter weight of bags",
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
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
    );
  }
}
