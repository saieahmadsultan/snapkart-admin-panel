// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class CustomersScreen extends StatelessWidget {
//   const CustomersScreen({super.key});
//
//   void _showCustomerOrders(BuildContext context, String uid, String name) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('$name — Orders'),
//         content: SizedBox(
//           width: 420,
//           height: 400,
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('orders')
//                 .where('userId', isEqualTo: uid)
//                 .orderBy('createdAt', descending: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return const Center(
//                   child: Text('No orders from this customer yet'),
//                 );
//               }
//
//               final docs = snapshot.data!.docs;
//
//               return ListView.separated(
//                 itemCount: docs.length,
//                 separatorBuilder: (_, __) => const Divider(),
//                 itemBuilder: (context, index) {
//                   final data = docs[index].data() as Map<String, dynamic>;
//                   final status = data['status'] ?? 'Pending';
//                   return ListTile(
//                     title: Text('Order #${docs[index].id.substring(0, 6)}'),
//                     subtitle: Text(
//                       'Rs ${data['totalAmount'] ?? 0}  •  ${data['paymentMethod'] ?? '—'}',
//                     ),
//                     trailing: Text(
//                       status,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(32),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Customers',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: const Color(0xFFE8E9EE)),
//               ),
//               // Clip so the table's rounded corners still match the card
//               // once the table below is stretched to fill the full width.
//               clipBehavior: Clip.antiAlias,
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .orderBy('createdAt', descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(
//                       child: Text('No registered customers yet'),
//                     );
//                   }
//
//                   final docs = snapshot.data!.docs;
//
//                   // LayoutBuilder gives us the card's actual available width
//                   // so the table can be forced to stretch to fill it instead
//                   // of shrinking to its content width (which left blank
//                   // space on the right side).
//                   return LayoutBuilder(
//                     builder: (context, constraints) {
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(
//                               minWidth: constraints.maxWidth,
//                             ),
//                             child: DataTable(
//                               columnSpacing: 32,
//                               horizontalMargin: 20,
//                               headingRowColor: WidgetStateProperty.all(
//                                 const Color(0xFFF7F8FA),
//                               ),
//                               columns: const [
//                                 DataColumn(label: Text('Name')),
//                                 DataColumn(label: Text('Email')),
//                                 DataColumn(label: Text('Joined')),
//                                 DataColumn(label: Text('Actions')),
//                               ],
//                               rows: docs.map((doc) {
//                                 final data = doc.data() as Map<String, dynamic>;
//                                 final firstName = data['first name'] ?? '';
//                                 final lastName = data['last name'] ?? '';
//                                 final fullName = '$firstName $lastName'.trim();
//                                 final displayName = fullName.isEmpty
//                                     ? 'No Name'
//                                     : fullName;
//                                 final timestamp =
//                                     data['createdAt'] as Timestamp?;
//                                 final dateStr = timestamp != null
//                                     ? '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}'
//                                     : '—';
//
//                                 return DataRow(
//                                   cells: [
//                                     DataCell(Text(displayName)),
//                                     DataCell(Text(data['email'] ?? '—')),
//                                     DataCell(Text(dateStr)),
//                                     DataCell(
//                                       TextButton(
//                                         onPressed: () => _showCustomerOrders(
//                                           context,
//                                           doc.id,
//                                           displayName,
//                                         ),
//                                         child: const Text('View Orders'),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class CustomersScreen extends StatelessWidget {
//   const CustomersScreen({super.key});
//
//   void _showCustomerOrders(BuildContext context, String uid, String name) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final dialogWidth = screenWidth < 480 ? screenWidth * 0.88 : 420.0;
//     final dialogHeight = screenHeight < 600 ? screenHeight * 0.6 : 400.0;
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('$name — Orders'),
//         content: SizedBox(
//           width: dialogWidth,
//           height: dialogHeight,
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('orders')
//                 .where('userId', isEqualTo: uid)
//                 .orderBy('createdAt', descending: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return const Center(
//                   child: Text('No orders from this customer yet'),
//                 );
//               }
//
//               final docs = snapshot.data!.docs;
//
//               return ListView.separated(
//                 itemCount: docs.length,
//                 separatorBuilder: (_, __) => const Divider(),
//                 itemBuilder: (context, index) {
//                   final data = docs[index].data() as Map<String, dynamic>;
//                   final status = data['status'] ?? 'Pending';
//                   return ListTile(
//                     title: Text('Order #${docs[index].id.substring(0, 6)}'),
//                     subtitle: Text(
//                       'Rs ${data['totalAmount'] ?? 0}  •  ${data['paymentMethod'] ?? '—'}',
//                     ),
//                     trailing: Text(
//                       status,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final padding = constraints.maxWidth < 500 ? 16.0 : 32.0;
//
//         return Padding(
//           padding: EdgeInsets.all(padding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Customers',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: const Color(0xFFE8E9EE)),
//                   ),
//                   clipBehavior: Clip.antiAlias,
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('users')
//                         .orderBy('createdAt', descending: true)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(
//                           child: Text('No registered customers yet'),
//                         );
//                       }
//
//                       final docs = snapshot.data!.docs;
//
//                       return LayoutBuilder(
//                         builder: (context, tableConstraints) {
//                           return SingleChildScrollView(
//                             scrollDirection: Axis.vertical,
//                             child: SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   minWidth: tableConstraints.maxWidth,
//                                 ),
//                                 child: DataTable(
//                                   columnSpacing: 32,
//                                   horizontalMargin: 20,
//                                   headingRowColor: WidgetStateProperty.all(
//                                     const Color(0xFFF7F8FA),
//                                   ),
//                                   columns: const [
//                                     DataColumn(label: Text('Name')),
//                                     DataColumn(label: Text('Email')),
//                                     DataColumn(label: Text('Joined')),
//                                     DataColumn(label: Text('Actions')),
//                                   ],
//                                   rows: docs.map((doc) {
//                                     final data =
//                                         doc.data() as Map<String, dynamic>;
//                                     final firstName = data['first name'] ?? '';
//                                     final lastName = data['last name'] ?? '';
//                                     final fullName = '$firstName $lastName'
//                                         .trim();
//                                     final displayName = fullName.isEmpty
//                                         ? 'No Name'
//                                         : fullName;
//                                     final timestamp =
//                                         data['createdAt'] as Timestamp?;
//                                     final dateStr = timestamp != null
//                                         ? '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}'
//                                         : '—';
//
//                                     return DataRow(
//                                       cells: [
//                                         DataCell(Text(displayName)),
//                                         DataCell(Text(data['email'] ?? '—')),
//                                         DataCell(Text(dateStr)),
//                                         DataCell(
//                                           TextButton(
//                                             onPressed: () =>
//                                                 _showCustomerOrders(
//                                                   context,
//                                                   doc.id,
//                                                   displayName,
//                                                 ),
//                                             child: const Text('View Orders'),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../service/Currency_Service.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  void _showCustomerOrders(BuildContext context, String uid, String name) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogWidth = screenWidth < 480 ? screenWidth * 0.88 : 420.0;
    final dialogHeight = screenHeight < 600 ? screenHeight * 0.6 : 400.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$name — Orders'),
        content: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('userId', isEqualTo: uid)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No orders from this customer yet'),
                );
              }

              final docs = snapshot.data!.docs;

              return ListView.separated(
                itemCount: docs.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final status = data['status'] ?? 'Pending';
                  return ListTile(
                    title: Text('Order #${docs[index].id.substring(0, 6)}'),
                    subtitle: ValueListenableBuilder<String>(
                      valueListenable: CurrencyService.instance.symbol,
                      builder: (context, currency, _) {
                        return Text(
                          '$currency ${data['totalAmount'] ?? 0}  •  ${data['paymentMethod'] ?? '—'}',
                        );
                      },
                    ),
                    trailing: Text(
                      status,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 500 ? 16.0 : 32.0;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customers',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8E9EE)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No registered customers yet'),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return LayoutBuilder(
                        builder: (context, tableConstraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: tableConstraints.maxWidth,
                                ),
                                child: DataTable(
                                  columnSpacing: 32,
                                  horizontalMargin: 20,
                                  headingRowColor: WidgetStateProperty.all(
                                    const Color(0xFFF7F8FA),
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('Name')),
                                    DataColumn(label: Text('Email')),
                                    DataColumn(label: Text('Joined')),
                                    DataColumn(label: Text('Actions')),
                                  ],
                                  rows: docs.map((doc) {
                                    final data =
                                    doc.data() as Map<String, dynamic>;
                                    final firstName = data['first name'] ?? '';
                                    final lastName = data['last name'] ?? '';
                                    final fullName = '$firstName $lastName'
                                        .trim();
                                    final displayName = fullName.isEmpty
                                        ? 'No Name'
                                        : fullName;
                                    final timestamp =
                                    data['createdAt'] as Timestamp?;
                                    final dateStr = timestamp != null
                                        ? '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}'
                                        : '—';

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(displayName)),
                                        DataCell(Text(data['email'] ?? '—')),
                                        DataCell(Text(dateStr)),
                                        DataCell(
                                          TextButton(
                                            onPressed: () =>
                                                _showCustomerOrders(
                                                  context,
                                                  doc.id,
                                                  displayName,
                                                ),
                                            child: const Text('View Orders'),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}