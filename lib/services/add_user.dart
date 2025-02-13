import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> addUser({
  required String name,
  required String email,
  required String bday,
  required String number,
  required String home,
  required String homeAddress,
  required num homeLat,
  required num homeLng,
  required String officeAddress,
  required num officeLat,
  required num officeLng,
  required String profile,
  required bool isActive,
  required bool isVerified,
  List<String>? history = const [],
  List<String>? notifications = const [],
  List<String>? favorites = const [], // Added favorites parameter
}) async {
  try {
    final docUser = FirebaseFirestore.instance.collection('Users').doc();

    final json = {
      'uid': docUser.id,
      'name': name,
      'email': email,
      'bday': bday,
      'number': number,
      'home': home,
      'homeAddress': homeAddress,
      'homeLat': homeLat,
      'homeLng': homeLng,
      'officeAddress': officeAddress,
      'officeLat': officeLat,
      'officeLng': officeLng,
      'profile': profile,
      'isActive': isActive,
      'isVerified': isVerified,
      'history': history ?? [],
      'notifications': notifications ?? [],
      'favorites': favorites ?? [],
    };

    await docUser.set(json);
    return docUser.id;
  } catch (e) {
    print("Error adding user: $e");
    return null;
  }
}
