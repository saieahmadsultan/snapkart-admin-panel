// import 'package:flutter/material.dart';
//
// class BundleScreen extends StatelessWidget {
//   const BundleScreen({super.key});
//
//   void _showBundleForm(BuildContext context) {
//     final bundleNameController = TextEditingController();
//     final bundlePriceController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Create Bundle"),
//           content: SizedBox(
//             width: 400,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: bundleNameController,
//                   decoration: const InputDecoration(labelText: "Bundle Name"),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: bundlePriceController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: "Bundle Price"),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Bundle Offers",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//
//               ElevatedButton.icon(
//                 onPressed: () {
//                   _showBundleForm(context);
//                 },
//                 icon: const Icon(Icons.add),
//                 label: const Text("Add Bundle"),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 30),
//
//           const Expanded(
//             child: Center(
//               child: Text(
//                 "No Bundle Offers Yet",
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
