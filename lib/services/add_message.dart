import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zippy/utils/const.dart';

Future addMessage(
    riderId, message, riderName, userName, riderProfile, userProfile) async {
  final docUser =
      FirebaseFirestore.instance.collection('Messages').doc(userId + riderId);

  final json = {
    'messages': [
      {'message': message, 'dateTime': DateTime.now(), 'sender': userId}
    ],
    'lastMessage': message,
    'userId': userId,
    'driverId': riderId,
    'dateTime': DateTime.now(),
    'seen': false,
    'driverName': riderName,
    'userName': userName,
    'driverProfile': riderProfile,
    'userProfile': userProfile
  };

  await docUser.set(json);
}
