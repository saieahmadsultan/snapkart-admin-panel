// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// import 'Category_Screen.dart';
// import 'Customer_Screen.dart';
// import 'Order_Screen.dart';
// import 'Product_Screen.dart';
// import 'login_screen.dart';
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   int _selectedIndex = 0;
//
//   // ---- Design tokens (kept in one place so the whole look can be tuned fast) ----
//   static const Color _bg = Color(0xFFF3F5F9);
//   static const Color _navy = Color(0xFF12162A);
//   static const Color _navyPanel = Color(0xFF171C33);
//   static const Color _teal = Color(0xFF14B8A6);
//   static const Color _cardBorder = Color(0xFFEBECF2);
//   static const Color _textMuted = Color(0xFF8A8FA3);
//
//   final List<String> _menuTitles = [
//     'Dashboard',
//     'Products',
//     'Orders',
//     'Customers',
//     'Categories',
//   ];
//
//   final List<IconData> _menuIcons = [
//     Icons.dashboard_outlined,
//     Icons.inventory_2_outlined,
//     Icons.shopping_bag_outlined,
//     Icons.people_outline,
//     Icons.category_outlined,
//   ];
//
//   // Palette used to color pie-chart slices / category legend, cycled if more categories exist.
//   final List<Color> _categoryPalette = const [
//     Color(0xFF14B8A6),
//     Color(0xFFFF6B5E),
//     Color(0xFFF2A93B),
//     Color(0xFF6C8CFF),
//     Color(0xFFA26BFF),
//     Color(0xFF3BC9DB),
//     Color(0xFFEA5C9E),
//   ];
//
//   Future<void> _logout() async {
//     await FirebaseAuth.instance.signOut();
//     if (mounted) {
//       Navigator.of(
//         context,
//       ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bg,
//       body: Row(
//         children: [
//           _buildSidebar(),
//           Expanded(
//             child: _selectedIndex == 0
//                 ? _buildDashboardContent()
//                 : _selectedIndex == 1
//                 ? const ProductsScreen()
//                 : _selectedIndex == 2
//                 ? const OrdersScreen()
//                 : _selectedIndex == 3
//                 ? const CustomersScreen()
//                 : _selectedIndex == 4
//                 ? const CategoriesScreen()
//                 : Center(
//                     child: Text(
//                       '${_menuTitles[_selectedIndex]} — coming soon',
//                       style: const TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   // SIDEBAR
//   // ---------------------------------------------------------------------------
//
//   Widget _buildSidebar() {
//     return Container(
//       width: 246,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [_navy, _navyPanel],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.18),
//             blurRadius: 16,
//             offset: const Offset(2, 0),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             child: Row(
//               children: [
//                 Container(
//                   width: 34,
//                   height: 34,
//                   decoration: BoxDecoration(
//                     color: _teal.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(9),
//                   ),
//                   child: const Icon(
//                     Icons.storefront_rounded,
//                     color: _teal,
//                     size: 19,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   'SnapKart Admin',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 30),
//           for (int i = 0; i < _menuTitles.length; i++) _buildMenuItem(i),
//           const Spacer(),
//           Divider(color: Colors.white.withOpacity(0.08), height: 1),
//           const SizedBox(height: 8),
//           _buildLogoutItem(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(int index) {
//     final isSelected = _selectedIndex == index;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(10),
//           onTap: () => setState(() => _selectedIndex = index),
//           hoverColor: Colors.white.withOpacity(0.05),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 180),
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             decoration: BoxDecoration(
//               color: isSelected ? _teal : Colors.transparent,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: isSelected
//                   ? [
//                       BoxShadow(
//                         color: _teal.withOpacity(0.35),
//                         blurRadius: 10,
//                         offset: const Offset(0, 3),
//                       ),
//                     ]
//                   : null,
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   _menuIcons[index],
//                   size: 19,
//                   color: isSelected ? Colors.white : Colors.white54,
//                 ),
//                 const SizedBox(width: 14),
//                 Text(
//                   _menuTitles[index],
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : Colors.white54,
//                     fontSize: 13.5,
//                     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogoutItem() {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: _logout,
//         hoverColor: Colors.white.withOpacity(0.05),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//           child: const Row(
//             children: [
//               Icon(Icons.logout, size: 18, color: Colors.white54),
//               SizedBox(width: 14),
//               Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.white54, fontSize: 13.5),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   // MAIN CONTENT
//   // ---------------------------------------------------------------------------
//
//   Widget _buildDashboardContent() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(32),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Dashboard',
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.w700,
//               color: _navy,
//               letterSpacing: -0.3,
//             ),
//           ),
//           const SizedBox(height: 4),
//           const Text(
//             'Overview of your store performance',
//             style: TextStyle(fontSize: 13.5, color: _textMuted),
//           ),
//           const SizedBox(height: 28),
//           _buildStatsRow(),
//           const SizedBox(height: 36),
//           _buildSectionHeader(
//             'Analytics',
//             'Sales trend for the last 7 days and category performance',
//           ),
//           const SizedBox(height: 18),
//           LayoutBuilder(
//             builder: (context, constraints) {
//               final isNarrow = constraints.maxWidth < 760;
//               final salesChart = _buildWeeklySalesChart();
//               final categoryChart = _buildCategoryPieChart();
//               if (isNarrow) {
//                 return Column(
//                   children: [
//                     salesChart,
//                     const SizedBox(height: 20),
//                     categoryChart,
//                   ],
//                 );
//               }
//               return IntrinsicHeight(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Expanded(flex: 3, child: salesChart),
//                     const SizedBox(width: 20),
//                     Expanded(flex: 2, child: categoryChart),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title, String subtitle) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.w700,
//             color: _navy,
//           ),
//         ),
//         const SizedBox(height: 3),
//         Text(
//           subtitle,
//           style: const TextStyle(fontSize: 12.5, color: _textMuted),
//         ),
//       ],
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   // STAT CARDS
//   // ---------------------------------------------------------------------------
//
//   Widget _buildStatsRow() {
//     return Row(
//       children: [
//         StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('products').snapshots(),
//           builder: (context, snapshot) {
//             final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
//             return _buildStatCard(
//               icon: Icons.inventory_2_outlined,
//               label: 'Total Products',
//               value: snapshot.connectionState == ConnectionState.waiting
//                   ? '...'
//                   : '$count',
//               color: const Color(0xFFFF6B5E),
//               bgColor: const Color(0xFFFFEDEB),
//             );
//           },
//         ),
//         const SizedBox(width: 18),
//         StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('orders').snapshots(),
//           builder: (context, snapshot) {
//             final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
//             return _buildStatCard(
//               icon: Icons.shopping_bag_outlined,
//               label: 'Total Orders',
//               value: snapshot.connectionState == ConnectionState.waiting
//                   ? '...'
//                   : '$count',
//               color: const Color(0xFFF2A93B),
//               bgColor: const Color(0xFFFDF2DF),
//             );
//           },
//         ),
//         const SizedBox(width: 18),
//         StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('users').snapshots(),
//           builder: (context, snapshot) {
//             final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
//             return _buildStatCard(
//               icon: Icons.people_outline,
//               label: 'Total Customers',
//               value: snapshot.connectionState == ConnectionState.waiting
//                   ? '...'
//                   : '$count',
//               color: _teal,
//               bgColor: const Color(0xFFE3F7F5),
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatCard({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//     required Color bgColor,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(22),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: _cardBorder),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.035),
//               blurRadius: 14,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: bgColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 22),
//             ),
//             const SizedBox(height: 18),
//             Text(
//               label,
//               style: const TextStyle(fontSize: 13, color: _textMuted),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 27,
//                 fontWeight: FontWeight.w700,
//                 color: _navy,
//                 letterSpacing: -0.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   // SHARED CHART CARD WRAPPER
//   // ---------------------------------------------------------------------------
//
//   Widget _buildChartCard({
//     required String title,
//     required String subtitle,
//     required Widget child,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(22),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: _cardBorder),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.035),
//             blurRadius: 14,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 14.5,
//               fontWeight: FontWeight.w700,
//               color: _navy,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             subtitle,
//             style: const TextStyle(fontSize: 12, color: _textMuted),
//           ),
//           const SizedBox(height: 18),
//           child,
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------------------------------------------------------
//   // WEEKLY SALES LINE CHART
//   // ---------------------------------------------------------------------------
//   // Assumes each doc in `orders` has:
//   //   - totalAmount : number
//   //   - createdAt   : Timestamp
//   // Adjust the field names below if your schema differs.
//
//   Widget _buildWeeklySalesChart() {
//     final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 6));
//     final startOfRange = DateTime(
//       sevenDaysAgo.year,
//       sevenDaysAgo.month,
//       sevenDaysAgo.day,
//     );
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('orders')
//           .where(
//             'createdAt',
//             isGreaterThanOrEqualTo: Timestamp.fromDate(startOfRange),
//           )
//           .snapshots(),
//       builder: (context, snapshot) {
//         // Bucket totals per day (0 = 6 days ago ... 6 = today)
//         final List<double> dailyTotals = List.filled(7, 0);
//         final List<String> dayLabels = [];
//         for (int i = 6; i >= 0; i--) {
//           final d = DateTime.now().subtract(Duration(days: i));
//           dayLabels.add(_weekdayShort(d.weekday));
//         }
//
//         if (snapshot.hasData) {
//           for (final doc in snapshot.data!.docs) {
//             final data = doc.data() as Map<String, dynamic>;
//             final ts = data['createdAt'];
//             final amount = (data['totalAmount'] ?? 0);
//             if (ts is Timestamp && amount is num) {
//               final orderDate = ts.toDate();
//               final diff = DateTime(
//                 orderDate.year,
//                 orderDate.month,
//                 orderDate.day,
//               ).difference(startOfRange).inDays;
//               if (diff >= 0 && diff <= 6) {
//                 dailyTotals[diff] += amount.toDouble();
//               }
//             }
//           }
//         }
//
//         final maxY = (dailyTotals.reduce((a, b) => a > b ? a : b)) * 1.25;
//         final safeMaxY = maxY <= 0 ? 10.0 : maxY;
//
//         final spots = <FlSpot>[
//           for (int i = 0; i < 7; i++) FlSpot(i.toDouble(), dailyTotals[i]),
//         ];
//
//         return _buildChartCard(
//           title: 'Weekly Sales',
//           subtitle: 'Total order value per day (last 7 days)',
//           child: SizedBox(
//             height: 240,
//             child: snapshot.connectionState == ConnectionState.waiting
//                 ? const Center(child: CircularProgressIndicator(color: _teal))
//                 : LineChart(
//                     LineChartData(
//                       minX: 0,
//                       maxX: 6,
//                       minY: 0,
//                       maxY: safeMaxY,
//                       gridData: FlGridData(
//                         show: true,
//                         drawVerticalLine: false,
//                         horizontalInterval: safeMaxY / 4,
//                         getDrawingHorizontalLine: (value) =>
//                             FlLine(color: _cardBorder, strokeWidth: 1),
//                       ),
//                       borderData: FlBorderData(show: false),
//                       titlesData: FlTitlesData(
//                         topTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                         rightTitles: const AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 38,
//                             interval: safeMaxY / 4,
//                             getTitlesWidget: (value, meta) => Text(
//                               value.toInt().toString(),
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 color: _textMuted,
//                               ),
//                             ),
//                           ),
//                         ),
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 26,
//                             interval: 1,
//                             getTitlesWidget: (value, meta) {
//                               // Only draw a label exactly on whole-day values (0..6).
//                               // Without this check fl_chart can call this widget at
//                               // fractional positions too, which caused duplicated
//                               // day labels (Mon Mon Tue Tue ...).
//                               if ((value - value.roundToDouble()).abs() >
//                                   0.01) {
//                                 return const SizedBox.shrink();
//                               }
//                               final i = value.round();
//                               if (i < 0 || i > 6)
//                                 return const SizedBox.shrink();
//                               return Padding(
//                                 padding: const EdgeInsets.only(top: 6),
//                                 child: Text(
//                                   dayLabels[i],
//                                   style: const TextStyle(
//                                     fontSize: 10.5,
//                                     color: _textMuted,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: spots,
//                           isCurved: true,
//                           curveSmoothness: 0.15,
//                           preventCurveOverShooting: true,
//                           color: _teal,
//                           barWidth: 3,
//                           dotData: FlDotData(
//                             show: true,
//                             getDotPainter: (spot, percent, bar, index) =>
//                                 FlDotCirclePainter(
//                                   radius: 3.5,
//                                   color: _teal,
//                                   strokeWidth: 2,
//                                   strokeColor: Colors.white,
//                                 ),
//                           ),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             color: _teal.withOpacity(0.12),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//         );
//       },
//     );
//   }
//
//   String _weekdayShort(int weekday) {
//     const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//     return names[weekday - 1];
//   }
//
//   // ---------------------------------------------------------------------------
//   // CATEGORY PIE CHART
//   // ---------------------------------------------------------------------------
//   // Groups `products` docs by their `category` field. If you want this to
//   // reflect actual sales-by-category instead of product-count-by-category,
//   // point it at your orders' line items and sum quantity/amount instead.
//
//   Widget _buildCategoryPieChart() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('products').snapshots(),
//       builder: (context, snapshot) {
//         final Map<String, int> counts = {};
//         if (snapshot.hasData) {
//           for (final doc in snapshot.data!.docs) {
//             final data = doc.data() as Map<String, dynamic>;
//             final category = (data['category'] ?? 'Uncategorized').toString();
//             counts[category] = (counts[category] ?? 0) + 1;
//           }
//         }
//
//         final total = counts.values.fold<int>(0, (a, b) => a + b);
//         final entries = counts.entries.toList()
//           ..sort((a, b) => b.value.compareTo(a.value));
//
//         return _buildChartCard(
//           title: 'Products by Category',
//           subtitle: 'Share of catalog per category',
//           child: snapshot.connectionState == ConnectionState.waiting
//               ? const SizedBox(
//                   height: 240,
//                   child: Center(child: CircularProgressIndicator(color: _teal)),
//                 )
//               : total == 0
//               ? const SizedBox(
//                   height: 240,
//                   child: Center(
//                     child: Text(
//                       'No product data yet',
//                       style: TextStyle(fontSize: 12.5, color: _textMuted),
//                     ),
//                   ),
//                 )
//               : Column(
//                   children: [
//                     SizedBox(
//                       height: 170,
//                       child: PieChart(
//                         PieChartData(
//                           sectionsSpace: 2,
//                           centerSpaceRadius: 42,
//                           sections: [
//                             for (int i = 0; i < entries.length; i++)
//                               PieChartSectionData(
//                                 value: entries[i].value.toDouble(),
//                                 color:
//                                     _categoryPalette[i %
//                                         _categoryPalette.length],
//                                 radius: 46,
//                                 title:
//                                     '${((entries[i].value / total) * 100).round()}%',
//                                 titleStyle: const TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Wrap(
//                       spacing: 14,
//                       runSpacing: 8,
//                       children: [
//                         for (int i = 0; i < entries.length; i++)
//                           _buildLegendChip(
//                             color:
//                                 _categoryPalette[i % _categoryPalette.length],
//                             label: entries[i].key,
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//         );
//       },
//     );
//   }
//
//   Widget _buildLegendChip({required Color color, required String label}) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 9,
//           height: 9,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 6),
//         Text(label, style: const TextStyle(fontSize: 12, color: _navy)),
//       ],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'Category_Screen.dart';
import 'Customer_Screen.dart';
import 'Order_Screen.dart';
import 'Product_Screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const double _mobileBreakpoint = 800;

  static const Color _bg = Color(0xFFF3F5F9);
  static const Color _navy = Color(0xFF12162A);
  static const Color _navyPanel = Color(0xFF171C33);
  static const Color _teal = Color(0xFF14B8A6);
  static const Color _cardBorder = Color(0xFFEBECF2);
  static const Color _textMuted = Color(0xFF8A8FA3);

  final List<String> _menuTitles = [
    'Dashboard',
    'Products',
    'Orders',
    'Customers',
    'Categories',
  ];

  final List<IconData> _menuIcons = [
    Icons.dashboard_outlined,
    Icons.inventory_2_outlined,
    Icons.shopping_bag_outlined,
    Icons.people_outline,
    Icons.category_outlined,
  ];

  final List<Color> _categoryPalette = const [
    Color(0xFF14B8A6),
    Color(0xFFFF6B5E),
    Color(0xFFF2A93B),
    Color(0xFF6C8CFF),
    Color(0xFFA26BFF),
    Color(0xFF3BC9DB),
    Color(0xFFEA5C9E),
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  Widget get _currentScreen {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return const ProductsScreen();
      case 2:
        return const OrdersScreen();
      case 3:
        return const CustomersScreen();
      case 4:
        return const CategoriesScreen();
      default:
        return Center(
          child: Text(
            '${_menuTitles[_selectedIndex]} — coming soon',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < _mobileBreakpoint;

        if (isMobile) {
          return Scaffold(
            backgroundColor: _bg,
            appBar: AppBar(
              backgroundColor: _navy,
              foregroundColor: Colors.white,
              title: Text(_menuTitles[_selectedIndex]),
            ),
            drawer: Drawer(
              width: 260,
              child: _buildSidebarContent(isDrawer: true),
            ),
            body: SafeArea(child: _currentScreen),
          );
        }
        return Scaffold(
          backgroundColor: _bg,
          body: Row(
            children: [
              SizedBox(
                width: 246,
                child: _buildSidebarContent(isDrawer: false),
              ),
              Expanded(child: _currentScreen),
            ],
          ),
        );
      },
    );
  }


  Widget _buildSidebarContent({required bool isDrawer}) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _navyPanel],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: isDrawer
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(2, 0),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _teal.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: _teal,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SnapKart Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            for (int i = 0; i < _menuTitles.length; i++)
              _buildMenuItem(i, isDrawer: isDrawer),
            const Spacer(),
            Divider(color: Colors.white.withOpacity(0.08), height: 1),
            const SizedBox(height: 8),
            _buildLogoutItem(isDrawer: isDrawer),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index, {required bool isDrawer}) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() => _selectedIndex = index);
            // Drawer mein item select hote hi close ho jaye
            if (isDrawer) Navigator.of(context).pop();
          },
          hoverColor: Colors.white.withOpacity(0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? _teal : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: _teal.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  _menuIcons[index],
                  size: 19,
                  color: isSelected ? Colors.white : Colors.white54,
                ),
                const SizedBox(width: 14),
                Text(
                  _menuTitles[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutItem({required bool isDrawer}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (isDrawer) Navigator.of(context).pop();
          _logout();
        },
        hoverColor: Colors.white.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: const Row(
            children: [
              Icon(Icons.logout, size: 18, color: Colors.white54),
              SizedBox(width: 14),
              Text(
                'Logout',
                style: TextStyle(color: Colors.white54, fontSize: 13.5),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDashboardContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 500 ? 16.0 : 32.0;
        return SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Overview of your store performance',
                style: TextStyle(fontSize: 13.5, color: _textMuted),
              ),
              const SizedBox(height: 28),
              _buildStatsRow(constraints.maxWidth),
              const SizedBox(height: 36),
              _buildSectionHeader(
                'Analytics',
                'Sales trend for the last 7 days and category performance',
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, chartConstraints) {
                  final isNarrow = chartConstraints.maxWidth < 760;
                  final salesChart = _buildWeeklySalesChart();
                  final categoryChart = _buildCategoryPieChart();
                  if (isNarrow) {
                    return Column(
                      children: [
                        salesChart,
                        const SizedBox(height: 20),
                        categoryChart,
                      ],
                    );
                  }
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 3, child: salesChart),
                        const SizedBox(width: 20),
                        Expanded(flex: 2, child: categoryChart),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _navy,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12.5, color: _textMuted),
        ),
      ],
    );
  }

  Widget _buildStatsRow(double maxWidth) {
    final cards = [
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
          return _buildStatCard(
            icon: Icons.inventory_2_outlined,
            label: 'Total Products',
            value: snapshot.connectionState == ConnectionState.waiting
                ? '...'
                : '$count',
            color: const Color(0xFFFF6B5E),
            bgColor: const Color(0xFFFFEDEB),
          );
        },
      ),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
          return _buildStatCard(
            icon: Icons.shopping_bag_outlined,
            label: 'Total Orders',
            value: snapshot.connectionState == ConnectionState.waiting
                ? '...'
                : '$count',
            color: const Color(0xFFF2A93B),
            bgColor: const Color(0xFFFDF2DF),
          );
        },
      ),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
          return _buildStatCard(
            icon: Icons.people_outline,
            label: 'Total Customers',
            value: snapshot.connectionState == ConnectionState.waiting
                ? '...'
                : '$count',
            color: _teal,
            bgColor: const Color(0xFFE3F7F5),
          );
        },
      ),
    ];

    // 520px se neeche: cards ek column mein stack (poori width le lein)
    // 520-900px: 2 per row
    // 900px+: teeno ek row mein (original behaviour)
    if (maxWidth < 520) {
      return Column(
        children: [
          for (final c in cards) ...[
            SizedBox(width: double.infinity, child: c),
            const SizedBox(height: 18),
          ],
        ],
      );
    }

    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: [
        for (final c in cards)
          SizedBox(
            width: maxWidth < 900 ? (maxWidth - 18) / 2 : (maxWidth - 36) / 3,
            child: c,
          ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 18),
          Text(label, style: const TextStyle(fontSize: 13, color: _textMuted)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w700,
              color: _navy,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: _textMuted),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WEEKLY SALES LINE CHART
  // ---------------------------------------------------------------------------

  Widget _buildWeeklySalesChart() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 6));
    final startOfRange = DateTime(
      sevenDaysAgo.year,
      sevenDaysAgo.month,
      sevenDaysAgo.day,
    );

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfRange),
          )
          .snapshots(),
      builder: (context, snapshot) {
        final List<double> dailyTotals = List.filled(7, 0);
        final List<String> dayLabels = [];
        for (int i = 6; i >= 0; i--) {
          final d = DateTime.now().subtract(Duration(days: i));
          dayLabels.add(_weekdayShort(d.weekday));
        }

        if (snapshot.hasData) {
          for (final doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final ts = data['createdAt'];
            final amount = (data['totalAmount'] ?? 0);
            if (ts is Timestamp && amount is num) {
              final orderDate = ts.toDate();
              final diff = DateTime(
                orderDate.year,
                orderDate.month,
                orderDate.day,
              ).difference(startOfRange).inDays;
              if (diff >= 0 && diff <= 6) {
                dailyTotals[diff] += amount.toDouble();
              }
            }
          }
        }

        final maxY = (dailyTotals.reduce((a, b) => a > b ? a : b)) * 1.25;
        final safeMaxY = maxY <= 0 ? 10.0 : maxY;

        final spots = <FlSpot>[
          for (int i = 0; i < 7; i++) FlSpot(i.toDouble(), dailyTotals[i]),
        ];

        return _buildChartCard(
          title: 'Weekly Sales',
          subtitle: 'Total order value per day (last 7 days)',
          child: SizedBox(
            height: 240,
            child: snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator(color: _teal))
                : LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: safeMaxY,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: safeMaxY / 4,
                        getDrawingHorizontalLine: (value) =>
                            FlLine(color: _cardBorder, strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 38,
                            interval: safeMaxY / 4,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: _textMuted,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 26,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              if ((value - value.roundToDouble()).abs() >
                                  0.01) {
                                return const SizedBox.shrink();
                              }
                              final i = value.round();
                              if (i < 0 || i > 6)
                                return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  dayLabels[i],
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: _textMuted,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.15,
                          preventCurveOverShooting: true,
                          color: _teal,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, index) =>
                                FlDotCirclePainter(
                                  radius: 3.5,
                                  color: _teal,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: _teal.withOpacity(0.12),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  String _weekdayShort(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  Widget _buildCategoryPieChart() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        final Map<String, int> counts = {};
        if (snapshot.hasData) {
          for (final doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final category = (data['category'] ?? 'Uncategorized').toString();
            counts[category] = (counts[category] ?? 0) + 1;
          }
        }

        final total = counts.values.fold<int>(0, (a, b) => a + b);
        final entries = counts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return _buildChartCard(
          title: 'Products by Category',
          subtitle: 'Share of catalog per category',
          child: snapshot.connectionState == ConnectionState.waiting
              ? const SizedBox(
                  height: 240,
                  child: Center(child: CircularProgressIndicator(color: _teal)),
                )
              : total == 0
              ? const SizedBox(
                  height: 240,
                  child: Center(
                    child: Text(
                      'No product data yet',
                      style: TextStyle(fontSize: 12.5, color: _textMuted),
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 170,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 42,
                          sections: [
                            for (int i = 0; i < entries.length; i++)
                              PieChartSectionData(
                                value: entries[i].value.toDouble(),
                                color:
                                    _categoryPalette[i %
                                        _categoryPalette.length],
                                radius: 46,
                                title:
                                    '${((entries[i].value / total) * 100).round()}%',
                                titleStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 14,
                      runSpacing: 8,
                      children: [
                        for (int i = 0; i < entries.length; i++)
                          _buildLegendChip(
                            color:
                                _categoryPalette[i % _categoryPalette.length],
                            label: entries[i].key,
                          ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildLegendChip({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: _navy)),
      ],
    );
  }
}
