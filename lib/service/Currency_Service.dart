import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CurrencyService {
  CurrencyService._internal();
  static final CurrencyService instance = CurrencyService._internal();

  static const String _fallback = 'Rs';

  final ValueNotifier<String> symbol = ValueNotifier<String>(_fallback);

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  void init() {
    _subscription?.cancel();
    _subscription = FirebaseFirestore.instance
        .collection('settings')
        .doc('general')
        .snapshots()
        .listen(
          (snapshot) {
            final data = snapshot.data();
            final value = data?['currencySymbol'] as String?;
            if (value != null && value.trim().isNotEmpty) {
              symbol.value = value;
            } else {
              symbol.value = _fallback;
            }
          },
          onError: (_) {
            symbol.value = _fallback;
          },
        );
  }

  void dispose() {
    _subscription?.cancel();
  }

  static Future<void> updateCurrency(String newSymbol) {
    return FirebaseFirestore.instance.collection('settings').doc('general').set(
      {'currencySymbol': newSymbol},
      SetOptions(merge: true),
    );
  }
}
