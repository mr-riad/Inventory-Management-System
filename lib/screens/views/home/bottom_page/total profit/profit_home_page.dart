// import 'package:flutter/material.dart';
// import 'filter_profit_page.dart';
// import 'total_profit_page.dart';
//
// class ProfitHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Profit Overview',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//         elevation: 10,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Total Profit Button
//               Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: InkWell(
//                   onTap: () {
//                     // Navigate to the TotalProfitPage
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TotalProfitPage(),
//                       ),
//                     );
//                   },
//                   borderRadius: BorderRadius.circular(15),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 20,
//                       horizontal: 30,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.blueAccent, Colors.lightBlue],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'View Total Profit',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               // Filtered Profit Button
//               Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: InkWell(
//                   onTap: () async {
//                     // Show a date picker to select month and year
//                     final DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime.now(),
//                     );
//
//                     if (pickedDate != null) {
//                       // Navigate to the FilteredProfitPage with the selected month and year
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => FilteredProfitPage(
//                             selectedMonth: pickedDate.month,
//                             selectedYear: pickedDate.year,
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   borderRadius: BorderRadius.circular(15),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 20,
//                       horizontal: 30,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.purpleAccent, Colors.deepPurple],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'View Filtered Profit by Month',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }