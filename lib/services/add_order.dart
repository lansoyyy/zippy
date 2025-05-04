import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zippy/utils/const.dart';

Future<String> addOrder(
  List<Map<String, dynamic>> items,
  String merchantId,
  String merchantName,
  String address,
  double subtotal,
  bool isHome,
  String remarks,
  double tip,
  String mop,
  double deliveryFee,
  double total,
  String riderId,
  String customerName,
  String customerNumber, {
  String? orderType,
  bool? isScheduled,
  DateTime? scheduledDateAndTime,
}) async {
  try {
    final scheduledTime = scheduledDateAndTime;

    final orderRef = await FirebaseFirestore.instance.collection('Orders').add({
      'items': items,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'address': address,
      'subtotal': subtotal,
      'isHome': isHome,
      'remarks': remarks,
      'tip': tip,
      'mop': mop,
      'deliveryFee': deliveryFee,
      'total': total,
      'riderId': riderId,
      'customerName': customerName,
      'customerNumber': customerNumber,
      'type': orderType ?? 'Food',
      'status': 'Pending',
      'date': FieldValue.serverTimestamp(),
      'isScheduled': isScheduled ?? false,
      if (scheduledTime != null)
        'scheduledDateAndTime': Timestamp.fromDate(scheduledTime),
    });

    return orderRef.id;
  } catch (e) {
    print('Error adding order: $e');
    rethrow;
  }
}
