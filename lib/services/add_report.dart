import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zippy/utils/const.dart';

Future addReport(orderId, type, msg, data) async {
  final docUser = FirebaseFirestore.instance.collection('Reports').doc(orderId);

  final json = {
    'userId': userId,
    'orderId': orderId,
    'type': type,
    'msg': msg,
    'date': DateTime.now(),
    'status': 'Pending',
    'isDeleted': false,
    'orderData': data
  };

  await docUser.set(json);

  return docUser.id;
}
