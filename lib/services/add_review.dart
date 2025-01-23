import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zippy/utils/const.dart';

Future addReview(
    rider, food, experience, comments, orderId, riderId, merchantId) async {
  final docUser = FirebaseFirestore.instance.collection('Reviews').doc();

  final json = {
    'rider': rider,
    'food': food,
    'experience': experience,
    'comments': comments,
    'orderId': orderId,
    'riderId': riderId,
    'merchantId': merchantId,
    'userId': userId,
    'date': DateTime.now(),
    'status': 'Pending',
    'isDeleted': false,
  };

  await docUser.set(json);

  return docUser.id;
}
