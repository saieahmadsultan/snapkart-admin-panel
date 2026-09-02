// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class ProductsScreen extends StatelessWidget {
//   const ProductsScreen({super.key});
//
//   void _showProductForm(BuildContext context, {DocumentSnapshot? existing}) {
//     final titleController = TextEditingController(
//       text: existing?['title'] ?? '',
//     );
//     final priceController = TextEditingController(
//       text: existing != null ? existing['price'].toString() : '',
//     );
//     final imageController = TextEditingController(
//       text: existing?['image'] ?? '',
//     );
//     final stockController = TextEditingController(
//       text: existing != null ? (existing['stock'] ?? 0).toString() : '0',
//     );
//     final descController = TextEditingController(
//       text: existing?['description'] ?? '',
//     );
//
//     // Selected category ke liye ValueNotifier (dropdown update karne ke liye)
//     final selectedCategory = ValueNotifier<String?>(
//       existing?['category'] as String?,
//     );
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(existing == null ? 'Add Product' : 'Edit Product'),
//         content: SizedBox(
//           width: 400,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: 'Title'),
//                 ),
//                 TextField(
//                   controller: priceController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: 'Price'),
//                 ),
//                 const SizedBox(height: 8),
//                 //  YAHAN CATEGORY DROPDOWN — Firestore se live categories
//                 StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('categories')
//                       .orderBy('name')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                         child: Text('Loading categories...'),
//                       );
//                     }
//
//                     final categoryNames = snapshot.data!.docs
//                         .map(
//                           (doc) =>
//                               (doc.data() as Map<String, dynamic>)['name']
//                                   as String,
//                         )
//                         .toList();
//
//                     if (categoryNames.isEmpty) {
//                       return const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                         child: Text(
//                           'No categories yet — add one from Categories screen first',
//                           style: TextStyle(color: Colors.red, fontSize: 12),
//                         ),
//                       );
//                     }
//
//                     return ValueListenableBuilder<String?>(
//                       valueListenable: selectedCategory,
//                       builder: (context, value, _) {
//                         // Agar existing category list mein nahi hai to null rakho
//                         final validValue = categoryNames.contains(value)
//                             ? value
//                             : null;
//
//                         return DropdownButtonFormField<String>(
//                           initialValue: validValue,
//                           decoration: const InputDecoration(
//                             labelText: 'Category',
//                           ),
//                           items: categoryNames.map((name) {
//                             return DropdownMenuItem(
//                               value: name,
//                               child: Text(name),
//                             );
//                           }).toList(),
//                           onChanged: (val) => selectedCategory.value = val,
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: stockController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: 'Stock'),
//                 ),
//                 TextField(
//                   controller: imageController,
//                   decoration: const InputDecoration(labelText: 'Image URL'),
//                 ),
//                 TextField(
//                   controller: descController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(labelText: 'Description'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (selectedCategory.value == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please select a category')),
//                 );
//                 return;
//               }
//
//               final data = {
//                 'title': titleController.text.trim(),
//                 'price': double.tryParse(priceController.text.trim()) ?? 0.0,
//                 'category': selectedCategory.value,
//                 'stock': int.tryParse(stockController.text.trim()) ?? 0,
//                 'image': imageController.text.trim(),
//                 'description': descController.text.trim(),
//               };
//
//               final firestore = FirebaseFirestore.instance.collection(
//                 'products',
//               );
//
//               if (existing == null) {
//                 await firestore.add(data);
//               } else {
//                 await firestore.doc(existing.id).update(data);
//               }
//
//               if (context.mounted) Navigator.pop(context);
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _confirmDelete(BuildContext context, String docId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Product'),
//         content: const Text('Are you sure you want to delete this product?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               await FirebaseFirestore.instance
//                   .collection('products')
//                   .doc(docId)
//                   .delete();
//               if (context.mounted) Navigator.pop(context);
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Products',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () => _showProductForm(context),
//                 icon: const Icon(Icons.add),
//                 label: const Text('Add Product'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrange,
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: const Color(0xFFE8E9EE)),
//               ),
//               // Clip so the table's rounded corners match the card, even
//               // when it's stretched to fill the full width below.
//               clipBehavior: Clip.antiAlias,
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('products')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text('No products yet'));
//                   }
//
//                   final docs = snapshot.data!.docs;
//
//                   // LayoutBuilder gives us the actual available width of the
//                   // card so we can force the table to stretch to fill it
//                   // instead of shrinking to its content width (which was
//                   // leaving blank space on the right side).
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
//                                 DataColumn(label: Text('Image')),
//                                 DataColumn(label: Text('Title')),
//                                 DataColumn(label: Text('Category')),
//                                 DataColumn(label: Text('Price')),
//                                 DataColumn(label: Text('Stock')),
//                                 DataColumn(label: Text('Actions')),
//                               ],
//                               rows: docs.map((doc) {
//                                 final data = doc.data() as Map<String, dynamic>;
//                                 return DataRow(
//                                   cells: [
//                                     DataCell(
//                                       SizedBox(
//                                         width: 40,
//                                         height: 40,
//                                         child:
//                                             data['image'] != null &&
//                                                 data['image']
//                                                     .toString()
//                                                     .isNotEmpty
//                                             ? Image.network(
//                                                 data['image'],
//                                                 fit: BoxFit.contain,
//                                                 errorBuilder: (_, __, ___) =>
//                                                     const Icon(
//                                                       Icons.broken_image,
//                                                     ),
//                                               )
//                                             : const Icon(
//                                                 Icons.image_not_supported,
//                                               ),
//                                       ),
//                                     ),
//                                     DataCell(
//                                       SizedBox(
//                                         width: 200,
//                                         child: Text(
//                                           data['title'] ?? '',
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ),
//                                     DataCell(Text(data['category'] ?? '')),
//                                     DataCell(Text('₹${data['price'] ?? 0}')),
//                                     DataCell(Text('${data['stock'] ?? 0}')),
//                                     DataCell(
//                                       Row(
//                                         children: [
//                                           IconButton(
//                                             icon: const Icon(
//                                               Icons.edit,
//                                               size: 18,
//                                               color: Colors.blue,
//                                             ),
//                                             onPressed: () => _showProductForm(
//                                               context,
//                                               existing: doc,
//                                             ),
//                                           ),
//                                           IconButton(
//                                             icon: const Icon(
//                                               Icons.delete,
//                                               size: 18,
//                                               color: Colors.red,
//                                             ),
//                                             onPressed: () =>
//                                                 _confirmDelete(context, doc.id),
//                                           ),
//                                         ],
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
// class ProductsScreen extends StatelessWidget {
//   const ProductsScreen({super.key});
//
//   void _showProductForm(BuildContext context, {DocumentSnapshot? existing}) {
//     final titleController = TextEditingController(
//       text: existing?['title'] ?? '',
//     );
//     final priceController = TextEditingController(
//       text: existing != null ? existing['price'].toString() : '',
//     );
//     final imageController = TextEditingController(
//       text: existing?['image'] ?? '',
//     );
//     final stockController = TextEditingController(
//       text: existing != null ? (existing['stock'] ?? 0).toString() : '0',
//     );
//     final descController = TextEditingController(
//       text: existing?['description'] ?? '',
//     );
//
//     final selectedCategory = ValueNotifier<String?>(
//       existing?['category'] as String?,
//     );
//
//     final screenWidth = MediaQuery.of(context).size.width;
//     final dialogWidth = screenWidth < 480 ? screenWidth * 0.85 : 400.0;
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(existing == null ? 'Add Product' : 'Edit Product'),
//         content: SizedBox(
//           width: dialogWidth,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: 'Title'),
//                 ),
//                 TextField(
//                   controller: priceController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: 'Price'),
//                 ),
//                 const SizedBox(height: 8),
//                 StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('categories')
//                       .orderBy('name')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                         child: Text('Loading categories...'),
//                       );
//                     }
//
//                     final categoryNames = snapshot.data!.docs
//                         .map(
//                           (doc) =>
//                               (doc.data() as Map<String, dynamic>)['name']
//                                   as String,
//                         )
//                         .toList();
//
//                     if (categoryNames.isEmpty) {
//                       return const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                         child: Text(
//                           'No categories yet — add one from Categories screen first',
//                           style: TextStyle(color: Colors.red, fontSize: 12),
//                         ),
//                       );
//                     }
//
//                     return ValueListenableBuilder<String?>(
//                       valueListenable: selectedCategory,
//                       builder: (context, value, _) {
//                         final validValue = categoryNames.contains(value)
//                             ? value
//                             : null;
//
//                         return DropdownButtonFormField<String>(
//                           initialValue: validValue,
//                           decoration: const InputDecoration(
//                             labelText: 'Category',
//                           ),
//                           items: categoryNames.map((name) {
//                             return DropdownMenuItem(
//                               value: name,
//                               child: Text(name),
//                             );
//                           }).toList(),
//                           onChanged: (val) => selectedCategory.value = val,
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: stockController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: 'Stock'),
//                 ),
//                 TextField(
//                   controller: imageController,
//                   decoration: const InputDecoration(labelText: 'Image URL'),
//                 ),
//                 TextField(
//                   controller: descController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(labelText: 'Description'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (selectedCategory.value == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please select a category')),
//                 );
//                 return;
//               }
//
//               final data = {
//                 'title': titleController.text.trim(),
//                 'price': double.tryParse(priceController.text.trim()) ?? 0.0,
//                 'category': selectedCategory.value,
//                 'stock': int.tryParse(stockController.text.trim()) ?? 0,
//                 'image': imageController.text.trim(),
//                 'description': descController.text.trim(),
//               };
//
//               final firestore = FirebaseFirestore.instance.collection(
//                 'products',
//               );
//
//               if (existing == null) {
//                 await firestore.add(data);
//               } else {
//                 await firestore.doc(existing.id).update(data);
//               }
//
//               if (context.mounted) Navigator.pop(context);
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _confirmDelete(BuildContext context, String docId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Product'),
//         content: const Text('Are you sure you want to delete this product?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               await FirebaseFirestore.instance
//                   .collection('products')
//                   .doc(docId)
//                   .delete();
//               if (context.mounted) Navigator.pop(context);
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
//         final isNarrow = constraints.maxWidth < 460;
//
//         return Padding(
//           padding: EdgeInsets.all(padding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               isNarrow
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Products',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton.icon(
//                             onPressed: () => _showProductForm(context),
//                             icon: const Icon(Icons.add),
//                             label: const Text('Add Product'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.deepOrange,
//                               foregroundColor: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Products',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         ElevatedButton.icon(
//                           onPressed: () => _showProductForm(context),
//                           icon: const Icon(Icons.add),
//                           label: const Text('Add Product'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.deepOrange,
//                             foregroundColor: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
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
//                         .collection('products')
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(child: Text('No products yet'));
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
//                                     DataColumn(label: Text('Image')),
//                                     DataColumn(label: Text('Title')),
//                                     DataColumn(label: Text('Category')),
//                                     DataColumn(label: Text('Price')),
//                                     DataColumn(label: Text('Stock')),
//                                     DataColumn(label: Text('Actions')),
//                                   ],
//                                   rows: docs.map((doc) {
//                                     final data =
//                                         doc.data() as Map<String, dynamic>;
//                                     return DataRow(
//                                       cells: [
//                                         DataCell(
//                                           SizedBox(
//                                             width: 40,
//                                             height: 40,
//                                             child:
//                                                 data['image'] != null &&
//                                                     data['image']
//                                                         .toString()
//                                                         .isNotEmpty
//                                                 ? Image.network(
//                                                     data['image'],
//                                                     fit: BoxFit.contain,
//                                                     errorBuilder:
//                                                         (
//                                                           _,
//                                                           __,
//                                                           ___,
//                                                         ) => const Icon(
//                                                           Icons.broken_image,
//                                                         ),
//                                                   )
//                                                 : const Icon(
//                                                     Icons.image_not_supported,
//                                                   ),
//                                           ),
//                                         ),
//                                         DataCell(
//                                           SizedBox(
//                                             width: 200,
//                                             child: Text(
//                                               data['title'] ?? '',
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                         ),
//                                         DataCell(Text(data['category'] ?? '')),
//                                         DataCell(
//                                           Text('Rs ${data['price'] ?? 0}'),
//                                         ),
//                                         DataCell(Text('${data['stock'] ?? 0}')),
//                                         DataCell(
//                                           Row(
//                                             children: [
//                                               IconButton(
//                                                 icon: const Icon(
//                                                   Icons.edit,
//                                                   size: 18,
//                                                   color: Colors.blue,
//                                                 ),
//                                                 onPressed: () =>
//                                                     _showProductForm(
//                                                       context,
//                                                       existing: doc,
//                                                     ),
//                                               ),
//                                               IconButton(
//                                                 icon: const Icon(
//                                                   Icons.delete,
//                                                   size: 18,
//                                                   color: Colors.red,
//                                                 ),
//                                                 onPressed: () => _confirmDelete(
//                                                   context,
//                                                   doc.id,
//                                                 ),
//                                               ),
//                                             ],
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../service/Currency_Service.dart';
//
// class ProductsScreen extends StatelessWidget {
//   const ProductsScreen({super.key});
//
//   void _showProductForm(BuildContext context, {DocumentSnapshot? existing}) {
//     final titleController = TextEditingController(
//       text: existing?['title'] ?? '',
//     );
//     final priceController = TextEditingController(
//       text: existing != null ? existing['price'].toString() : '',
//     );
//     final imageController = TextEditingController(
//       text: existing?['image'] ?? '',
//     );
//     final stockController = TextEditingController(
//       text: existing != null ? (existing['stock'] ?? 0).toString() : '0',
//     );
//     final descController = TextEditingController(
//       text: existing?['description'] ?? '',
//     );
//
//     final selectedCategory = ValueNotifier<String?>(
//       existing?['category'] as String?,
//     );
//
//     final screenWidth = MediaQuery.of(context).size.width;
//     final dialogWidth = screenWidth < 480 ? screenWidth * 0.85 : 400.0;
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(existing == null ? 'Add Product' : 'Edit Product'),
//         content: SizedBox(
//           width: dialogWidth,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: 'Title'),
//                 ),
//                 TextField(
//                   controller: priceController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: 'Price'),
//                 ),
//                 const SizedBox(height: 8),
//                 StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('categories')
//                       .orderBy('name')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                         child: Text('Loading categories...'),
//                       );
//                     }
//
//                     final categoryNames = snapshot.data!.docs
//                         .map(
//                           (doc) =>
//                       (doc.data() as Map<String, dynamic>)['name']
//                       as String,
//                     )
//                         .toList();
//
//                     if (categoryNames.isEmpty) {
//                       return const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12),
//                         child: Text(
//                           'No categories yet — add one from Categories screen first',
//                           style: TextStyle(color: Colors.red, fontSize: 12),
//                         ),
//                       );
//                     }
//
//                     return ValueListenableBuilder<String?>(
//                       valueListenable: selectedCategory,
//                       builder: (context, value, _) {
//                         final validValue = categoryNames.contains(value)
//                             ? value
//                             : null;
//
//                         return DropdownButtonFormField<String>(
//                           initialValue: validValue,
//                           decoration: const InputDecoration(
//                             labelText: 'Category',
//                           ),
//                           items: categoryNames.map((name) {
//                             return DropdownMenuItem(
//                               value: name,
//                               child: Text(name),
//                             );
//                           }).toList(),
//                           onChanged: (val) => selectedCategory.value = val,
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: stockController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(labelText: 'Stock'),
//                 ),
//                 TextField(
//                   controller: imageController,
//                   decoration: const InputDecoration(labelText: 'Image URL'),
//                 ),
//                 TextField(
//                   controller: descController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(labelText: 'Description'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (selectedCategory.value == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please select a category')),
//                 );
//                 return;
//               }
//
//               final data = {
//                 'title': titleController.text.trim(),
//                 'price': double.tryParse(priceController.text.trim()) ?? 0.0,
//                 'category': selectedCategory.value,
//                 'stock': int.tryParse(stockController.text.trim()) ?? 0,
//                 'image': imageController.text.trim(),
//                 'description': descController.text.trim(),
//               };
//
//               final firestore = FirebaseFirestore.instance.collection(
//                 'products',
//               );
//
//               if (existing == null) {
//                 await firestore.add(data);
//               } else {
//                 await firestore.doc(existing.id).update(data);
//               }
//
//               if (context.mounted) Navigator.pop(context);
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _confirmDelete(BuildContext context, String docId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Product'),
//         content: const Text('Are you sure you want to delete this product?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               await FirebaseFirestore.instance
//                   .collection('products')
//                   .doc(docId)
//                   .delete();
//               if (context.mounted) Navigator.pop(context);
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
//         final isNarrow = constraints.maxWidth < 460;
//
//         return Padding(
//           padding: EdgeInsets.all(padding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               isNarrow
//                   ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Products',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: () => _showProductForm(context),
//                       icon: const Icon(Icons.add),
//                       label: const Text('Add Product'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepOrange,
//                         foregroundColor: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//                   : Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Products',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _showProductForm(context),
//                     icon: const Icon(Icons.add),
//                     label: const Text('Add Product'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepOrange,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ],
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
//                         .collection('products')
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(child: Text('No products yet'));
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
//                                     DataColumn(label: Text('Image')),
//                                     DataColumn(label: Text('Title')),
//                                     DataColumn(label: Text('Category')),
//                                     DataColumn(label: Text('Price')),
//                                     DataColumn(label: Text('Stock')),
//                                     DataColumn(label: Text('Actions')),
//                                   ],
//                                   rows: docs.map((doc) {
//                                     final data =
//                                     doc.data() as Map<String, dynamic>;
//                                     return DataRow(
//                                       cells: [
//                                         DataCell(
//                                           SizedBox(
//                                             width: 40,
//                                             height: 40,
//                                             child:
//                                             data['image'] != null &&
//                                                 data['image']
//                                                     .toString()
//                                                     .isNotEmpty
//                                                 ? Image.network(
//                                               data['image'],
//                                               fit: BoxFit.contain,
//                                               errorBuilder:
//                                                   (
//                                                   _,
//                                                   __,
//                                                   ___,
//                                                   ) => const Icon(
//                                                 Icons.broken_image,
//                                               ),
//                                             )
//                                                 : const Icon(
//                                               Icons.image_not_supported,
//                                             ),
//                                           ),
//                                         ),
//                                         DataCell(
//                                           SizedBox(
//                                             width: 200,
//                                             child: Text(
//                                               data['title'] ?? '',
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                         ),
//                                         DataCell(Text(data['category'] ?? '')),
//                                         DataCell(
//                                           ValueListenableBuilder<String>(
//                                             valueListenable:
//                                             CurrencyService.instance.symbol,
//                                             builder: (context, currency, _) {
//                                               return Text(
//                                                 '$currency ${data['price'] ?? 0}',
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                         DataCell(Text('${data['stock'] ?? 0}')),
//                                         DataCell(
//                                           Row(
//                                             children: [
//                                               IconButton(
//                                                 icon: const Icon(
//                                                   Icons.edit,
//                                                   size: 18,
//                                                   color: Colors.blue,
//                                                 ),
//                                                 onPressed: () =>
//                                                     _showProductForm(
//                                                       context,
//                                                       existing: doc,
//                                                     ),
//                                               ),
//                                               IconButton(
//                                                 icon: const Icon(
//                                                   Icons.delete,
//                                                   size: 18,
//                                                   color: Colors.red,
//                                                 ),
//                                                 onPressed: () => _confirmDelete(
//                                                   context,
//                                                   doc.id,
//                                                 ),
//                                               ),
//                                             ],
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

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  void _showProductForm(BuildContext context, {DocumentSnapshot? existing}) {
    final titleController = TextEditingController(
      text: existing?['title'] ?? '',
    );
    final priceController = TextEditingController(
      text: existing != null ? existing['price'].toString() : '',
    );
    final discountPriceController = TextEditingController(
      text:
          existing != null &&
              (existing.data() as Map<String, dynamic>)['discountPrice'] != null
          ? existing['discountPrice'].toString()
          : '',
    );
    final imageController = TextEditingController(
      text: existing?['image'] ?? '',
    );
    final stockController = TextEditingController(
      text: existing != null ? (existing['stock'] ?? 0).toString() : '0',
    );
    final descController = TextEditingController(
      text: existing?['description'] ?? '',
    );

    final selectedCategory = ValueNotifier<String?>(
      existing?['category'] as String?,
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth < 480 ? screenWidth * 0.85 : 400.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add Product' : 'Edit Product'),
        content: SizedBox(
          width: dialogWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: discountPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText:
                        'Discount Price (optional — leave empty for no sale)',
                  ),
                ),
                const SizedBox(height: 8),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .orderBy('name')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Loading categories...'),
                      );
                    }

                    final categoryNames = snapshot.data!.docs
                        .map(
                          (doc) =>
                              (doc.data() as Map<String, dynamic>)['name']
                                  as String,
                        )
                        .toList();

                    if (categoryNames.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'No categories yet — add one from Categories screen first',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      );
                    }

                    return ValueListenableBuilder<String?>(
                      valueListenable: selectedCategory,
                      builder: (context, value, _) {
                        final validValue = categoryNames.contains(value)
                            ? value
                            : null;

                        return DropdownButtonFormField<String>(
                          initialValue: validValue,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                          items: categoryNames.map((name) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (val) => selectedCategory.value = val,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stock'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedCategory.value == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a category')),
                );
                return;
              }

              final discountText = discountPriceController.text.trim();

              final data = {
                'title': titleController.text.trim(),
                'price': double.tryParse(priceController.text.trim()) ?? 0.0,
                'discountPrice': discountText.isEmpty
                    ? null
                    : double.tryParse(discountText),
                'category': selectedCategory.value,
                'stock': int.tryParse(stockController.text.trim()) ?? 0,
                'image': imageController.text.trim(),
                'description': descController.text.trim(),
              };

              final firestore = FirebaseFirestore.instance.collection(
                'products',
              );

              if (existing == null) {
                await firestore.add(data);
              } else {
                await firestore.doc(existing.id).update(data);
              }

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('products')
                  .doc(docId)
                  .delete();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
        final isNarrow = constraints.maxWidth < 460;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Products',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showProductForm(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Product'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Products',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showProductForm(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Product'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
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
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No products yet'));
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
                                    DataColumn(label: Text('Image')),
                                    DataColumn(label: Text('Title')),
                                    DataColumn(label: Text('Category')),
                                    DataColumn(label: Text('Price')),
                                    DataColumn(label: Text('Stock')),
                                    DataColumn(label: Text('Actions')),
                                  ],
                                  rows: docs.map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child:
                                                data['image'] != null &&
                                                    data['image']
                                                        .toString()
                                                        .isNotEmpty
                                                ? Image.network(
                                                    data['image'],
                                                    fit: BoxFit.contain,
                                                    errorBuilder:
                                                        (
                                                          _,
                                                          __,
                                                          ___,
                                                        ) => const Icon(
                                                          Icons.broken_image,
                                                        ),
                                                  )
                                                : const Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              data['title'] ?? '',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(data['category'] ?? '')),
                                        DataCell(
                                          ValueListenableBuilder<String>(
                                            valueListenable:
                                                CurrencyService.instance.symbol,
                                            builder: (context, currency, _) {
                                              final discountPrice =
                                                  data['discountPrice'];
                                              final hasDiscount =
                                                  discountPrice != null &&
                                                  (discountPrice as num) > 0;

                                              if (!hasDiscount) {
                                                return Text(
                                                  '$currency ${data['price'] ?? 0}',
                                                );
                                              }

                                              final originalPrice =
                                                  (data['price'] as num?)
                                                      ?.toDouble() ??
                                                  0;
                                              final percentOff =
                                                  originalPrice > 0
                                                  ? (((originalPrice -
                                                                    discountPrice) /
                                                                originalPrice) *
                                                            100)
                                                        .round()
                                                  : 0;

                                              return Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '$currency ${data['price'] ?? 0}',
                                                    style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    '$currency $discountPrice',
                                                    style: const TextStyle(
                                                      color: Colors.deepOrange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red[50],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '$percentOff% off',
                                                      style: TextStyle(
                                                        color: Colors.red[700],
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        DataCell(Text('${data['stock'] ?? 0}')),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 18,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () =>
                                                    _showProductForm(
                                                      context,
                                                      existing: doc,
                                                    ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 18,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () => _confirmDelete(
                                                  context,
                                                  doc.id,
                                                ),
                                              ),
                                            ],
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
