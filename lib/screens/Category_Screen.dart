// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class CategoriesScreen extends StatelessWidget {
//   const CategoriesScreen({super.key});
//
//   void _showCategoryForm(BuildContext context, {DocumentSnapshot? existing}) {
//     final nameController = TextEditingController(text: existing?['name'] ?? '');
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(existing == null ? 'Add Category' : 'Edit Category'),
//         content: SizedBox(
//           width: 350,
//           child: TextField(
//             controller: nameController,
//             decoration: const InputDecoration(labelText: 'Category Name'),
//             autofocus: true,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final name = nameController.text.trim();
//               if (name.isEmpty) return;
//
//               final firestore = FirebaseFirestore.instance.collection(
//                 'categories',
//               );
//
//               if (existing == null) {
//                 await firestore.add({'name': name});
//               } else {
//                 await firestore.doc(existing.id).update({'name': name});
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
//         title: const Text('Delete Category'),
//         content: const Text('Are you sure you want to delete this category?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               await FirebaseFirestore.instance
//                   .collection('categories')
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
//                 'Categories',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () => _showCategoryForm(context),
//                 icon: const Icon(Icons.add),
//                 label: const Text('Add Category'),
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
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('categories')
//                     .orderBy('name')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text('No categories yet'));
//                   }
//
//                   final docs = snapshot.data!.docs;
//
//                   return ListView.separated(
//                     padding: const EdgeInsets.all(8),
//                     itemCount: docs.length,
//                     separatorBuilder: (_, __) => const Divider(height: 1),
//                     itemBuilder: (context, index) {
//                       final data = docs[index].data() as Map<String, dynamic>;
//                       return ListTile(
//                         leading: const Icon(
//                           Icons.category_outlined,
//                           color: Colors.deepOrange,
//                         ),
//                         title: Text(data['name'] ?? ''),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.edit,
//                                 size: 18,
//                                 color: Colors.blue,
//                               ),
//                               onPressed: () => _showCategoryForm(
//                                 context,
//                                 existing: docs[index],
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.delete,
//                                 size: 18,
//                                 color: Colors.red,
//                               ),
//                               onPressed: () =>
//                                   _confirmDelete(context, docs[index].id),
//                             ),
//                           ],
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _showCategoryForm(BuildContext context, {DocumentSnapshot? existing}) {
    final nameController = TextEditingController(text: existing?['name'] ?? '');
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth < 480 ? screenWidth * 0.85 : 350.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add Category' : 'Edit Category'),
        content: SizedBox(
          width: dialogWidth,
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Category Name'),
            autofocus: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              final firestore = FirebaseFirestore.instance.collection(
                'categories',
              );

              if (existing == null) {
                await firestore.add({'name': name});
              } else {
                await firestore.doc(existing.id).update({'name': name});
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
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('categories')
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
                          'Categories',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showCategoryForm(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Category'),
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
                          'Categories',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showCategoryForm(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Category'),
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .orderBy('name')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No categories yet'));
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: docs.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;
                          return ListTile(
                            leading: const Icon(
                              Icons.category_outlined,
                              color: Colors.deepOrange,
                            ),
                            title: Text(data['name'] ?? ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showCategoryForm(
                                    context,
                                    existing: docs[index],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      _confirmDelete(context, docs[index].id),
                                ),
                              ],
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
