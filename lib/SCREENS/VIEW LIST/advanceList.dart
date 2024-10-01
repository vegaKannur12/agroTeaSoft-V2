import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/COLLECTION/collection.dart';
import 'package:tsupply/SCREENS/DRAWER/customdrawer.dart';
import 'dart:io';

class AdvanceList extends StatefulWidget {
  final String frompage;
  AdvanceList({super.key, required this.frompage});
  @override
  State<AdvanceList> createState() => _AdvanceListState();
}

class _AdvanceListState extends State<AdvanceList>
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
            "ADVANCE LIST",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          backgroundColor: Colors.lightGreen,
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          //   finalbagListloading
          child: Consumer<Controller>(
              builder: (BuildContext context, Controller value, Widget? child) {
            if (value.finaladvncebagloading) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          value.finalADVBagList[0]["transactions"].length,
                      itemBuilder: ((context, index) {
                        List list = value.finalADVBagList[0]["transactions"];
                        print("list---  > $list");

                        return Container(
                          color: Color.fromARGB(255, 243, 244, 245),
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Padding(
                              padding:  const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
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
                                    ": ${list[index]["trans_id"].toString()}",
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
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
                                        "Amount",
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
                                      " : ${list[index]["adv_amt"].toString()} \u{20B9}",
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
                                      " : ${list[index]["adv_party_name"].toString()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                ),
                                list[index]["adv_import_id"].toString() ==
                                            "0" &&
                                        widget.frompage == "home"
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              size: 20,
                                              Icons.edit,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              print("Edit---adv------${list[index].runtimeType}");
                                              print("Edit--adv-------${list[index]}");
                                              await Provider.of<Controller>(
                                                      context,
                                                      listen: false)
                                                  .setEditAdvList(list[index]);
                                              // value.editColctMap = list[index];..
                                              print("edit adv Map-> ${value.editAdvnceMap}");
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                    opaque:
                                                        false, // set to false
                                                    pageBuilder: (_, __, ___) =>
                                                        CollectionPage(
                                                            frompage:
                                                                "advedit")),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  content: Text(
                                                      "Do you want to delete?"),
                                                  actions: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black),
                                                          onPressed: () async {
                                                            await Provider.of<
                                                                        Controller>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deleteAdvance(
                                                                    list[index][
                                                                        "trans_id"],
                                                                    context);
                                                            Navigator.of(ctx)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        SizedBox(width: 12),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black),
                                                          onPressed: () {
                                                            Navigator.of(ctx)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            "No",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : SizedBox()
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.symmetric(vertical: 5),
                                //   child: Row(children: [
                                //     SizedBox(
                                //       width: 65,
                                //       child: Text(
                                //         textAlign: TextAlign.left,
                                //         "Trans ID",
                                //         style: TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 15,
                                //         ),
                                //         overflow: TextOverflow.ellipsis,
                                //       ),
                                //     ),
                                //     Text(
                                //       textAlign: TextAlign.left,
                                //       // maxLines: 2,
                                //       // "SDFGGGTHHJJJJJJJJSSShjhjhj",
                                //       " : ${list[index]["trans_id"].toString()}",
                                //       style: TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 15,
                                //           fontWeight: FontWeight.bold),
                                //       overflow: TextOverflow.ellipsis,
                                //     ),
                                //   ]),
                                // ),
                              ],
                            ),
                            trailing: list[index]["adv_import_id"].toString() ==
                                    "0"
                                ? Text("")
                                : Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        color: Colors.yellow,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text(
                                      "${list[index]["adv_import_id"].toString()}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                            selectedTileColor: Colors.blue.withOpacity(0.5),
                          ),
                        );
                      })),
                ],
              );
            }
          }),
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
