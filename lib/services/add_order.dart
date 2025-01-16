import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zippy/utils/const.dart';

Future addOrder(
  items,
  merchantId,
  merchantName,
  deliveryAdd,
  double subtotal, //
  isHome,
  remarks,
  tip, //
  mop,
  double deliveryFee, //
  double total, //
) async {
  final docUser = FirebaseFirestore.instance.collection('Orders').doc();

  final json = {
    'userId': userId,
    'merchantId': merchantId,
    'merchantName': merchantName,
    'deliveryAdd': deliveryAdd,
    'subtotal': subtotal,
    'items': items,
    'isHome': isHome,
    'remarks': remarks,
    'tip': tip,
    'mop': mop,
    'deliveryFee': deliveryFee,
    'total': total,
    'date': DateTime.now(),
    'status': 'Pending',
    'driverId': '',
    'isDeleted': false,
  };

  await docUser.set(json);

  return docUser.id;
}
