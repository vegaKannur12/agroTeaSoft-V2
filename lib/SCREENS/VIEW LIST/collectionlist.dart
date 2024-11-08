import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/SCREENS/COLLECTION/collection.dart';
import 'package:tsupply/SCREENS/DRAWER/customdrawer.dart';
import 'dart:io';

class CollectionList extends StatefulWidget {
  final String frompage;
  const CollectionList({super.key, required this.frompage});

  @override
  State<CollectionList> createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
            child: Text(
              "COLLECTIONS",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.lightGreen,
        ),
        drawer: CustomDrawer(),
        body: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) {
            if (value.finalbagListloading) {
              return const CircularProgressIndicator();
            } else {
              final DateTime today = DateTime.now();
              // Group transactions by date
              Map<String, List> groupedTransactions = {};
              for (var transaction in value.finalBagList[0]["transactions"]) {
                String date = transaction["trans_date"].toString();
                if (groupedTransactions[date] == null) {
                  groupedTransactions[date] = [];
                }
                groupedTransactions[date]!.add(transaction);
              }

               // Sort dates in descending order
            List<String> sortedDates = groupedTransactions.keys.toList()
              ..sort((a, b) {
                DateTime dateA = DateFormat("yyyy-MM-dd").parse(a);
                DateTime dateB = DateFormat("yyyy-MM-dd").parse(b);
                return dateB.compareTo(dateA); // Descending order
              });

              return ListView.builder(
                itemCount: sortedDates.length,
                itemBuilder: (context, index) {
                   String date = sortedDates[index];
                   List transactions = groupedTransactions[date]!;
                    // Sort transactions by time in descending order (latest first)
                // transactions.sort((a, b) {
                //   DateTime timeA = DateFormat("yyyy-MM-dd HH:mm:ss")
                //       .parse(a["trans_date"].toString());
                //   DateTime timeB = DateFormat("yyyy-MM-dd HH:mm:ss")
                //       .parse(b["trans_date"].toString());
                //   return timeB.compareTo(timeA); // Descending order
                // });
                 DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
                  // Get the date and transactions for this group
                       String dateLabel = parsedDate.year == today.year &&
                                   parsedDate.month == today.month &&
                                   parsedDate.day == today.day
                               ? "Today"
                               : DateFormat("MMMM dd, yyyy").format(parsedDate);                
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Display the date
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Container(padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                          child: Text(
                            "$dateLabel",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      //  ${transaction["details"][0]["trans_det_mast_id"].toString()}
                      
                      
                      // Display each transaction under the date
                      ...transactions.map((transaction) {
                        return Container(
                          color: Color.fromARGB(255, 243, 244, 245),
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Text(
                                //   "${list[index]["details"][0]["trans_det_mast_id"].toString()}",
                                //   style: TextStyle(
                                //       fontSize: 20,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(children: [
                                    SizedBox(
                                      width: 65,
                                      child: Text(
                                        textAlign: TextAlign.left,
                                        "Trans ID",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.left,
                                      // maxLines: 2,
                                      // "SDFGGGTHHJJJJJJJJSSShjhjhj",
                                       " : ${transaction["details"][0]["trans_det_mast_id"].toString()}",
                                      // " : ${list[index]["trans_id"].toString()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(children: [
                                    SizedBox(
                                      width: 65,
                                      child: Text(
                                        textAlign: TextAlign.left,
                                        "Party",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.left,
                                      // maxLines: 2,
                                      // "SDFGGGTHHJJJJJJJJSSShjhjhj",
                                      " : ${transaction["trans_party_name"].toString()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(children: [
                                    SizedBox(
                                      width: 65,
                                      child: Text(
                                        textAlign: TextAlign.left,
                                        "Bag Nos",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.left,
                                      // maxLines: 2,
                                      // "SDFGGGTHHJJJJJJJJSSShjhjhj",
                                      " : ${transaction["trans_bag_nos"].toString()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                ),
                                 Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(children: [
                                    SizedBox(
                                      width: 65,
                                      child: Text(
                                        textAlign: TextAlign.left,
                                        "Product",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.left,
                                      // maxLines: 2,
                                      // "SDFGGGTHHJJJJJJJJSSShjhjhj",
                                      " : ${transaction["details"][0]["trans_det_prod_nm"].toString()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(children: [
                                    SizedBox(
                                      width: 65,
                                      child: Text(
                                        textAlign: TextAlign.left,
                                        "Net Weight",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.left,  " : ${transaction["details"][0]["trans_det_net_qty"].toString()} KG",
                                      // maxLines: 2,
                                      // "SDFGGGTHHJJJJJJJJSSShjhjhj",
                                      // " : ${list[index]["trans_bag_weights"].toString()}",

                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                ),
                                // transaction["trans_import_id"].toString() ==
                                //             "0"
                                //         //      &&
                                //         // widget.frompage == "home"
                                //     ? Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.end,
                                //         children: [
                                //           IconButton(
                                //             icon: Icon(
                                //               size: 20,
                                //               Icons.edit,
                                //               color: Colors.red,
                                //             ),
                                //             onPressed: () async {
                                //               print(
                                //                   "Edit---------${transaction.runtimeType}");
                                //               print(
                                //                   "Edit---------${transaction}");
                                //               await Provider.of<Controller>(
                                //                       context,
                                //                       listen: false)
                                //                   .setEditcollectList(
                                //                       transaction);
                                //               // value.editColctMap = list[index];..
                                //               print(
                                //                   "edit colect Map-> ${value.editColctMap}");

                                //               // Navigator.of(context).push(
                                //               //   PageRouteBuilder(
                                //               //       opaque:
                                //               //           false, // set to false
                                //               //       pageBuilder: (_, __, ___) =>
                                //               //           CollectionPage(
                                //               //               frompage: "edit")),
                                //               // );
                                //             },
                                //           ),
                                //           IconButton(
                                //             icon: Icon(
                                //               Icons.delete,
                                //               size: 20,
                                //               color: Colors.red,
                                //             ),
                                //             onPressed: () async {
                                //               showDialog(
                                //                 context: context,
                                //                 builder: (ctx) => AlertDialog(
                                //                   content: Text(
                                //                       "Do you want to delete?"),
                                //                   actions: <Widget>[
                                //                     Row(
                                //                       mainAxisAlignment:
                                //                           MainAxisAlignment.end,
                                //                       children: [
                                //                         ElevatedButton(
                                //                           style: ElevatedButton
                                //                               .styleFrom(
                                //                                   backgroundColor:
                                //                                       Colors
                                //                                           .black),
                                //                           onPressed: () async {
                                //                             await Provider.of<
                                //                                         Controller>(
                                //                                     context,
                                //                                     listen:
                                //                                         false)
                                //                                 .deleteTrans(
                                //                                     transaction[
                                //                                         "trans_id"],
                                //                                     context);
                                //                             Navigator.of(ctx)
                                //                                 .pop();
                                //                           },
                                //                           child: Text(
                                //                             "Yes",
                                //                             style: TextStyle(
                                //                                 color: Colors
                                //                                     .white),
                                //                           ),
                                //                         ),
                                //                         SizedBox(width: 12),
                                //                         ElevatedButton(
                                //                           style: ElevatedButton
                                //                               .styleFrom(
                                //                                   backgroundColor:
                                //                                       Colors
                                //                                           .black),
                                //                           onPressed: () {
                                //                             Navigator.of(ctx)
                                //                                 .pop();
                                //                           },
                                //                           child: Text(
                                //                             "No",
                                //                             style: TextStyle(
                                //                                 color: Colors
                                //                                     .white),
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ],
                                //                 ),
                                //               );
                                //             },
                                //           ),
                                //         ],
                                //       )
                                //     : SizedBox()
                              ],
                            ),
                            trailing:
                                transaction["trans_import_id"].toString() == "0"
                                    ? Text("")
                                    : Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                            color: Colors.yellow,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Text(
                                          "${transaction["trans_import_id"].toString()}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        )),
                            selectedTileColor: Colors.blue.withOpacity(0.5),
                          ),
                        );
                      })
                    ],
                  );
                },
              );
            }
          },
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
