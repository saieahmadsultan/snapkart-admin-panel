// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class OrdersScreen extends StatelessWidget {
//   const OrdersScreen({super.key});
//
//   final List<String> _statusOptions = const [
//     'Pending',
//     'Confirmed',
//     'Shipped',
//     'Delivered',
//     'Cancelled',
//   ];
//
//   Color _statusColor(String status) {
//     switch (status) {
//       case 'Delivered':
//         return Colors.green;
//       case 'Shipped':
//         return Colors.blue;
//       case 'Confirmed':
//         return Colors.orange;
//       case 'Cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   void _showOrderDetails(BuildContext context, DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final items = (data['items'] as List<dynamic>? ?? []);
//     final address = data['address'] as Map<String, dynamic>? ?? {};
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Order #${doc.id.substring(0, 6)}'),
//         content: SizedBox(
//           width: 420,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Items',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 6),
//                 ...items.map((item) {
//                   final m = item as Map<String, dynamic>;
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2),
//                     child: Text(
//                       '${m['name'] ?? m['title'] ?? 'Item'}  x${m['quantity'] ?? 1}  —  Rs ${m['price'] ?? 0}',
//                     ),
//                   );
//                 }),
//                 const Divider(height: 24),
//                 Text(
//                   'Total: Rs ${data['totalAmount'] ?? 0}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Delivery Address',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${address['name'] ?? ''}\n${address['street'] ?? ''}, ${address['city'] ?? ''}, ${address['province'] ?? ''}',
//                 ),
//                 const SizedBox(height: 12),
//                 Text('Payment: ${data['paymentMethod'] ?? '—'}'),
//               ],
//             ),
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
//             'Orders',
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
//                     .collection('orders')
//                     .orderBy('createdAt', descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text('No orders yet'));
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
//                                 DataColumn(label: Text('Order ID')),
//                                 DataColumn(label: Text('Total')),
//                                 DataColumn(label: Text('Payment')),
//                                 DataColumn(label: Text('Status')),
//                                 DataColumn(label: Text('Date')),
//                                 DataColumn(label: Text('Actions')),
//                               ],
//                               rows: docs.map((doc) {
//                                 final data = doc.data() as Map<String, dynamic>;
//                                 final status = data['status'] ?? 'Pending';
//                                 final timestamp =
//                                     data['createdAt'] as Timestamp?;
//                                 final dateStr = timestamp != null
//                                     ? '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}'
//                                     : '—';
//
//                                 return DataRow(
//                                   cells: [
//                                     DataCell(
//                                       Text('#${doc.id.substring(0, 6)}'),
//                                     ),
//                                     DataCell(
//                                       Text('Rs ${data['totalAmount'] ?? 0}'),
//                                     ),
//                                     DataCell(
//                                       Text(data['paymentMethod'] ?? '—'),
//                                     ),
//                                     DataCell(
//                                       DropdownButton<String>(
//                                         value: _statusOptions.contains(status)
//                                             ? status
//                                             : 'Pending',
//                                         underline: const SizedBox(),
//                                         items: _statusOptions.map((s) {
//                                           return DropdownMenuItem(
//                                             value: s,
//                                             child: Text(
//                                               s,
//                                               style: TextStyle(
//                                                 color: _statusColor(s),
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 13,
//                                               ),
//                                             ),
//                                           );
//                                         }).toList(),
//                                         onChanged: (newStatus) {
//                                           if (newStatus != null) {
//                                             FirebaseFirestore.instance
//                                                 .collection('orders')
//                                                 .doc(doc.id)
//                                                 .update({'status': newStatus});
//                                           }
//                                         },
//                                       ),
//                                     ),
//                                     DataCell(Text(dateStr)),
//                                     DataCell(
//                                       TextButton(
//                                         onPressed: () =>
//                                             _showOrderDetails(context, doc),
//                                         child: const Text('View'),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class OrdersScreen extends StatelessWidget {
//   const OrdersScreen({super.key});
//
//   final List<String> _statusOptions = const [
//     'Pending',
//     'Confirmed',
//     'Shipped',
//     'Delivered',
//     'Cancelled',
//   ];
//
//   Color _statusColor(String status) {
//     switch (status) {
//       case 'Delivered':
//         return Colors.green;
//       case 'Shipped':
//         return Colors.blue;
//       case 'Confirmed':
//         return Colors.orange;
//       case 'Cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   void _showOrderDetails(BuildContext context, DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final items = (data['items'] as List<dynamic>? ?? []);
//     final address = data['address'] as Map<String, dynamic>? ?? {};
//
//     final screenWidth = MediaQuery.of(context).size.width;
//     final dialogWidth = screenWidth < 480 ? screenWidth * 0.85 : 420.0;
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Order #${doc.id.substring(0, 6)}'),
//         content: SizedBox(
//           width: dialogWidth,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Items',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 6),
//                 ...items.map((item) {
//                   final m = item as Map<String, dynamic>;
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2),
//                     child: Text(
//                       '${m['name'] ?? m['title'] ?? 'Item'}  x${m['quantity'] ?? 1}  —  Rs ${m['price'] ?? 0}',
//                     ),
//                   );
//                 }),
//                 const Divider(height: 24),
//                 Text(
//                   'Total: Rs ${data['totalAmount'] ?? 0}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Delivery Address',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${address['name'] ?? ''}\n${address['street'] ?? ''}, ${address['city'] ?? ''}, ${address['province'] ?? ''}',
//                 ),
//                 const SizedBox(height: 12),
//                 Text('Payment: ${data['paymentMethod'] ?? '—'}'),
//               ],
//             ),
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
//                 'Orders',
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
//                         .collection('orders')
//                         .orderBy('createdAt', descending: true)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(child: Text('No orders yet'));
//                       }
//
//                       final docs = snapshot.data!.docs;
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
//                                     DataColumn(label: Text('Order ID')),
//                                     DataColumn(label: Text('Total')),
//                                     DataColumn(label: Text('Payment')),
//                                     DataColumn(label: Text('Status')),
//                                     DataColumn(label: Text('Date')),
//                                     DataColumn(label: Text('Actions')),
//                                   ],
//                                   rows: docs.map((doc) {
//                                     final data =
//                                         doc.data() as Map<String, dynamic>;
//                                     final status = data['status'] ?? 'Pending';
//                                     final timestamp =
//                                         data['createdAt'] as Timestamp?;
//                                     final dateStr = timestamp != null
//                                         ? '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}'
//                                         : '—';
//
//                                     return DataRow(
//                                       cells: [
//                                         DataCell(
//                                           Text('#${doc.id.substring(0, 6)}'),
//                                         ),
//                                         DataCell(
//                                           Text(
//                                             'Rs ${data['totalAmount'] ?? 0}',
//                                           ),
//                                         ),
//                                         DataCell(
//                                           Text(data['paymentMethod'] ?? '—'),
//                                         ),
//                                         DataCell(
//                                           DropdownButton<String>(
//                                             value:
//                                                 _statusOptions.contains(status)
//                                                 ? status
//                                                 : 'Pending',
//                                             underline: const SizedBox(),
//                                             items: _statusOptions.map((s) {
//                                               return DropdownMenuItem(
//                                                 value: s,
//                                                 child: Text(
//                                                   s,
//                                                   style: TextStyle(
//                                                     color: _statusColor(s),
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 13,
//                                                   ),
//                                                 ),
//                                               );
//                                             }).toList(),
//                                             onChanged: (newStatus) {
//                                               if (newStatus != null) {
//                                                 FirebaseFirestore.instance
//                                                     .collection('orders')
//                                                     .doc(doc.id)
//                                                     .update({
//                                                       'status': newStatus,
//                                                     });
//                                               }
//                                             },
//                                           ),
//                                         ),
//                                         DataCell(Text(dateStr)),
//                                         DataCell(
//                                           TextButton(
//                                             onPressed: () =>
//                                                 _showOrderDetails(context, doc),
//                                             child: const Text('View'),
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

