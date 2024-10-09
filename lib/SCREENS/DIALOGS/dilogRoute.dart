// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tsupply/CONTROLLER/controller.dart';

// class DialogRoutee {
//   showRouteDialog(BuildContext context) async {
//     Size size = MediaQuery.of(context).size;
//     Map<String, dynamic>? selectedRoute;
//     Dialog fancyDialog = Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: StatefulBuilder(
//           builder:
//               (BuildContext context, void Function(void Function()) setState) =>
//                   Consumer<Controller>(
//             builder: (context, value, child) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 10,),
//                   Container(
//                     color: Colors.grey[100],
//                     height: size.height * 0.07,
//                     child: DropdownButton<Map<String, dynamic>>(
//                       hint: Text("Select Route"),
//                       value: selectedRoute,
//                       onChanged: (Map<String, dynamic>? newValue) async {
//                         setState(() {
//                           selectedRoute = newValue;
//                           print("selected root---$selectedRoute");
//                         });
//                         await Provider.of<Controller>(context, listen: false)
//                             .setSelectedroute(selectedRoute!);
//                       },
//                       items: value.routeList
//                           .map<DropdownMenuItem<Map<String, dynamic>>>(
//                               (Map<String, dynamic> route) {
//                         return DropdownMenuItem<Map<String, dynamic>>(
//                           value: route,
//                           child: Text(route['routename']),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   ElevatedButton(
//                      style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                           ),
//                       onPressed: () async {
//                         if (selectedRoute != null) {
//                           print("---------$selectedRoute");
//                           SharedPreferences prefs =
//                               await SharedPreferences.getInstance();
//                           int? rid = prefs.getInt("sel_rootid");
//                           await Provider.of<Controller>(context, listen: false)
//                               .getSupplierfromDB(rid);
//                           Navigator.pop(context);
//                         } else {
//                           Fluttertoast.showToast(
//                               msg: "Select root",
//                               backgroundColor: Colors.amber[100],
//                               toastLength: Toast.LENGTH_SHORT,
//                               gravity: ToastGravity.CENTER,
//                               timeInSecForIosWeb: 1,
//                               textColor: Colors.black,
//                               fontSize: 16.0);
//                         }
//                       },
//                       child: const Text("save",style: TextStyle(color: Colors.white),)),
//                       SizedBox(height: 10,),
//                 ],
//               );
//             },
//           ),
//         ));
//     showDialog(
//         context: context, builder: (BuildContext context) => fancyDialog);
//   }
// }