// for currency

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../service/Currency_Service.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  final List<String> _statusOptions = const [
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Shipped':
        return Colors.blue;
      case 'Confirmed':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showOrderDetails(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>? ?? []);
    final address = data['address'] as Map<String, dynamic>? ?? {};

    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth < 480 ? screenWidth * 0.85 : 420.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #${doc.id.substring(0, 6)}'),
        content: SizedBox(
          width: dialogWidth,
          child: SingleChildScrollView(
            child: ValueListenableBuilder<String>(
              // Currency symbol Firestore se live aa raha hai.
              valueListenable: CurrencyService.instance.symbol,
              builder: (context, currency, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Items',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    ...items.map((item) {
                      final m = item as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '${m['name'] ?? m['title'] ?? 'Item'}  x${m['quantity'] ?? 1}  —  $currency ${m['price'] ?? 0}',
                        ),
                      );
                    }),
                    const Divider(height: 24),
                    Text(
                      'Total: $currency ${data['totalAmount'] ?? 0}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Delivery Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${address['name'] ?? ''}\n${address['street'] ?? ''}, ${address['city'] ?? ''}, ${address['province'] ?? ''}',
                    ),
                    const SizedBox(height: 12),
                    Text('Payment: ${data['paymentMethod'] ?? '—'}'),
                  ],
                );
              },
            ),
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
                'Orders',
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
                        .collection('orders')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No orders yet'));
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
                                // Currency symbol yahan bhi live sync hoga —
                                // pura table currency badalte hi rebuild ho
                                // jayega, kisi extra kaam ke bina.
                                child: ValueListenableBuilder<String>(
                                  valueListenable:
                                      CurrencyService.instance.symbol,
                                  builder: (context, currency, _) {
                                    return DataTable(
                                      columnSpacing: 32,
                                      horizontalMargin: 20,
                                      headingRowColor: WidgetStateProperty.all(
                                        const Color(0xFFF7F8FA),
                                      ),
                                      columns: const [
                                        DataColumn(label: Text('Order ID')),
                                        DataColumn(label: Text('Total')),
                                        DataColumn(label: Text('Payment')),
                                        DataColumn(label: Text('Status')),
                                        DataColumn(label: Text('Date')),
                                        DataColumn(label: Text('Actions')),
                                      ],
                                      rows: docs.map((doc) {
                                        final data =
                                            doc.data() as Map<String, dynamic>;
                                        final status =
                                            data['status'] ?? 'Pending';
                                        final timestamp =
                                            data['createdAt'] as Timestamp?;
                                        final dateStr = timestamp != null
                                            ? '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}'
                                            : '—';

                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                '#${doc.id.substring(0, 6)}',
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                '$currency ${data['totalAmount'] ?? 0}',
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                data['paymentMethod'] ?? '—',
                                              ),
                                            ),
                                            DataCell(
                                              DropdownButton<String>(
                                                value:
                                                    _statusOptions.contains(
                                                      status,
                                                    )
                                                    ? status
                                                    : 'Pending',
                                                underline: const SizedBox(),
                                                items: _statusOptions.map((s) {
                                                  return DropdownMenuItem(
                                                    value: s,
                                                    child: Text(
                                                      s,
                                                      style: TextStyle(
                                                        color: _statusColor(s),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (newStatus) {
                                                  if (newStatus != null) {
                                                    FirebaseFirestore.instance
                                                        .collection('orders')
                                                        .doc(doc.id)
                                                        .update({
                                                          'status': newStatus,
                                                        });
                                                  }
                                                },
                                              ),
                                            ),
                                            DataCell(Text(dateStr)),
                                            DataCell(
                                              TextButton(
                                                onPressed: () =>
                                                    _showOrderDetails(
                                                      context,
                                                      doc,
                                                    ),
                                                child: const Text('View'),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    );
                                  },
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
